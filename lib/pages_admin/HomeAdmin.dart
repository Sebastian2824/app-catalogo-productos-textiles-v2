import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_5/pages_inicio/LoginScreen.dart';
import 'UsersListPage.dart';
import 'OrdersRegistryPage.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administrador'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 28, color: Colors.white),
            onPressed: () => _showSettingsDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30, color: Colors.white),
            onPressed: () => _showAdminMenu(context),
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
              _buildAdminOption(
                context,
                icon: Icons.people_alt,
                label: 'Usuarios Registrados',
                description: 'Gestiona todos los usuarios del sistema',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UsersListPage()),
                  );
                },
              ),
              const SizedBox(height: 30),
              _buildAdminOption(
                context,
                icon: Icons.assignment,
                label: 'Registro de Pedidos',
                description: 'Visualiza el historial completo de pedidos',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrdersRegistryPage()),
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
              icon: Icons.people_alt,
              label: 'Usuarios',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersListPage()),
                );
              },
            ),
            _buildBottomButton(
              icon: Icons.assignment,
              label: 'Pedidos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersRegistryPage()),
                );
              },
            ),
            _buildBottomButton(
              icon: Icons.logout,
              label: 'Salir',
              onPressed: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 280,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.9),
          foregroundColor: Colors.redAccent,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.redAccent),
            const SizedBox(height: 15),
            Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
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
              color: isSelected ? Colors.redAccent : Colors.grey[700]),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.redAccent : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  void _showAdminMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Panel de Administrador'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.admin_panel_settings, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Administrador',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
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

 void _showSettingsDialog(BuildContext context) async {
  final docSnapshot = await FirebaseFirestore.instance
      .collection('admin')
      .doc('wcp0zhOnbsuftEOEzGWX')
      .get();

  final data = docSnapshot.data();

  if (data == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se encontraron los datos del administrador'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  String correoActual = data['correo'] ?? 'No definido';
  String contrasenaActual = data['contrasena'] ?? 'No definida';

  final newEmailController = TextEditingController(text: correoActual);
  final newPasswordController = TextEditingController();
  final currentPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Configuración de Administrador'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.admin_panel_settings, size: 50),
            ),
            const SizedBox(height: 16),

            const Text("Correo actual:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(correoActual),
            const SizedBox(height: 12),

            const Text("Contraseña actual (registrada):",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(contrasenaActual),
            const SizedBox(height: 16),

            // Contraseña actual para reautenticación
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Ingrese su contraseña actual',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Nuevo correo
            TextField(
              controller: newEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Nuevo correo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Nueva contraseña (opcional)
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña (dejar vacío si no cambia)',
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;

            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No hay usuario autenticado'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final currentPassword = currentPasswordController.text.trim();
            final newEmail = newEmailController.text.trim();
            final newPassword = newPasswordController.text.trim();

            if (currentPassword.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Debe ingresar su contraseña actual'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            if (newEmail.isEmpty || !newEmail.contains('@')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ingrese un correo válido'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

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

            try {
              final cred = EmailAuthProvider.credential(
                email: user.email!,
                password: currentPassword,
              );
              await user.reauthenticateWithCredential(cred);

              if (newEmail != user.email) await user.updateEmail(newEmail);

              String contrasenaParaGuardar = contrasenaActual;
              if (newPassword.isNotEmpty) {
                await user.updatePassword(newPassword);
                contrasenaParaGuardar = newPassword;
              }

              await FirebaseFirestore.instance
                  .collection('admin')
                  .doc('wcp0zhOnbsuftEOEzGWX')
                  .update({
                'correo': newEmail,
                'contrasena': contrasenaParaGuardar,
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Datos del administrador actualizados correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            } on FirebaseAuthException catch (e) {
              String mensaje = e.message ?? 'Error en FirebaseAuth';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $mensaje'), backgroundColor: Colors.red),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error inesperado: $e'), backgroundColor: Colors.red),
              );
            }
          },
          child: const Text('Guardar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}
