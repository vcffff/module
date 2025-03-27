import 'dart:convert';
import 'dart:io';

class CartService {
  List<String> cartItems = [];

  void addToCart(String productName) {
    cartItems.add(productName);
    saveCart();
  }

  void removeFromCart(String productName) {
    cartItems.remove(productName);
    saveCart();
  }

  void clearCart() {
    cartItems.clear();
    saveCart();
  }

  void saveCart() async {
    final file = File('lib/cart.json');
    final data = jsonEncode({"name": cartItems});
    await file.writeAsString(data);
  }
}
