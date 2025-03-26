class ProductItem {
  final Map<String, dynamic> item;
  int quantity;

  ProductItem({required this.item, this.quantity = 1});
}

class CartService {
  List<ProductItem> cartItems = [];

  void addToCart(ProductItem productItem) {
    int index = cartItems.indexWhere(
      (item) => item.item["name"] == productItem.item["name"],
    );

    if (index != -1) {
      cartItems[index].quantity += productItem.quantity;
    } else {
      cartItems.add(productItem);
    }
  }
}