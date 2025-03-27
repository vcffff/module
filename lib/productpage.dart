import 'package:flutter/material.dart';
import 'package:untitled9/GROBAL.dart';
import 'package:untitled9/cartpage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Function to get the cart file
Future<File> getCartFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/cart.json');
}

// Function to save cart data
Future<void> saveCartData(Map<String, dynamic> productData) async {
  try {
    final file = await getCartFile();
    List<dynamic> cartData = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        cartData = jsonDecode(content);
      }
    }

    cartData.add(productData);
    await file.writeAsString(jsonEncode(cartData));

    print("Cart updated: $cartData");
  } catch (e) {
    print("Error writing to cart.json: $e");
  }
}

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> cart;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductPage({
    Key? key,
    required this.product,
    required this.cart,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CartService cartService = CartService();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Test saveCartData with sample data
          final testProductData = {'name': 'Test Product', 'price': 1000};
          await saveCartData(testProductData);

          // Verify the contents of the cart file
          final file = await getCartFile();
          if (await file.exists()) {
            final content = await file.readAsString();
            print("Cart file content: $content");
          } else {
            print("Cart file does not exist.");
          }
        },
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.product['images'].length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      widget.product['images'][index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 40,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.product['images'].length,
              (index) => GestureDetector(
                onTap: () {
                  _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  width: _currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.deepPurple : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("${widget.product['price']} ТГ", style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 20),
                  const Text("Описание:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.product['desc'], style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          cartService.addToCart(ProductItem(item: widget.product));
                        });

                        // Extract name and price
                        final productData = {
                          'name': widget.product['name'],
                          'price': widget.product['price']
                        };

                        // Save cart data using the provided function
                        await saveCartData(productData);

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Добавить в корзину", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

