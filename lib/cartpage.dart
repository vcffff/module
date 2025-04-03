import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'catalogue.dart';
import 'profile.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCart = prefs.getString('cartItems');
    if (savedCart != null) {
      setState(() {
        widget.cartItems.clear();
        widget.cartItems.addAll(List<Map<String, dynamic>>.from(
          (savedCart as List).map((item) => Map<String, dynamic>.from(item)),
        ));
      });
    }
  }

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartItems', widget.cartItems.toString());
  }

  void removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
      _saveCartItems();
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
      _saveCartItems();
    });
  }

  double calculateTotalPrice(){
    double total=0;
    for(var i=0;i<widget.cartItems.length;i++){
     final price=widget.cartItems[i]['price']??0;
     final quantity=widget.cartItems[i]['quantity']??1;
     total+=price*quantity;
    }
    return total;
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Корзина"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black54),
            onPressed: () {
              setState(() {
                widget.cartItems.clear();
                _saveCartItems();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "В вашей корзине пока пусто",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Добавьте товары из каталога.",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CataloguePage(cart: widget.cartItems),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: const Text("Перейти к каталогу", style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final productItem = widget.cartItems[index];
                      final quantity = productItem['quantity'] ?? 1;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productItem["name"],
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${productItem["price"]} ₸",
                                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeItem(index),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.black54),
                                  onPressed: () => updateQuantity(index, -1),
                                ),
                                Text(
                                  "$quantity шт",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.black54),
                                  onPressed: () => updateQuantity(index, 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  "Вся сумма:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${calculateTotalPrice().toInt()} ₸",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ]
                ),
                Container(
                  width: 220,
                  height: 40,
                  child: Expanded(child: ElevatedButton(onPressed: (){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заказ оформлен'),duration: Duration(seconds: 3),));setState(() {
                    widget.cartItems.clear();
                    _saveCartItems();
                  });;}, child: Text('Оформить заказ'),style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple,foregroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, 
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CataloguePage(cart: [])));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: SizedBox(
              height: 24,
              child: Image(image: AssetImage('assets/home_icon.png')),
            ), label: "Каталог"),
          BottomNavigationBarItem(icon:SizedBox(height: 24,child: Image(image: AssetImage('assets/shop_icon.png'),),), label: "Корзина"),
          BottomNavigationBarItem(icon:  SizedBox(height: 24,child: Image(image: NetworkImage('assets/profile_icon.png')),), label: "Профиль"),
        ],
      ),
    );
  }
}