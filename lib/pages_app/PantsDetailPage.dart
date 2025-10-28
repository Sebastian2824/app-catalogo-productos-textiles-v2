import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PantsDetailPage extends StatefulWidget {
  final String pantsName;
  final String imageUrl;
  final String? selectedPantsType;
  final bool isSelectorEnabled;

  const PantsDetailPage({
    super.key,
    required this.pantsName,
    required this.imageUrl,
    this.selectedPantsType,
    this.isSelectorEnabled = false,
  });

  @override
  State<PantsDetailPage> createState() => _PantsDetailPageState();
}

class _PantsDetailPageState extends State<PantsDetailPage> {
  late String _currentPantsType;
  late String _currentSize;
  int _quantity = 1;
  
  final Map<String, Map<String, double>> _pantsPrices = {
    'Pantalón Clásico': {
      'S': 50.0,
      'M': 55.0,
      'L': 60.0,
      'XL': 65.0,
    },
    'Pantalón Deportivo': {
      'S': 45.0,
      'M': 50.0,
      'L': 55.0,
      'XL': 60.0,
    },
    'Pantalón Elegante': {
      'S': 60.0,
      'M': 65.0,
      'L': 70.0,
      'XL': 75.0,
    },
  };

  final Map<String, String> _pantsImages = {
    'Pantalón Clásico': 'https://www.lanumero1.com.pe/cdn/shop/products/79951908622_1_dfc4689d-1c10-4257-b63d-cf295f97316d_1024x.jpg',
    'Pantalón Deportivo': 'https://www.becoenlinea.com/wp-content/uploads/2024/03/H28898.webp',
    'Pantalón Elegante': 'https://tiendasel.vteximg.com.br/arquivos/ids/18851402-455-455/-new_desc----marca-donatelli----modelo-3pcpd118----genero-hombre----entalle-regular-fit----composicion-85--poliester---15--viscosa----bolsillos-4----h.jpg?v=638283233632070000',
  };

  final List<String> _availableSizes = ['S', 'M', 'L', 'XL'];

  @override
  void initState() {
    super.initState();
    _currentPantsType = widget.selectedPantsType ?? _pantsPrices.keys.first;
    _currentSize = _availableSizes.first;
  }

  @override
  Widget build(BuildContext context) {
    final unitPrice = _pantsPrices[_currentPantsType]?[_currentSize] ?? 0.0;
    final totalPrice = unitPrice * _quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pantsName),
        backgroundColor: Colors.blue.shade700,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: const Text('Mis Pedidos', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context, '/order', (route) => false,
              );
            },
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Selector de tipo de pantalón
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: widget.isSelectorEnabled
                              ? _buildPantsTypeSelector()
                              : _buildLockedPantsTypeDisplay(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Selector de talla
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Talla',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _currentSize,
                                items: _availableSizes.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _currentSize = newValue!;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Precio unitario
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Precio Unitario',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              suffixText: 'S/',
                            ),
                            readOnly: true,
                            controller: TextEditingController(
                              text: unitPrice.toStringAsFixed(2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Cantidad
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Stock (Unidades)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: '1',
                            onChanged: (value) {
                              setState(() {
                                _quantity = int.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Resumen
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'RESUMEN',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              _buildSummaryRow('Producto:', _currentPantsType),
                              _buildSummaryRow('Talla:', _currentSize),
                              _buildSummaryRow(
                                'Precio:',
                                'S/${unitPrice.toStringAsFixed(2)}',
                              ),
                              _buildSummaryRow('Unidades:', _quantity.toString()),
                              _buildSummaryRow(
                                'Total:',
                                'S/${totalPrice.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Botones de acción
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue.shade700,
                                  side: BorderSide(color: Colors.blue.shade700),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('REGRESAR'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                               onPressed: () async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Debes iniciar sesión para registrar un pedido.')),
    );
    return;
  }

  try {
    // Buscar documento del usuario por su correo
    final userQuery = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('correo', isEqualTo: user.email)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no encontrado en la base de datos.')),
      );
      return;
    }

    final userDocId = userQuery.docs.first.id;

    // Calcular el precio unitario y total
    final unitPrice = _pantsPrices[_currentPantsType]![_currentSize]!;
    final totalPrice = unitPrice * _quantity;

    // Registrar pedido de pantalones con talla
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userDocId)
        .collection('pedidos_pantalones')
        .add({
          'producto': _currentPantsType,
          'talla': _currentSize,
          'precio': unitPrice,
          'unidades': _quantity,
          'total': totalPrice,
          'fecha': Timestamp.now(),
        });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido registrado correctamente')),
    );

    Navigator.pushNamedAndRemoveUntil(context, '/order', (route) => false);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al registrar el pedido: $e')),
    );
  }
},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 135, 238, 241),
                                  foregroundColor: const Color.fromARGB(255, 2, 82, 255),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('REGISTRAR PEDIDO'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPantsTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Tipo de Pantalón',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            value: _currentPantsType,
            items: _pantsPrices.keys.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _currentPantsType = newValue!;
                _currentSize = _availableSizes.first;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        _buildPantsImage(),
      ],
    );
  }

  Widget _buildLockedPantsTypeDisplay() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Tipo de Pantalón',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            readOnly: true,
            controller: TextEditingController(
              text: widget.selectedPantsType ?? 'No seleccionado',
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildPantsImage(),
      ],
    );
  }

  Widget _buildPantsImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _pantsImages.containsKey(_currentPantsType)
            ? Image.network(
                _pantsImages[_currentPantsType]!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 40);
                },
              )
            : widget.imageUrl.isNotEmpty
                ? Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image, size: 40);
                    },
                  )
                : const Icon(Icons.image, size: 40),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}