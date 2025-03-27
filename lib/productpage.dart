import 'package:flutter/material.dart';
import 'package:untitled9/GROBAL.dart';
import 'package:untitled9/cartpage.dart';

// In-memory cart data
List<Map<String, dynamic>> cartData = [];

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
        onPressed: () {
          // Test adding a sample product to the cart
          final testProductData = {'name': 'Test Product', 'price': 1000};
          cartData.add(testProductData);
          print("Cart updated: $cartData");
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(cartItems: cartData), // Pass cartData as cartItems
                      ),
                    );
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
                      onPressed: () {
                        // Check if the product is already in the cart
                        final isInCart = cartData.any((item) => item['name'] == widget.product['name']);

                        if (!isInCart) {
                          setState(() {
                            cartService.addToCart(ProductItem(item: widget.product));
                          });

                          // Add product to in-memory cart
                          final productData = {
                            'name': widget.product['name'],
                            'price': widget.product['price']
                          };
                          cartData.add(productData);

                          Navigator.pop(context);
                          print(cartService.cartItems);
                          Navigator.push(context,MaterialPageRoute(builder: (context) => CartPage(cartItems: cartData)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cartData.any((item) => item['name'] == widget.product['name'])
                            ? Colors.grey
                            : Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        cartData.any((item) => item['name'] == widget.product['name'])
                            ? "В корзине"
                            : "Добавить в корзину",
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
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

