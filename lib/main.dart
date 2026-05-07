import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Cellar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Book Cellar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Adicionamos o SingleTickerProviderStateMixin para controlar a animação das abas
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Color> cores = [
    Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple,
    Colors.orange, Colors.teal, Colors.pink, Colors.indigo, Colors.brown,
    Colors.cyan, Colors.lime, Colors.amber, Colors.deepOrange, Colors.lightBlue,
    Colors.lightGreen, Colors.deepPurple, Colors.grey, Colors.blueGrey, Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Ouvinte para atualizar a UI quando a aba mudar (necessário para a BottomNavigationBar)
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Função utilitária para mudar de aba e fechar o drawer
  void _navigateTo(int index) {
    _tabController.animateTo(index);
    Navigator.pop(context); // Fecha o drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.info), text: "About Us"),
            Tab(icon: Icon(Icons.book), text: "Shop"),
            Tab(icon: Icon(Icons.contact_mail), text: "Contact"),
          ],
        ),
      ),

      // 1. Drawer atualizado com os 4 elementos
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const Text(
                'FD Shop Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _navigateTo(0),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () => _navigateTo(1),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Shop'),
              onTap: () => _navigateTo(2),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact'),
              onTap: () => _navigateTo(3),
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          HomePageContent(cores: cores),
          GenericPage(title: "About Us", color: Colors.blueGrey, onPressed: () {}),
          GenericPage(title: "Shop", color: Colors.amber, onPressed: () {}),
          GenericPage(title: "Contact", color: Colors.teal, onPressed: () {}),
        ],
      ),

      // 2. TabBar Inferior (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (index) => _tabController.animateTo(index),
        type: BottomNavigationBarType.fixed, // Garante que os 4 itens apareçam bem
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Contact'),
        ],
      ),
    );
  }
}

// --- Widgets de Conteúdo (Mantidos e Atualizados) ---

class HomePageContent extends StatelessWidget {
  final List<Color> cores;
  const HomePageContent({super.key, required this.cores});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 235, 186, 203),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < 20; i++)
                    Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.all(8),
                      color: cores[i % cores.length],
                      child: Center(
                        child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < 20; i++)
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color: cores[i % cores.length], shape: BoxShape.circle),
                      child: Center(
                        child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GenericPage extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback? onPressed;

  const GenericPage({super.key, required this.title, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Book Cellar. Pick your Book Cellar\n$title",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
           
          ],
        ),
      ),
    );
  }
}