import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'RegisterPage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isAdmin = false;
  
  bool _loginError = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleRole(bool isAdmin) {
    setState(() {
      _isAdmin = isAdmin;
      _emailController.clear();
      _passwordController.clear();
      _loginError = false;
    });
  }

  void _login() async {
  if (_formKey.currentState!.validate()) {
    if (_isAdmin) {
      try {
        // Paso 1: Autenticación con FirebaseAuth
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Paso 2: Validar en Firestore que realmente sea admin
        final snapshot = await FirebaseFirestore.instance
            .collection('admin')
            .where('correo', isEqualTo: _emailController.text.trim())
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final docRef = snapshot.docs.first.reference;

          // 🔹 Guardar la contraseña con la que inició sesión
          await docRef.update({'contrasena': _passwordController.text.trim()});

          Navigator.pushNamedAndRemoveUntil(
            context, '/inicio_admin', (route) => false,
          );
        } else {
          setState(() {
            _loginError = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este usuario no tiene rol de administrador')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de autenticación: ${e.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado: $e')),
        );
      }
    } else {
      try {
        // Paso 1: Autenticar con FirebaseAuth
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Paso 2: Buscar en Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .where('correo', isEqualTo: _emailController.text.trim())
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final docRef = snapshot.docs.first.reference;
          final userData = snapshot.docs.first.data();
          final username = userData['nombre'];

          // 🔹 Guardar siempre la contraseña con la que inició sesión
          await docRef.update({'contrasena': _passwordController.text.trim()});

          // Paso 3: Navegar
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/inicio',
            (route) => false,
            arguments: {'username': username},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario no encontrado en Firestore.')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de autenticación: ${e.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado: $e')),
        );
      }
    }
  }
}

  /// 🔹 Recuperar contraseña con FirebaseAuth
 Future<void> _resetPassword() async {
  if (_emailController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ingrese su correo electrónico para recuperar la contraseña')),
    );
    return;
  }

  // 🔹 Mostrar política antes de enviar el correo
  bool continuar = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Política de Seguridad'),
      content: const Text(
        'Al cambiar su contraseña, asegúrese de que cumpla con los siguientes requisitos:\n\n'
        '- Longitud mínima: 8 caracteres\n'
        '- Incluir mayúsculas y minúsculas\n'
        '- Incluir números\n'
        '- Incluir caracteres especiales (por ejemplo: !@#\$%)\n\n'
        '¿Desea continuar y recibir el correo para restablecer la contraseña?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Continuar'),
        ),
      ],
    ),
  ) ?? false;

  if (!continuar) return;

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: _emailController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Se envió un enlace de recuperación a su correo')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al enviar el correo: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue.shade300,
                Colors.blue.shade700,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Icon(
                    Icons.shopping_bag,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Catálogo de Productos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Selector de rol
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _toggleRole(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: !_isAdmin 
                                  ? Colors.white.withOpacity(0.3) 
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Usuario',
                              style: TextStyle(
                                color: !_isAdmin 
                                    ? Colors.white 
                                    : Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleRole(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _isAdmin 
                                  ? Colors.white.withOpacity(0.3) 
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Administrador',
                              style: TextStyle(
                                color: _isAdmin 
                                    ? Colors.white 
                                    : Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Formulario
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!_isAdmin)
                              Column(
                                children: [
                                  TextFormField(
                                    controller: _usernameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Nombre de usuario',
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (!_isAdmin && (value == null || value.isEmpty)) {
                                        return 'Ingrese su nombre de usuario';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese su correo electrónico';
                                }
                                if (!value.contains('@')) {
                                  return 'Correo electrónico inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese su contraseña';
                                }
                                if (value.length < 6) {
                                  return 'Mínimo 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            if (_loginError)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Credenciales de administrador incorrectas',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isAdmin 
                                      ? Colors.redAccent 
                                      : Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  _isAdmin 
                                      ? 'INICIAR SESIÓN COMO ADMIN' 
                                      : 'INICIAR SESIÓN',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 🔹 Botón Olvidaste tu contraseña
                            TextButton(
                              onPressed: _resetPassword,
                              child: const Text('¿Olvidaste tu contraseña?'),
                            ),

                            if (!_isAdmin)
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context, '/register', (route) => false,
                                  );
                                },
                                child: const Text('¿No tienes cuenta? Regístrate'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
      ),
      body: const Center(
        child: Text('Bienvenido al catálogo'),
      ),
    );
  }
}
