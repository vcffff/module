import 'package:flutter/material.dart';

import 'main.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    loginController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      obscure = !obscure;
    });
  }

  void register() {
    String login = loginController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (login.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заполните все поля')),
      );
    } else if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Введите корректную почту')),
      );
    } else {

      Navigator.push(context, MaterialPageRoute(builder: (context) => IndexedScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Регистрация"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: loginController,
              decoration: InputDecoration(hintText: 'Логин', border: InputBorder.none),
            ),
            Container(color: Colors.black, width: double.infinity, height: 1),

            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Почта', border: InputBorder.none),
            ),
            Container(color: Colors.black, width: double.infinity, height: 1),

            TextField(
              controller: passwordController,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: 'Пароль',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: togglePasswordVisibility,
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),
            Container(color: Colors.black, width: double.infinity, height: 1),

            const Spacer(),

            ElevatedButton(
              onPressed: register,
              child: Text('Создать аккаунт'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: Size(480, 65),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}