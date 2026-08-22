import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/veiculos_screen.dart';
import 'screens/usuarios_screen.dart';
import 'screens/veiculo_form_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const IntelligenceCarApp());
}

class IntelligenceCarApp extends StatelessWidget {
  const IntelligenceCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF173B67));
    return MaterialApp(
      title: 'IntelligenceCar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF6F7FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        cardTheme: const CardThemeData(color: Colors.white),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final api = ApiService();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(api: api),
      VeiculosScreen(api: api),
      UsuariosScreen(api: api),
    ];

    final titles = ['IntelligenceCar', 'Meus veículos', 'Usuários'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: screens[index],
      floatingActionButton: index == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VeiculoFormScreen(api: api)),
                );
                if (result == true) setState(() {});
              },
              icon: const Icon(Icons.add),
              label: const Text('Veículo'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.directions_car_outlined), selectedIcon: Icon(Icons.directions_car), label: 'Veículos'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Usuários'),
        ],
      ),
    );
  }
}
