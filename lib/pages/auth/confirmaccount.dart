import 'package:flutter/material.dart';

class ConfirmAccount extends StatelessWidget {
  const ConfirmAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConfirmAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar cuenta de usuario'),
        backgroundColor: Colors.purple,
      ),
      body: Column(children: [
        Text(
            'Para iniciar sesión debe primero confirmar su email y que un administrador le valide la cuenta.'),
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
