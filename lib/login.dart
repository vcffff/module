import 'package:flutter/material.dart';
import 'main.dart';

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

  void checking() {
    String email = control1.text;
    String password = control2.text;

    if (email.isEmpty &&  password.isEmpty) {
      setState(() {
        errormes = 'Заполните все поля';
      });
    } else if (!email.contains('@') && !email.contains('.')) {
    setState(() {
    errormes = 'Введите корректную почту';
    });
    } else {
    setState(() {
    errormes = '';
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => IndexedScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Авторизация"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                TextField(
                  controller: control1,
                  decoration: const InputDecoration(hintText: 'Почта', border: InputBorder.none),
                ),
                const Divider(color: Colors.black),
                TextField(
                  obscureText: obscure,
                  controller: control2,
                  decoration: const InputDecoration(hintText: 'Пароль', border: InputBorder.none),
                ),
                const SizedBox(height: 20),
                
                Container(width: double.infinity,
                height: 60,
                  child: ElevatedButton(
                    onPressed: checking,
                    child: const Text('Войти'),
                    style: ElevatedButton.styleFrom(
                      
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                 Container(width: double.infinity,
                height: 60,
                  child: ElevatedButton(
                    onPressed: checking,
                    child: const Text('Зарегистрироваться'),
                    style: ElevatedButton.styleFrom(
                      
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            errormes,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}