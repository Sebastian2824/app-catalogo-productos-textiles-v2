// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class OrdersRegistryPage extends StatefulWidget {
  const OrdersRegistryPage({super.key});

  @override
  State<OrdersRegistryPage> createState() => OrdersRegistryPageState();
}

class OrdersRegistryPageState extends State<OrdersRegistryPage> {
  int _currentTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> gorrasOrders = [];
  List<Map<String, dynamic>> pantalonesOrders = [];
  List<Map<String, dynamic>> telasOrders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final firestore = FirebaseFirestore.instance;
    final usersSnapshot = await firestore.collection('usuarios').get();

    List<Map<String, dynamic>> gorras = [];
    List<Map<String, dynamic>> pantalones = [];
    List<Map<String, dynamic>> telas = [];

    for (var userDoc in usersSnapshot.docs) {
      final userName = userDoc.data()['nombre'] ?? 'Sin nombre';
      final userId = userDoc.id;

      // Gorras
      final gorraSnapshot = await firestore
          .collection('usuarios')
          .doc(userId)
          .collection('pedidos_gorras')
          .get();
      for (var doc in gorraSnapshot.docs) {
        gorras.add({
          'id': doc.id,
          'usuario': userName,
          ...doc.data()
        });
      }

      // Pantalones
      final pantalonSnapshot = await firestore
          .collection('usuarios')
          .doc(userId)
          .collection('pedidos_pantalones')
          .get();
      for (var doc in pantalonSnapshot.docs) {
        pantalones.add({
          'id': doc.id,
          'usuario': userName,
          ...doc.data()
        });
      }

      // Telas
      final telaSnapshot = await firestore
          .collection('usuarios')
          .doc(userId)
          .collection('pedidos_telas')
          .get();
      for (var doc in telaSnapshot.docs) {
        telas.add({
          'id': doc.id,
          'usuario': userName,
          ...doc.data()
        });
      }
    }

    setState(() {
      gorrasOrders = gorras;
      pantalonesOrders = pantalones;
      telasOrders = telas;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Pedidos'),
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
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade300,
              Colors.blue.shade600,
            ],
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar pedidos...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTabButton(0, 'Gorras', Icons.casino_outlined),
                          _buildTabButton(1, 'Pantalones', Icons.checkroom_outlined),
                          _buildTabButton(2, 'Telas', Icons.texture),
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
                    child: _buildCurrentTabContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final isSelected = _currentTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentTabIndex = index;
            _searchController.clear();
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.redAccent.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.redAccent : Colors.grey),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.redAccent : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildOrdersTable(gorrasOrders, 'Gorras');
      case 1:
        return _buildOrdersTable(pantalonesOrders, 'Pantalones');
      case 2:
        return _buildOrdersTable(telasOrders, 'Telas');
      default:
        return const Center(child: Text('Seleccione una categoría'));
    }
  }

  Widget _buildOrdersTable(List<Map<String, dynamic>> orders, String productType) {
  final filteredOrders = _searchController.text.isEmpty
      ? orders
      : orders.where((order) {
          final searchTerm = _searchController.text.toLowerCase();
          return order['usuario'].toLowerCase().contains(searchTerm) ||
                 order['producto']?.toLowerCase().contains(searchTerm) == true;
        }).toList();

  if (filteredOrders.isEmpty) {
    return Center(
      child: Text(
        _searchController.text.isEmpty
            ? 'No hay pedidos de $productType registrados'
            : 'No se encontraron resultados',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
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
        width: 900, // Ajusta según tus columnas
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
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Usuario')),
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Fecha')),
            ],
            rows: filteredOrders.map((order) {
              return DataRow(
                cells: [
                  DataCell(Text(order['id'] ?? '')),
                  DataCell(Text(order['usuario'] ?? '')),
                  DataCell(Text(order['producto'] ?? '-')),
                  DataCell(Text(order['unidades']?.toString() ??
                      order['rollos']?.toString() ??
                      order['cantidad']?.toString() ?? '-')),
                  DataCell(Text('S/${order['total']?.toStringAsFixed(2) ?? '-'}')),
                  DataCell(Text(order['fecha']?.toDate().toString().split(' ')[0] ?? '-')),
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
