import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FabricDetailPage extends StatefulWidget {
  final String fabricName;
  final String imageUrl;
  final String? selectedFabricType;
  final bool isSelectorEnabled;

  const FabricDetailPage({
    super.key,
    required this.fabricName,
    required this.imageUrl,
    this.selectedFabricType,
    this.isSelectorEnabled = false,
  });

  @override
  State<FabricDetailPage> createState() => _FabricDetailPageState();
}

class _FabricDetailPageState extends State<FabricDetailPage> {
  late String _currentFabricType;
  late String _currentQuality;
  late String _currentDimension;
  int _quantity = 1;
  
  final Map<String, Map<String, Map<String, double>>> _fabricPrices = {
  'Dril': {
    'Estándar': {
      '1 metro': 20.0,
      '2 metros': 38.0,
      '3 metros': 54.0,
      '4 metros': 68.0,
      '5 metros': 80.0,
    },
    'Premium': {
      '1 metro': 30.0,
      '2 metros': 57.0,
      '3 metros': 81.0,
      '4 metros': 102.0,
      '5 metros': 120.0,
    },
  },
  'Taslan gamunizado': {
    'Estándar': {
      '1 metro': 40.0,
      '2 metros': 76.0,
      '3 metros': 108.0,
      '4 metros': 136.0,
      '5 metros': 160.0,
    },
    'Premium': {
      '1 metro': 60.0,
      '2 metros': 114.0,
      '3 metros': 162.0,
      '4 metros': 204.0,
      '5 metros': 240.0,
    },
  },
  'Popelina importada': {
    'Estándar': {
      '1 metro': 35.0,
      '2 metros': 66.5,
      '3 metros': 94.5,
      '4 metros': 119.0,
      '5 metros': 140.0,
    },
    'Premium': {
      '1 metro': 50.0,
      '2 metros': 95.0,
      '3 metros': 135.0,
      '4 metros': 170.0,
      '5 metros': 200.0,
    },
  },
  'Dri fit': {
    'Estándar': {
      '1 metro': 25.0,
      '2 metros': 48.0,
      '3 metros': 69.0,
      '4 metros': 88.0,
      '5 metros': 105.0,
    },
    'Premium': {
      '1 metro': 35.0,
      '2 metros': 67.0,
      '3 metros': 96.0,
      '4 metros': 123.0,
      '5 metros': 150.0,
    },
  },
  'Bull denim': {
    'Estándar': {
      '1 metro': 45.0,
      '2 metros': 86.0,
      '3 metros': 123.0,
      '4 metros': 156.0,
      '5 metros': 185.0,
    },
    'Premium': {
      '1 metro': 65.0,
      '2 metros': 124.0,
      '3 metros': 180.0,
      '4 metros': 232.0,
      '5 metros': 280.0,
    },
  },
  'Casimir': {
    'Estándar': {
      '1 metro': 30.0,
      '2 metros': 57.0,
      '3 metros': 81.0,
      '4 metros': 102.0,
      '5 metros': 120.0,
    },
    'Premium': {
      '1 metro': 45.0,
      '2 metros': 86.0,
      '3 metros': 123.0,
      '4 metros': 156.0,
      '5 metros': 185.0,
    },
  },
  'Gabardina': {
    'Estándar': {
      '1 metro': 38.0,
      '2 metros': 72.0,
      '3 metros': 103.0,
      '4 metros': 130.0,
      '5 metros': 155.0,
    },
    'Premium': {
      '1 metro': 55.0,
      '2 metros': 105.0,
      '3 metros': 150.0,
      '4 metros': 190.0,
      '5 metros': 225.0,
    },
  },
  'Poliéster': {
    'Estándar': {
      '1 metro': 18.0,
      '2 metros': 34.0,
      '3 metros': 48.0,
      '4 metros': 60.0,
      '5 metros': 70.0,
    },
    'Premium': {
      '1 metro': 28.0,
      '2 metros': 53.0,
      '3 metros': 75.0,
      '4 metros': 94.0,
      '5 metros': 110.0,
    },
  },
};

