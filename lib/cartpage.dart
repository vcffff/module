import 'package:flutter/material.dart';
import 'GROBAL.dart';

final CartService cartService = CartService();

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeItem(int index) {
    setState(() {
      cartService.cartItems.removeAt(index);
    });
  }

  void clearCart() {
    setState(() {
      cartService.cartItems.clear();
    });
  }

  bool isInCart(String itemName) {
    return cartService.cartItems.any((cartItem) => cartItem.item["name"] == itemName);
  }

  void toggleCartItem(Map<String, dynamic> item) {
    setState(() {
      if (isInCart(item["name"])) {
        cartService.cartItems.removeWhere((cartItem) => cartItem.item["name"] == item["name"]);
      } else {
        cartService.addToCart(ProductItem(item: item));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(cartService.cartItems);
        },
        child: const Icon(Icons.shopping_cart),
      ),
      appBar: AppBar(
        title: const Text("Корзина"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: clearCart, 
          ),
        ],
      ),
      body: cartService.cartItems.isEmpty
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
                    itemCount: cartService.cartItems.length,
                    itemBuilder: (context, index) {
                      final productItem = cartService.cartItems[index];

                      return ListTile(
                        title: Text(productItem.item["name"]),
                        subtitle: Text("${productItem.item["price"]} ТГ"),
                        trailing: ElevatedButton(
                          onPressed: () => toggleCartItem(productItem.item),
                          child: Text(
                            isInCart(productItem.item["name"]) ? "Удалить" : "Добавить",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
