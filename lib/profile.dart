import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:untitled9/register.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final Map<String, String> user;
  const Profile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List login = [];
  String variable1 = 'Имя пользователя отсутствует';
  String variable2 = 'Почта пользователя отсутствует';

  Future<void> loadProfileData() async {
    String data = await rootBundle.loadString('assets/login.json');
    login = jsonDecode(data);

    bool found = login.any((element) =>
        element['name'] == widget.user['name'] ||
        element['mail'] == widget.user['mail'] ||
        element['password'] == widget.user['password']);

    if (!found) {
      setState(() {
        variable1 = widget.user['name'] ?? 'Имя пользователя отсутствует';
        variable2 = widget.user['mail'] ?? 'Почта пользователя отсутствует';
      });
    } else {
      var userfound = login.firstWhere((element) =>
          element['name'] == widget.user['name'] ||
          element['mail'] == widget.user['mail']);

      setState(() {
        variable1 = userfound['name'] ?? 'Имя пользователя отсутствует';
        variable2 = userfound['mail'] ?? 'Почта пользователя отсутствует';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
      ),
      body: login.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  widget.user['name'] ?? 'Имя пользователя отсутствует')),
                        ),
                        child: Image.asset(
                          'assets/avatar_placeholder_icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        variable1,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        variable2,
                        style: const TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Выйти',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
    );
  }
}
