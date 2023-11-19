import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mindcare/models/loggedUser.dart';
import 'package:mindcare/pages/admin/admin_dashboard.dart';

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
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      loggedUser logUser = loggedUser.fromJson(data['data']);
      if (logUser.type == 'a') {
        navigator.push(MaterialPageRoute(
            builder: (context) => AdminDashBoardPage(admin: logUser)));
      } else {
        navigator.pushReplacementNamed('user', arguments: logUser);
      }
    } else if (response.statusCode == 404) {
      print(response.statusCode);
      print(response.body);
      navigator.pushReplacementNamed('confirmAccount');
    } else {
      print(response.statusCode);
      print(response.body);
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
          ElevatedButton(
            onPressed: () {
              print('HOME!');
              Navigator.pushReplacementNamed(context, "/");
            },
            child: Text('HOME'),
          ),
          ElevatedButton(
            onPressed: () {
              print('REGISTER!');
              Navigator.pushReplacementNamed(context, "register");
            },
            child: Text('REGISTER'),
          ),
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
              Navigator.pushReplacementNamed(context, "forgotPassword");
            },
            child: Text(
                '¿Ha olvidado su contraseña? Haga click aquí para cambiarla.'),
          ),
        ],
      ),
    );
  }
}
