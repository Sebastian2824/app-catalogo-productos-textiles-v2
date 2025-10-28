import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'FabricDetailPage.dart';

class FabricsPage extends StatelessWidget {
  const FabricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Telas'),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
  Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
},
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.calculate, color: Colors.white),
            label: const Text('Estimar Costos', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FabricDetailPage(
                    fabricName: 'Seleccione un tipo',
                    imageUrl: '',
                    selectedFabricType: null,
                    isSelectorEnabled: true,
                  ),
                ),
              );
            },
          ),
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  SizedBox(height: 10),
                  FabricCard(
                    imageUrl: 'https://s.alicdn.com/@sc04/kf/H177dcf5d66f84815a99f927ee144bd3an.jpg_300x300.jpg',
                    name: 'Dril',
                  ),
                  SizedBox(height: 20),
                  FabricCard(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGZEgw6lrzNooHY8ETZQXpZVlsPGAZAyX67Q&s',
                    name: 'Taslan gamunizado',
                  ),
                  SizedBox(height: 20),
                  FabricCard(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwYAXlQGFiiSI7KCzAJLUnYOCIErZ10jJa0A&s',
                    name: 'Popelina importada',
                  ),
                  SizedBox(height: 20),
                  FabricCard(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh0thi72IUlzKBMNOnkNszrk-Q5OFwiRlJ-A&s',
                    name: 'Dri fit',
                  ),
                  SizedBox(height: 20),
                  FabricCard(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHGtZGz7EzZg5i-FFaLugkF1HD0Wv_SCOrwQ&s',
                    name: 'Bull denim',
                  ),
                  SizedBox(height: 20),
                  FabricCard(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQx5ctCcuxKPX0skpQ5BTJ3mxf1MdWQ4zLeHA&s',
                    name: 'Casimir',
                  ),
                  SizedBox(height: 20),
                  FabricCard(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjZRKml4EDsfrrZ0v96cOpbMTcTZmpQQtHxA&s',
                    name: 'Gabardina',
                  ),
                  SizedBox(height: 20),
                  FabricCard(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPQ064-LWIHZzmXbf5JlNUT2MpjnVrqqo66g&s',
                    name: 'Poliéster',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Regresar al Inicio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.blue),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  },
                ),
                const Text(
                  'Inicio',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.checkroom_outlined, color: Colors.grey),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, '/listgorras', (route) => false,
                    );
                  },
                ),
                const Text(
                  'Gorras',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.checkroom_outlined, color: Colors.grey),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, '/listpantalon', (route) => false,
                    );
                  },
                ),
                const Text(
                  'Pantalones',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.texture, color: Colors.blue),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, '/listtela', (route) => false,
                    );
                  },
                ),
                const Text(
                  'Telas',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.grey),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, '/order', (route) => false,
                    );
                  },
                ),
                const Text(
                  'Mis Pedidos',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FabricCard extends StatelessWidget {
  final String imageUrl;
  final String name;

  const FabricCard({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FabricDetailPage(
                      fabricName: name,
                      imageUrl: imageUrl,
                      selectedFabricType: name,
                      isSelectorEnabled: false,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Estimar Costo'),
            ),
          ],
        ),
      ),
    );
  }
}