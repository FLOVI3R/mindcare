// ignore_for_file: file_names
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
        title: Text('Menú Principal Usuario'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
