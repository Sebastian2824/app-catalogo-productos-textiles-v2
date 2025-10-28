import 'package:flutter/material.dart';
import 'pages_inicio/LoginScreen.dart';
import 'pages_inicio/RegisterPage.dart';
import 'pages_app/HomePage.dart';
import 'pages_app/OrdersPage.dart';
import 'pages_app/HatsPage.dart';
import 'pages_app/PantsPage.dart';
import 'pages_app/FabricsPage.dart';
import 'pages_admin/HomeAdmin.dart';
import 'pages_admin/UsersListPage.dart';
import 'pages_admin/OrdersRegistryPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo de Productos',
      
      // Tema principal con colores azules
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        
        // Estilo para los inputs
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        
        // Estilo para botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        
        // Estilo para text buttons
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue.shade700,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      
      // Ruta inicial
      home: const LoginScreen(),
      
      // Rutas nombradas (opcional)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterPage(),
        '/inicio': (context) => const HomePage(),
        '/order': (context) => const OrdersPage(),
        '/listgorras': (context) => const HatsPage(),
        '/listpantalon': (context) => const PantsPage(),
        '/listtela': (context) => const FabricsPage(),
        '/inicio_admin':(context) => const AdminDashboard(),
        '/users':(context) => const UsersListPage(),
        '/pedidos':(context) => const OrdersRegistryPage()
      },
    );
  }
}