import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

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