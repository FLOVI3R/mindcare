import 'package:flutter/material.dart';

class UserMainMenu extends StatelessWidget {
  const UserMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserMainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Main Menu'),
        backgroundColor: Colors.purple,
      ),
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/");
          },
          child: Text('SALIR'),
        ),
      ]),
    );
  }
}
