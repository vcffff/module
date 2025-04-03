import 'package:flutter/material.dart';
import 'main.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
TextEditingController control1=TextEditingController();
TextEditingController control2=TextEditingController();

String errormes='';
  void checking() {
    String email = control1.text.trim();
    String password = control2.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errormes = 'Заполните все поля';
      });
      return;
    }

    // Enhanced email validation logic
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

    
    Navigator.push(context, MaterialPageRoute(builder: (context) => IndexedScreen()));
    setState(() {
      errormes = '';
    });
  }
  bool changer=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:const Text('Регистрация'),centerTitle: true,),
    body: Column(children: [
      SizedBox(height: 20,),
     const TextField( 
        decoration: InputDecoration(
          labelText: 'Логин',
          border: OutlineInputBorder(borderSide: BorderSide.none,),
        ),
      ),
      Container(height: 1,width: 480,color: Colors.grey[400],),
      TextField( 
        controller: control1,
        decoration: InputDecoration(
          labelText: 'Почта',
          border: OutlineInputBorder(borderSide: BorderSide.none,),
        ),
      ),
      Container(height: 1,width: 480,color: Colors.grey[400],),
      TextField( 
        controller: control2,
        obscureText: changer,
        decoration: InputDecoration(
          labelText: 'Пароль',
          border: OutlineInputBorder(borderSide: BorderSide.none,),
          suffixIcon: IconButton(
            icon: Icon(changer?Icons.visibility_off:Icons.visibility),
            onPressed: () {setState(() {
              changer=!changer;
            });},
          ),
        ),
      ),
      Container(height: 1,width: 480,color: Colors.grey[400],),
      Text(errormes,style: const TextStyle(color: Colors.red),),
      SizedBox(height: 400,),
       SizedBox(
              width: 460,
              height: 50,
              child: ElevatedButton(
                onPressed: (){checking();},
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
    ],),
    );
  }
}