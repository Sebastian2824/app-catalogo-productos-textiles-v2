import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4FC3F7), // Azul claro
                Color(0xFF1976D2), // Azul más oscuro
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Logo o título de la app
                  const Icon(
                    Icons.shopping_bag,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Formulario de registro
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
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre completo',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su nombre';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su correo';
                                }
                                if (!value.contains('@')) {
                                  return 'Ingrese un correo válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                              icon: Icon(
                              _obscurePassword
                             ? Icons.visibility_outlined
                             : Icons.visibility_off_outlined,
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
                        return 'Por favor ingrese una contraseña';
                         }
                        // Expresión regular para validar:
                        // - Mínimo 8 caracteres
                        // - Al menos una mayúscula, una minúscula, un número y un caracter especial
                        final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

                        if (!regex.hasMatch(value)) {
                        return 'La contraseña no cumple los requisitos de seguridad';
                       }
                        return null;
                         },
                        ),
                       const SizedBox(height: 8),

                       // Botón que muestra las políticas de seguridad en un dialog
                       Align(
                        alignment: Alignment.centerLeft,
                         child: TextButton.icon(
                          onPressed: () {
                           showDialog(
                            context: context,
                              builder: (context) => AlertDialog(
                               title: const Text('Políticas de Contraseña'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('La contraseña debe cumplir con lo siguiente:'),
              SizedBox(height: 10),
              Text('• Longitud mínima: 8 caracteres'),
              Text('• Incluir al menos una letra mayúscula'),
              Text('• Incluir al menos una letra minúscula'),
              Text('• Incluir al menos un número'),
              Text('• Incluir al menos un caracter especial (!@#\$%^&*)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    },
    icon: const Icon(Icons.info_outline, color: Colors.blue),
    label: const Text(
      'Ver políticas de seguridad',
      style: TextStyle(color: Colors.blue),
    ),
  ),
),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirmar contraseña',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscureConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor confirme su contraseña';
                                }
                                if (value != _passwordController.text) {
                                  return 'Las contraseñas no coinciden';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
  if (_formKey.currentState!.validate()) {
    try {
      // Paso 1: Registrar con FirebaseAuth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Paso 2: Guardar datos adicionales en Firestore
      await FirebaseFirestore.instance.collection('usuarios').add({
        'nombre': _nameController.text.trim(),
        'correo': _emailController.text.trim(),
        'contrasena': _passwordController.text.trim(), // 🔒 Ideal: encriptar en producción
        'fecha_registro': Timestamp.now(),
      });

      // Paso 3: Notificar éxito y redirigir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado correctamente')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context, '/login', (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // Errores comunes de autenticación
      String mensaje = 'Error al registrar: ${e.message}';
      if (e.code == 'email-already-in-use') {
        mensaje = 'Este correo ya está registrado.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    } catch (e) {
      // Otros errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    }
  }
},

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  'REGISTRARSE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                               Navigator.pushNamedAndRemoveUntil(
                                  context, '/login', (route) => false,
                                   );
                              },
                              child: const Text(
                                '¿Ya tienes cuenta? Volver al login',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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