  final Map<String, String> _fabricImages = {
  'Dril': 'https://s.alicdn.com/@sc04/kf/H177dcf5d66f84815a99f927ee144bd3an.jpg_300x300.jpg',
  'Taslan gamunizado': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGZEgw6lrzNooHY8ETZQXpZVlsPGAZAyX67Q&s',
  'Popelina importada': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwYAXlQGFiiSI7KCzAJLUnYOCIErZ10jJa0A&s',
  'Dri fit': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh0thi72IUlzKBMNOnkNszrk-Q5OFwiRlJ-A&s',
  'Bull denim': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHGtZGz7EzZg5i-FFaLugkF1HD0Wv_SCOrwQ&s',
  'Casimir': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQx5ctCcuxKPX0skpQ5BTJ3mxf1MdWQ4zLeHA&s',
  'Gabardina': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjZRKml4EDsfrrZ0v96cOpbMTcTZmpQQtHxA&s',
  'Poliéster': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPQ064-LWIHZzmXbf5JlNUT2MpjnVrqqo66g&s',
};


  final List<String> _availableQualities = ['Estándar', 'Premium'];
  final List<String> _availableDimensions = ['1 metro', '2 metros', '3 metros', '4 metros', '5 metros'];

  @override
  void initState() {
    super.initState();
    _currentFabricType = widget.selectedFabricType ?? _fabricPrices.keys.first;
    _currentQuality = _availableQualities.first;
    _currentDimension = _availableDimensions.first;
  }

  @override
  Widget build(BuildContext context) {
    final unitPrice = _fabricPrices[_currentFabricType]?[_currentQuality]?[_currentDimension] ?? 0.0;
    final totalPrice = unitPrice * _quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fabricName),
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
                      // Selector de tipo de tela
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: widget.isSelectorEnabled
                              ? _buildFabricTypeSelector()
                              : _buildLockedFabricTypeDisplay(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Selector de calidad
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
                                'Calidad',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _currentQuality,
                                items: _availableQualities.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _currentQuality = newValue!;
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
                      // Selector de dimensión
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
                                'Dimensión',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _currentDimension,
                                items: _availableDimensions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _currentDimension = newValue!;
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
                              labelText: 'Cantidad de Rollos',
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
                              _buildSummaryRow('Producto:', _currentFabricType),
                              _buildSummaryRow('Calidad:', _currentQuality),
                              _buildSummaryRow('Dimensión:', _currentDimension),
                              _buildSummaryRow(
                                'Precio:',
                                'S/${unitPrice.toStringAsFixed(2)}',
                              ),
                              _buildSummaryRow('Rollos:', _quantity.toString()),
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
    // Buscar el documento del usuario autenticado por su correo
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

    // Guardar el pedido en la subcolección pedidos_telas
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userDocId)
        .collection('pedidos_telas')
        .add({
          'producto': _currentFabricType,
          'calidad': _currentQuality,
          'dimension': _currentDimension,
          'precio': unitPrice,
          'rollos': _quantity,
          'total': totalPrice,
          'fecha': Timestamp.now(),
        });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido de tela registrado correctamente')),
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

  Widget _buildFabricTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Tipo de Tela',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            value: _currentFabricType,
            items: _fabricPrices.keys.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _currentFabricType = newValue!;
                _currentQuality = _availableQualities.first;
                _currentDimension = _availableDimensions.first;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        _buildFabricImage(),
      ],
    );
  }

  Widget _buildLockedFabricTypeDisplay() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Tipo de Tela',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            readOnly: true,
            controller: TextEditingController(
              text: widget.selectedFabricType ?? 'No seleccionado',
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFabricImage(),
      ],
    );
  }

  Widget _buildFabricImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _fabricImages.containsKey(_currentFabricType)
            ? Image.network(
                _fabricImages[_currentFabricType]!,
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