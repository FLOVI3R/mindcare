import 'package:flutter/material.dart';
import 'package:mindcare/pages/admin/admin_dashboard.dart';
import 'package:mindcare/pages/auth/confirmaccount.dart';
import 'package:mindcare/pages/auth/forgotpassword.dart';
import 'package:mindcare/pages/auth/login.dart';
import 'package:mindcare/pages/auth/register.dart';
import 'package:mindcare/pages/user/user_mainMenu.dart';

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
      initialRoute: 'login',
      // Definimos la lista de rutas en nuestra aplicación
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'forgotPassword': (BuildContext context) => ForgotPasswordPage(),
        'confirmAccount': (BuildContext context) => ConfirmAccountPage(),
        'user': (BuildContext context) => UserMainMenuPage()
      },
    );
  }
}
