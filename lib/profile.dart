import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'login.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List login = [];

  Future<void> loadProfileData() async {
    String data = await rootBundle.loadString('assets/login.json');
    setState(() {
      login = jsonDecode(data);
    });
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
                Image.asset(
                  'assets/avatar_placeholder_icon.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  login[0]['name'],
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  login[0]['mail'],
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(left: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Выйти',
              style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}