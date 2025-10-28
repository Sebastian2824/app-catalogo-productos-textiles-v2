import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_5/pages_inicio/LoginScreen.dart'; 
import 'HatsPage.dart';
import 'PantsPage.dart';
import 'OrdersPage.dart'; 
import 'FabricsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: user.email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _username = snapshot.docs.first.data()['nombre'];
          _email = user.email ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenid@'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          // Botón mis pedidos
          TextButton.icon(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: const Text('Mis Pedidos', style: TextStyle(color: Colors.white)),
            onPressed: () => _navigateToOrders(context),
          ),
          const SizedBox(width: 8),
          // Botón configuración
          IconButton(
            icon: const Icon(Icons.settings, size: 28, color: Colors.white),
            onPressed: () => _showSettingsDialog(context),
          ),
          // Botón perfil
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30, color: Colors.white),
            onPressed: () => _showUserMenu(context),
          ),
        ],
      ),
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCategoryButton(
                context,
                imageUrl: 'https://plazavea.vteximg.com.br/arquivos/ids/22799014-418-418/imageUrl_1.jpg',
                label: 'Gorras',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context, '/listgorras', (route) => false,
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildCategoryButton(
                context,
                imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa7EVRWQiGGGFcGTDZsCVYN9VcQcF3gVcL4g&s',
                label: 'Pantalones',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context, '/listpantalon', (route) => false,
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildCategoryButton(
                context,
                imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQi5WICId5ERniIz3v3JgbqmctQl9TRUlhpXA&s',
                label: 'Telas',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context, '/listtela', (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomButton(
              icon: Icons.checkroom_outlined,
              label: 'Gorras',
              onPressed: () { 
                Navigator.pushNamedAndRemoveUntil(
                  context, '/listgorras', (route) => false,
                );
              },
            ),
            _buildBottomButton(
              icon: Icons.checkroom_outlined,
              label: 'Pantalones',
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context, '/listpantalon', (route) => false,
                );
              },
            ),
            _buildBottomButton(
              icon: Icons.texture,
              label: 'Telas',
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context, '/listtela', (route) => false,
                );
              },
            ),
            _buildBottomButton(
              icon: Icons.shopping_cart,
              label: 'Mis Pedidos',
              onPressed: () => _navigateToOrders(context),
              isSelected: true,
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Diálogo de configuración (cambiar contraseña)
  void _showSettingsDialog(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  // Obtenemos el correo y la contraseña almacenada en Firestore
  final snapshot = await FirebaseFirestore.instance
      .collection('usuarios')
      .where('correo', isEqualTo: user.email)
      .limit(1)
      .get();

  String correo = user.email ?? '';
  String contrasena = snapshot.docs.isNotEmpty
      ? snapshot.docs.first.data()['contrasena'] ?? 'No definida'
      : 'No definida';

  showDialog(
    context: context,
    builder: (context) {
      final TextEditingController _newPasswordController =
          TextEditingController();

      return AlertDialog(
        title: const Text('Configuración de Usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.settings, size: 50),
              ),
              const SizedBox(height: 16),
              const Text("Correo:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(correo),
              const SizedBox(height: 12),
              const Text("Contraseña actual:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(contrasena),
              const SizedBox(height: 20),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nueva contraseña',
                  border: OutlineInputBorder(),
                ),
              ),

              // Botón para mostrar políticas de contraseña
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
                            Text('La nueva contraseña debe cumplir con lo siguiente:'),
                            SizedBox(height: 10),
                            Text('• Longitud mínima: 8 caracteres'),
                            Text('• Incluir al menos una letra mayúscula'),
                            Text('• Incluir al menos una letra minúscula'),
                            Text('• Incluir al menos un número'),
                            Text('• Incluir al menos un carácter especial (!@#\$%^&*)'),
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPassword = _newPasswordController.text.trim();

              // Validación de seguridad para nueva contraseña
              final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
              if (newPassword.isNotEmpty && !regex.hasMatch(newPassword)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('La nueva contraseña no cumple los requisitos de seguridad'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (newPassword.isNotEmpty) {
                try {
                  // Actualizar en FirebaseAuth
                  await user.updatePassword(newPassword);

                  // Actualizar en Firestore
                  if (snapshot.docs.isNotEmpty) {
                    await snapshot.docs.first.reference.update({
                      'contrasena': newPassword,
                    });
                  }

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contraseña actualizada correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}



  // 🔹 Función para navegar a pedidos
  void _navigateToOrders(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context, '/order', (route) => false,
    );
  }

  Widget _buildCategoryButton(
    BuildContext context, {
    required String imageUrl,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.9),
          foregroundColor: Colors.blue.shade700,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: imageUrl.isEmpty
                  ? const Icon(Icons.image, size: 40, color: Colors.grey)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isSelected = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon,
              color: isSelected ? Colors.blue.shade700 : Colors.grey[700]),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.blue.shade700 : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // 🔹 Menú de perfil
  void _showUserMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Perfil de Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              _username.isNotEmpty ? _username : 'Cargando...',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut(); 
                Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
