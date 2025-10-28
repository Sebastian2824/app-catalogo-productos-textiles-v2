import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_5/mail.dart';
import 'package:intl/intl.dart';
import 'dart:ui';



class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> allOrders = [];
  double totalAmount = 0.0;
  String? selectedTipoFiltro;
  String? selectedProductoFiltro;
  List<String> productosUnicos = [];

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userSnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('correo', isEqualTo: user.email)
        .limit(1)
        .get();

    if (userSnapshot.docs.isEmpty) return;
    final userDocId = userSnapshot.docs.first.id;

    final tiposPedidos = ['pedidos_gorras', 'pedidos_pantalones', 'pedidos_telas'];
    List<Map<String, dynamic>> pedidosTemp = [];
    double total = 0.0;

    for (String tipo in tiposPedidos) {
      final snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userDocId)
          .collection(tipo)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        data['tipo'] = tipo;
        pedidosTemp.add(data);
        total += (data['total'] as num).toDouble();
      }
    }

    setState(() {
      allOrders = pedidosTemp;
      totalAmount = total;
      productosUnicos = allOrders.map((e) => e['producto'] as String).toSet().toList()..sort();
    });
  }

  Future<void> _eliminarPedido(String tipo, String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userSnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('correo', isEqualTo: user.email)
        .limit(1)
        .get();

    if (userSnapshot.docs.isEmpty) return;
    final userDocId = userSnapshot.docs.first.id;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userDocId)
        .collection(tipo)
        .doc(id)
        .delete();

    _cargarPedidos();
  }

  @override
  Widget build(BuildContext context) {
    final pedidosFiltrados = allOrders.where((pedido) {
      final tipoCoincide = selectedTipoFiltro == null || pedido['tipo'] == selectedTipoFiltro;
      final productoCoincide = selectedProductoFiltro == null || pedido['producto'] == selectedProductoFiltro;
      return tipoCoincide && productoCoincide;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
  Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
},
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (allOrders.isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Filtrar por tipo',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: selectedTipoFiltro,
                      items: ['pedidos_gorras', 'pedidos_pantalones', 'pedidos_telas']
                          .map((tipo) => DropdownMenuItem(
                                value: tipo,
                                child: Text(tipo.replaceAll('pedidos_', '').toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedTipoFiltro = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Filtrar por producto',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: selectedProductoFiltro,
                      items: productosUnicos
                          .map((producto) => DropdownMenuItem(
                                value: producto,
                                child: Text(producto),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedProductoFiltro = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
  child: Card(
    color: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1200, // ajusta según tus columnas
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20,
                dataRowHeight: 50,
                headingRowHeight: 40,
                columns: const [
                  DataColumn(label: Text('Producto')),
                  DataColumn(label: Text('Precio')),
                  DataColumn(label: Text('Unidades')),
                  DataColumn(label: Text('Talla')),
                  DataColumn(label: Text('Rollos')),
                  DataColumn(label: Text('Calidad')),
                  DataColumn(label: Text('Dimensión')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Tipo')),
                  DataColumn(label: Text('Acción')),
                ],
                rows: pedidosFiltrados.map((pedido) {
                  return DataRow(cells: [
                    DataCell(Text(pedido['producto']?.toString() ?? '-')),
                    DataCell(Text(
                      pedido['precio'] != null
                          ? 'S/${(pedido['precio'] as num).toStringAsFixed(2)}'
                          : '-',
                    )),
                    DataCell(Text(pedido['unidades']?.toString() ?? '-')),
                    DataCell(Text(pedido['talla']?.toString() ?? '-')),
                    DataCell(Text(pedido['rollos']?.toString() ?? '-')),
                    DataCell(Text(pedido['calidad']?.toString() ?? '-')),
                    DataCell(Text(pedido['dimension']?.toString() ?? '-')),
                    DataCell(Text(
                      pedido['total'] != null
                          ? 'S/${(pedido['total'] as num).toStringAsFixed(2)}'
                          : '-',
                    )),
                    DataCell(Text(
                      pedido['tipo']?.toString().replaceAll('pedidos_', '') ?? '-',
                    )),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarPedido(pedido['tipo'], pedido['id']),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    ),
  ),
),
              const SizedBox(height: 16),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.blue.shade800,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Total del Pedido',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'S/${totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.home, color: Colors.white),
                      label: const Text('Regresar al Inicio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context, '/inicio', (route) => false,
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.email, color: Colors.white),
                      label: const Text('Enviar Pedido'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                     onPressed: () async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario no autenticado')),
    );
    return;
  }

  final userEmail = user.email ?? '';
  final firestore = FirebaseFirestore.instance;

  // Buscar el documento del usuario por correo (ya que el UID no coincide)
  final querySnapshot = await firestore
      .collection('usuarios')
      .where('correo', isEqualTo: userEmail)
      .limit(1)
      .get();

  if (querySnapshot.docs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario no registrado en la base de datos')),
    );
    return;
  }

  final userDoc = querySnapshot.docs.first;
  final userId = userDoc.id; 
  final userName = userDoc.data()['nombre'] ?? 'Usuario';

  print('🔍 Documento correcto encontrado: UID = $userId');
Future<String> getPedidosHtml(String tipo) async {
  final pedidosSnapshot = await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(userId)
      .collection(tipo)
      .get();

  if (pedidosSnapshot.docs.isEmpty) {
    return '<p>No hay pedidos de ${tipo.replaceAll('pedidos_', '').toUpperCase()}</p>';
  }

  // Definir columnas específicas por tipo
  List<String> columnas;
  if (tipo == 'pedidos_gorras') {
    columnas = ['producto', 'unidades', 'precio', 'total', 'fecha'];
  } else if (tipo == 'pedidos_pantalones') {
    columnas = ['producto', 'talla', 'unidades', 'precio', 'total', 'fecha'];
  } else if (tipo == 'pedidos_telas') {
    columnas = ['producto', 'calidad', 'dimension', 'precio', 'rollos','total', 'fecha'];
  } else {
    columnas = ['producto', 'cantidad', 'precio', 'total', 'fecha'];
  }

  final headers = columnas.map((col) => '<th>$col</th>').join();

  final rows = pedidosSnapshot.docs.map((doc) {
    final data = doc.data();

    final fecha = data['fecha'] is Timestamp
        ? (data['fecha'] as Timestamp).toDate().toString().split(' ')[0]
        : data['fecha']?.toString() ?? '-';

    final celdas = columnas.map((col) {
      return col == 'fecha'
          ? '<td>$fecha</td>'
          : '<td>${data[col]?.toString() ?? '-'}</td>';
    }).join();

    return '<tr>$celdas</tr>';
  }).join();

  return '''
    <h3>${tipo.replaceAll('pedidos_', '').toUpperCase()}</h3>
    <table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse; width: 100%;">
      <thead><tr>$headers</tr></thead>
      <tbody>$rows</tbody>
    </table>
    <br>
  ''';
}


  // Cargar los pedidos
  final pedidosGorras = await getPedidosHtml('pedidos_gorras');
  final pedidosPantalones = await getPedidosHtml('pedidos_pantalones');
  final pedidosTelas = await getPedidosHtml('pedidos_telas');

  // Enviar email
  try {
    await enviarPedidoPorEmail(
      userName: userName,
      userEmail: userEmail,
      pedidosGorras: pedidosGorras,
      pedidosPantalones: pedidosPantalones,
      pedidosTelas: pedidosTelas,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Pedido enviado correctamente al administrador'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    print('❌ Error al enviar: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❌ Error al enviar el pedido'),
        backgroundColor: Colors.red,
      ),
    );
  }
},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}