import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HatDetailPage extends StatefulWidget {
  final String hatName;
  final String imageUrl;
  final String? selectedHatType;
  final bool isSelectorEnabled;

  const HatDetailPage({
    super.key,
    required this.hatName,
    required this.imageUrl,
    this.selectedHatType,
    this.isSelectorEnabled = false,
  });

  @override
  State<HatDetailPage> createState() => _HatDetailPageState();
}

class _HatDetailPageState extends State<HatDetailPage> {
  late String _currentHatType;
  int _quantity = 1;
  final Map<String, double> _hatPrices = {
    'Gorra Vicera': 25.0,
    'Gorra Arabe': 30.0,
    'Gorra Safari': 27.0,
    'Sombrero': 40.0,
    'Gorra Ciclista': 24.0,
    'Gorra Deportiva': 18.0,
    'Gorra Jockey': 32.0,
  };
  final Map<String, String> _hatImages = {
    'Gorra Vicera': 'https://media.istockphoto.com/id/537893112/es/foto/adulto-de-campo-de-la-visera-azul.jpg?s=612x612&w=0&k=20&c=mzRs79ZjnSezbKuWnhhr8uiGOoNl4zwkWcQrRMpd7bo=',
    'Gorra Arabe': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBJ7BGAKF8kDvEGPOFGPn81vTgeqdIgPYsTA&s',
    'Gorra Safari': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRj4bI1Ufl9OxhsOxktNWEn4PWU7F7y1EVGCA&s',
    'Sombrero': 'https://i5.walmartimages.com/asr/129de6e6-95cd-4df5-8f26-b5aa131463f4.cb044492464e07deb2f885dc7955ef35.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF',
    'Gorra Ciclista': 'https://rockbros.com.pe/wp-content/uploads/2023/01/Gorro-de-ciclismo-unisex-Rockbros-M005BK_Mesa-de-trabajo-1.jpg',
    'Gorra Deportiva': 'https://assets.adidas.com/images/w_600,f_auto,q_auto/31c3f3bc810142a0b0dcd01cdac923a1_9366/Gorra_Beisbol_3_Tiras_New_Logo_Negro_JG1072_01_00_standard.jpg',
    'Gorra Jockey': 'https://www.blockstore.cl/cdn/shop/files/p-BNSHOT17WBPLN-1.jpg?v=1701175247',
  };

  @override
  void initState() {
    super.initState();
    _currentHatType = widget.selectedHatType ?? _hatPrices.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _hatPrices[_currentHatType]! * _quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hatName),
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
                    // Selector o visualización bloqueada
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: widget.isSelectorEnabled
                            ? _buildHatTypeSelector()
                            : _buildLockedHatTypeDisplay(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo de cantidad
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
                            _buildSummaryRow('Producto:', _currentHatType),
                            _buildSummaryRow(
                              'Precio:',
                              'S/${_hatPrices[_currentHatType]!.toStringAsFixed(2)}',
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
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Usuario no autenticado
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

    // Registrar pedido dentro del documento del usuario
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userDocId)
        .collection('pedidos_gorras')
        .add({
          'producto': _currentHatType,
          'precio': _hatPrices[_currentHatType],
          'unidades': _quantity,
          'total': _hatPrices[_currentHatType]! * _quantity,
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

  Widget _buildHatTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Tipo de Gorra',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            value: _currentHatType,
            items: _hatPrices.keys.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _currentHatType = newValue!;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        _buildHatImage(),
      ],
    );
  }

  Widget _buildLockedHatTypeDisplay() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Tipo de Gorra',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            readOnly: true,
            controller: TextEditingController(
              text: widget.selectedHatType ?? 'No seleccionado',
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildHatImage(),
      ],
    );
  }

  Widget _buildHatImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _hatImages.containsKey(_currentHatType)
            ? Image.network(
                _hatImages[_currentHatType]!,
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