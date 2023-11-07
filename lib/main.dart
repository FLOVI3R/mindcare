import 'package:flutter/material.dart';
import 'package:mindcare/pages/admin/admin_dashboard.dart';
import 'package:mindcare/pages/auth/forgotpassword.dart';
import 'package:mindcare/pages/auth/login.dart';
import 'package:mindcare/pages/auth/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Definimos la ruta inicial
      initialRoute: '/',
      // Definimos la lista de rutas en nuestra aplicación
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => MyHomePage(),
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'forgotPassword': (BuildContext context) => ForgotPasswordPage(),
        'admin': (BuildContext context) => AdminDashBoardPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('MINDCARE APP'),
          ElevatedButton(
            onPressed: () {
              print('LOGIN!');
              Navigator.pushReplacementNamed(context, "login");
            },
            child: Text('LOGIN'),
          ),
          ElevatedButton(
            onPressed: () {
              print('REGISTER!');
              Navigator.pushReplacementNamed(context, "register");
            },
            child: Text('REGISTER'),
          ),
        ],
      ),
    );
  }
}
