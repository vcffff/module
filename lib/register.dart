import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:untitled9/login.dart';
import 'dart:convert';
import 'profile.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const Mainpage());
}

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late Box mainbox;
  TextEditingController control1 = TextEditingController();
  TextEditingController control2 = TextEditingController();
  TextEditingController login = TextEditingController();

  List<Map<String, dynamic>> datas = [];

  @override
  void initState() {
    super.initState();
    adding();
    jsonDecodeData();
  }

  Future<void> jsonDecodeData() async {
    String jsonString = await rootBundle.loadString('assets/login.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      datas = jsonData.cast<Map<String, dynamic>>();
    });
  }

  Future<void> adding() async {
    mainbox = await Hive.openBox('users');
    if (!mainbox.containsKey('users')) {
      await mainbox.put('users', []);
    }
    setState(() {});
  }

  void creatinaccout() {
    String email = control1.text.trim();
    String password = control2.text.trim();
    String userLogin = login.text.trim();

    if (email.isEmpty || password.isEmpty || userLogin.isEmpty) {
      setState(() {
        errormes = 'Заполните все поля';
      });
      return;
    }

    bool exists = datas.any((user) =>
        user['mail'] == email ||
        user['password'] == password ||
        user['name'] == email);

    if (exists) {
      setState(() {
        errormes = 'Такой логин уже существует';
      });
      return;
    }

    final user = {
      'name': userLogin,
      'mail': email,
      'password': password,
    };

    List users = mainbox.get('users', defaultValue: []);
    users.add(user);
    mainbox.put('users', users);

    setState(() {
      errormes = '';
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IndexedScreen(user: user)),
    );

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(user['name'] ?? 'there is nothing')));
  }

  String errormes = '';
  bool changer = true;

  void checking() {
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

    if (password.length < 6) {
      setState(() {
        errormes = 'Пароль должен содержать не менее 6 символов';
      });
      return;
    }

    creatinaccout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: login,
                    decoration: const InputDecoration(
                      labelText: 'Логин',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: control1,
                    decoration: const InputDecoration(
                      labelText: 'Почта',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: control2,
                    obscureText: changer,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                            changer ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            changer = !changer;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    errormes,
                    style: const TextStyle(color: Colors.red),
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
                      child: const Text('Создать аккаунт'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
