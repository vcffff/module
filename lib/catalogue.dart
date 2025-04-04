import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'productpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CataloguePage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  const CataloguePage({Key? key, required this.cart}) : super(key: key);

  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  List items = [];
  List filtered = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    loadCart();
  }

  Future<void> loadData() async {
    String data = await rootBundle.loadString('assets/store.json');
    List decoded = jsonDecode(data);
    setState(() {
      items = decoded;
      filtered = items;
    });
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      setState(() {
        widget.cart.clear();
        widget.cart.addAll(List<Map<String, dynamic>>.from(jsonDecode(cartData)));
      });
    }
  }

  Future<void> saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode(widget.cart));
  }

  void filter(String query) {
    setState(() {
      query = query.toLowerCase();
      filtered = query.isEmpty
          ? List.from(items)
          : items
              .where((item) => item['name'].toLowerCase().contains(query))
              .toList();
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                            saveCart(); // Save the cart after adding an item
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PageView.builder(
                          itemCount: filtered[index]['images'].length,
                          onPageChanged: (pageIndex) {
                            setState(() {
                              filtered[index]['currentPage'] = pageIndex;
                            });
                          },
                          itemBuilder: (context, imageIndex) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                filtered[index]['images'][imageIndex],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          filtered[index]['images'].length,
                          (dotIndex) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: filtered[index]['currentPage'] == dotIndex
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(filtered[index]['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(filtered[index]['desc'],
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
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
