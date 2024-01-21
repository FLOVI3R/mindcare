import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mindcare/models/loggedUser.dart';
import 'package:mindcare/pages/admin/admin_dashboard.dart';
import 'package:mindcare/pages/user/user_diary.dart';

import '../user/user_mindfulness.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

void showFlashError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

Future<void> login(BuildContext context, email, String password) async {
  try {
    final uri = Uri.parse('https://mindcare.allsites.es/public/api/login');
    final navigator = Navigator.of(context);
    Response response = await post(
      uri,
      body: {
        'email': email,
        'password': password,
      },
      headers: {'Accept': '*/*'},
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      loggedUser logUser = loggedUser.fromJson(data['data']);
      if (logUser.type == 'a') {
        navigator.push(MaterialPageRoute(
            builder: (context) => AdminDashBoardPage(admin: logUser)));
      } else {
        navigator.push(MaterialPageRoute(
            builder: (context) => UserMindFulnessPage(user: logUser)));
      }
    } else {
      if (data['data'].toString() == "{error: User don't activated}" ||
          data['data'].toString() == "{error: Email don't confirmed}") {
        navigator.pushReplacementNamed('confirmAccount');
      } else {
        // ignore: use_build_context_synchronously
        showFlashError(context,
            'Se ha producido un error al iniciar sesión, compruebe si sus credenciales están correctas y vuelva a intentarlo.');
      }
    }
  } catch (e) {
    print(e.toString());
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo Electrónico',
                  hintText: 'Introduzca su correo electrónico.'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                  hintText: 'Introduzca su contraseña.'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              login(context, emailController.text.toString(),
                  passwordController.text.toString());
            },
            child: Text('INICIAR SESIÓN'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "register");
            },
            child: Text(
                '¿Todavía no tiene una cuenta? Haga click aquí para crear una.'),
          ),
        ],
      ),
    );
  }
}
