import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:untitled9/catalogue.dart';
import 'package:untitled9/productpage.dart';
import 'main.dart';
import 'register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

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
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    loadUsers();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => IndexedScreen(
                  user: {'hello': 'hello2'},
                )),
      );
    }
  }

  Future<void> loadUsers() async {
    try {
      String jsonString = await rootBundle.loadString('assets/login.json');
      setState(() {
        users = jsonDecode(jsonString);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errormes = 'Ошибка загрузки данных';
        isLoading = false;
      });
    }
  }

  Future<void> saveUser(String name, String email, String password) async {
    final box = await Hive.openBox('users');
    box.add({'name': name, 'mail': email, 'password': password});
  }

  void registerUser() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
    );
  }

  void checking() async {
    String email = control1.text.trim();
    String password = control2.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errormes = 'Заполните все поля';
      });
      return;
    }

    if (!email.contains('@') || !email.endsWith('.com')) {
      setState(() {
        errormes = 'Введите корректную почту';
      });
      return;
    }

    bool found = users
        .any((item) => item['mail'] == email && item['password'] == password);
    if (!found) {
      setState(() {
        errormes = 'Неверный логин или пароль';
      });
      return;
    }

    setState(() {
      errormes = '';
    });
    Map<String, String> usergoi = {
      'name': '${control1.text}',
      'mail': '${control2.text}',
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => IndexedScreen(user: usergoi)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Авторизация"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: control1,
              decoration: const InputDecoration(
                hintText: 'Почта',
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            TextField(
              obscureText: obscure,
              controller: control2,
              decoration: InputDecoration(
                hintText: 'Пароль',
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: checking,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Войти'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Регистрация'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              errormes,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
