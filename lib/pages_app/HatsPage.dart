import 'package:flutter/material.dart';
import 'HomePage.dart'; 
import 'HatDetailPage.dart';

class HatsPage extends StatelessWidget {
  const HatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Gorras'),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
         onPressed: () {
  Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
},
        ),
        actions: [
// Botón para estimar costos (selector desbloqueado)
    TextButton.icon(
      icon: const Icon(Icons.calculate, color: Colors.white),
      label: const Text('Estimar Costos', style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HatDetailPage(
              hatName: 'Seleccione un tipo', // Texto por defecto
              imageUrl: '', // URL vacía inicial
              selectedHatType: null, // Ninguna selección inicial
              isSelectorEnabled: true, // Selector desbloqueado
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
                  HatCard(
                    imageUrl: 'https://media.istockphoto.com/id/537893112/es/foto/adulto-de-campo-de-la-visera-azul.jpg?s=612x612&w=0&k=20&c=mzRs79ZjnSezbKuWnhhr8uiGOoNl4zwkWcQrRMpd7bo=',
                    name: 'Gorra Vicera',
                  ),
                  SizedBox(height: 20),
                  HatCard(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBJ7BGAKF8kDvEGPOFGPn81vTgeqdIgPYsTA&s',
                    name: 'Gorra Arabe',
                  ),
                  SizedBox(height: 20),
                  HatCard(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRj4bI1Ufl9OxhsOxktNWEn4PWU7F7y1EVGCA&s',
                    name: 'Gorra Safari',
                  ),
                  SizedBox(height: 20),
                  HatCard(
                    imageUrl: 'https://i5.walmartimages.com/asr/129de6e6-95cd-4df5-8f26-b5aa131463f4.cb044492464e07deb2f885dc7955ef35.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF',
                    name: 'Sombrero',
                  ),
                  SizedBox(height: 20),
                  HatCard(
                    imageUrl: 'https://rockbros.com.pe/wp-content/uploads/2023/01/Gorro-de-ciclismo-unisex-Rockbros-M005BK_Mesa-de-trabajo-1.jpg',
                    name: 'Gorra Ciclista',
                  ),
                  SizedBox(height: 20),
                  HatCard(
                    imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/31c3f3bc810142a0b0dcd01cdac923a1_9366/Gorra_Beisbol_3_Tiras_New_Logo_Negro_JG1072_01_00_standard.jpg',
                    name: 'Gorra Deportiva',
                  ),
                  SizedBox(height: 20),
                  HatCard(
                    imageUrl: 'https://www.blockstore.cl/cdn/shop/files/p-BNSHOT17WBPLN-1.jpg?v=1701175247',
                    name: 'Gorra Jockey',
                  ),
                ],
              ),
            ),
            // Botón para regresar al inicio
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
                  icon: const Icon(Icons.checkroom_outlined, color: Colors.blue),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                                  context, '/listgorras', (route) => false,
                                   );
                  },
                ),
                const Text(
                  'Gorras',
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

class HatCard extends StatelessWidget {
  final String imageUrl;
  final String name;

  const HatCard({
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
        builder: (context) => HatDetailPage(
          hatName: name,
          imageUrl: imageUrl,
          selectedHatType: name, // Selección bloqueada
          isSelectorEnabled: false, // Selector bloqueado
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