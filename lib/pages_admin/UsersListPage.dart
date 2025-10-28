import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  List<DocumentSnapshot> users = [];
  String _filter = 'todos'; // 'todos', 'activos', 'inactivos'
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('usuarios').get();
    setState(() {
      users = snapshot.docs;
    });
  }

  Future<void> deleteUser(DocumentSnapshot userDoc) async {
    final userId = userDoc.id;

    // Eliminar subcolecciones
    final pedidos = ['pedidos_gorras', 'pedidos_pantalones', 'pedidos_telas'];
    for (final pedido in pedidos) {
      final pedidoSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection(pedido)
          .get();

      for (final doc in pedidoSnapshot.docs) {
        await doc.reference.delete();
      }
    }

    // Eliminar usuario
    await FirebaseFirestore.instance.collection('usuarios').doc(userId).delete();

    setState(() {
      users.removeWhere((u) => u.id == userId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuario eliminado correctamente'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _confirmDeleteUser(DocumentSnapshot user) {
    final data = user.data() as Map<String, dynamic>;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Estás seguro de eliminar al usuario ${data['nombre']} (${data['correo']})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              deleteUser(user);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((user) {
      final data = user.data() as Map<String, dynamic>;
      final email = data['correo']?.toString().toLowerCase() ?? '';
      final nombre = data['nombre']?.toString().toLowerCase() ?? '';
      final activo = data['activo'] ?? true;

      if (_filter == 'activos' && !activo) return false;
      if (_filter == 'inactivos' && activo) return false;

      if (_searchQuery.isEmpty) return true;

      return email.contains(_searchQuery) || nombre.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Registrados'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.blue.shade300],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar usuarios...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFilterButton('todos', 'Todos'),
                          _buildFilterButton('activos', 'Activos'),
                          _buildFilterButton('inactivos', 'Inactivos'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildUsersTable(filteredUsers),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
    final isSelected = _filter == value;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () => setState(() => _filter = value),
          style: ElevatedButton.styleFrom(
            foregroundColor: isSelected ? Colors.white : Colors.blue,
            backgroundColor: isSelected ? Colors.blue : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.blue.shade300),
            ),
            elevation: 0,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildUsersTable(List<DocumentSnapshot> filteredUsers) {
  if (filteredUsers.isEmpty) {
    return const Center(
      child: Text(
        'No hay usuarios para mostrar.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  return ScrollConfiguration(
    behavior: const MaterialScrollBehavior().copyWith(
      dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 900, // Ajusta el ancho según tus columnas
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 20,
            dataRowHeight: 60,
            headingRowHeight: 50,
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            columns: const [
              DataColumn(label: Text('Correo Electrónico')),
              DataColumn(label: Text('Usuario')),
              DataColumn(label: Text('Fecha Registro')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: filteredUsers.map((user) {
              final data = user.data() as Map<String, dynamic>;
              final email = data['correo'] ?? '---';
              final nombre = data['nombre'] ?? '---';
              final fecha = (data['fecha_registro'] as Timestamp?)?.toDate().toString().split(' ')[0] ?? '---';

              return DataRow(
                cells: [
                  DataCell(Text(email)),
                  DataCell(Text(nombre)),
                  DataCell(Text(fecha)),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteUser(user),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    ),
  );
}
}
