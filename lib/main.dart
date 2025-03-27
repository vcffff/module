import 'package:flutter/material.dart';
import 'package:untitled9/cartpage.dart'; 
import 'profile.dart';
import 'catalogue.dart';
import 'login.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}


class IndexedScreen extends StatefulWidget {
  @override
  _IndexedState createState() => _IndexedState();
}

class _IndexedState extends State<IndexedScreen> {
  int selected = 0;
  final List<Map<String, dynamic>> cart = []; 

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      CataloguePage(cart: cart),
      CartPage(cartItems: cart), 
      Profile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selected,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Каталог",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Корзина",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Профиль",
          ),
        ],
      ),
    );
  }
}







