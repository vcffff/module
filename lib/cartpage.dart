import 'package:flutter/material.dart';
import 'GROBAL.dart';

final CartService cartService = CartService();
final List<Map<String, dynamic>> cartData = [];

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems; // Explicitly require cartItems

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }

  void clearCart() {
    setState(() {
      widget.cartItems.clear();
    });
  }

  void updateQuantity(int index, int delta) {
    setState(() {
      final currentQuantity = widget.cartItems[index]['quantity'] ?? 1;
      final newQuantity = currentQuantity + delta;
      if (newQuantity > 0) {
        widget.cartItems[index]['quantity'] = newQuantity;
      } else {
        removeItem(index);
      }
    });
  }

  double calculateTotalPrice() {
    return widget.cartItems.fold(0, (total, item) {
      final price = item['price'] ?? 0;
      final quantity = item['quantity'] ?? 1;
      return total + (price * quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Корзина (${widget.cartItems.length})"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: clearCart,
          ),
        ],
      ),
      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text(
                "В вашей корзине пока пусто",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final productItem = widget.cartItems[index];
                      final quantity = productItem['quantity'] ?? 1;

                      return ListTile(
                        leading: productItem['images'] != null && productItem['images'].isNotEmpty
    ? Image.asset(
    productItem[index]['images'][0], // Путь к изображению
  width: 50,
  height: 50,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.broken_image, size: 50);
  },
)
    :
                
                 const Icon(Icons.image_not_supported, size: 50),
                        title: Text(productItem["name"]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${productItem["price"]} ТГ"),
                            Text("Количество: $quantity"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => updateQuantity(index, -1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => updateQuantity(index, 1),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Итого: ${calculateTotalPrice().toStringAsFixed(2)} ТГ",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Handle checkout logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Оформление заказа...")),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Оформить заказ",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
