import 'package:flutter/material.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminDashBoardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
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
