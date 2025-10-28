import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'PantsDetailPage.dart';

class PantsPage extends StatelessWidget {
  const PantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Pantalones'),
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
                  builder: (context) => PantsDetailPage(
                    pantsName: 'Seleccione un tipo',
                    imageUrl: '',
                    selectedPantsType: null,
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
                  PantsCard(
                    imageUrl: 'https://www.lanumero1.com.pe/cdn/shop/products/79951908622_1_dfc4689d-1c10-4257-b63d-cf295f97316d_1024x.jpg',
                    name: 'Pantalón Clásico',
                  ),
                  SizedBox(height: 20),
                  PantsCard(
                    imageUrl: 'https://www.becoenlinea.com/wp-content/uploads/2024/03/H28898.webp',
                    name: 'Pantalón Deportivo',
                  ),
                  SizedBox(height: 20),
                  PantsCard(
                    imageUrl: 'https://tiendasel.vteximg.com.br/arquivos/ids/18851402-455-455/-new_desc----marca-donatelli----modelo-3pcpd118----genero-hombre----entalle-regular-fit----composicion-85--poliester---15--viscosa----bolsillos-4----h.jpg?v=638283233632070000',
                    name: 'Pantalón Elegante',
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
                  icon: const Icon(Icons.checkroom_outlined, color: Colors.blue),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                                  context, '/listpantalon', (route) => false,
                                   );
                  },
                ),
                const Text(
                  'Pantalones',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.texture, color: Colors.grey),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, '/listtela', (route) => false,
                    );
                  },
                ),
                const Text(
                  'Telas',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
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

class PantsCard extends StatelessWidget {
  final String imageUrl;
  final String name;

  const PantsCard({
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
                    builder: (context) => PantsDetailPage(
                      pantsName: name,
                      imageUrl: imageUrl,
                      selectedPantsType: name,
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