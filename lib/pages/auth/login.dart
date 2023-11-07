import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

Future<void> login(String email, String password) async {
  try {
    Response response = await post(
        Uri.parse('https://mindcare.allsites.es/public/api/login'),
        body: {'email': email, 'password': password},
        headers: {'Accept': '*/*'});
    if (response.statusCode == 200) {
      print('Se ha iniciado sesión');
    } else {
      print(response.statusCode);
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
        title: Text('Login Page'),
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
              login(emailController.text.toString(),
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
