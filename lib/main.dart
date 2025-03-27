import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled9/cartpage.dart';
import 'productpage.dart';
import 'package:path_provider/path_provider.dart';
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

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController control1 = TextEditingController();
  final TextEditingController control2 = TextEditingController();
  String errormes = '';
  bool obscure = true;

  void checking() {
    String email = control1.text;
    String password = control2.text;

    if (email.isEmpty &&  password.isEmpty) {
      setState(() {
        errormes = 'Заполните все поля';
      });
    } else if (!email.contains('@') && !email.contains('.')) {
    setState(() {
    errormes = 'Введите корректную почту';
    });
    } else {
    setState(() {
    errormes = '';
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => IndexedScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Авторизация"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                TextField(
                  controller: control1,
                  decoration: const InputDecoration(hintText: 'Почта', border: InputBorder.none),
                ),
                const Divider(color: Colors.black),
                TextField(
                  obscureText: obscure,
                  controller: control2,
                  decoration: const InputDecoration(hintText: 'Пароль', border: InputBorder.none),
                ),
                const SizedBox(height: 20),
                
                Container(width: double.infinity,
                height: 60,
                  child: ElevatedButton(
                    onPressed: checking,
                    child: const Text('Войти'),
                    style: ElevatedButton.styleFrom(
                      
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                 Container(width: double.infinity,
                height: 60,
                  child: ElevatedButton(
                    onPressed: checking,
                    child: const Text('Зарегистрироваться'),
                    style: ElevatedButton.styleFrom(
                      
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            errormes,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
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

class CataloguePage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  const CataloguePage({Key? key, required this.cart}) : super(key: key);

  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  List items = [];
  List filtered = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String data = await rootBundle.loadString('assets/store.json');
    List decoded = jsonDecode(data);
    setState(() {
      items = decoded;
      filtered = List.from(items);
    });
  }

  void filter(String query) {
    query = query.toLowerCase();
    setState(() {
      filtered = query.isEmpty
          ? List.from(items)
          : items.where((item) => item['name'].toString().toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [
            const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: searchController,
            onChanged: filter,
            decoration: InputDecoration(
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  filter('');
                },
              )
                  : const Icon(Icons.search),
              hintText: 'Поиск',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Expanded(
        child: GridView.builder(
        padding: const EdgeInsets.all(10),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 0.75,
    ),
    itemCount: filtered.length,
    itemBuilder: (context, index) => GestureDetector(
    onTap: () {
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductPage(
      
      product: filtered[index],
      cart: widget.cart,
      onAddToCart: (product) { 
        setState(() {
          widget.cart.add(product);
        });
      },
    ),
  ),
);

    }, // <-- Missing closing brace added here
    child: Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 4,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    child: ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
    // child: Image.asset(
    // filtered[index]['images'][0],
    // fit: BoxFit.cover,
    // width: double.infinity,
    // ),
    child: Image.network(
    filtered[index]['images'][0],),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(filtered[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    const SizedBox(height: 4),
    Text(filtered[index]['desc'], style: const TextStyle(color: Colors.grey)),
    ],
    ),
    ),],
    ),
    ),
    ),
        ),
        ),
            ],
        ),
    );
  }
}






class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List login = [];

  Future<void> loadProfileData() async {
    String data = await rootBundle.loadString('assets/login.json');
    setState(() {
      login = jsonDecode(data);
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
      ),
      body: login.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/avatar_placeholder_icon.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  login[0]['name'],
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  login[0]['mail'],
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(left: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Выйти',
              style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}