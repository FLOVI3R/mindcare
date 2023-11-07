import 'package:flutter/material.dart';
import 'package:http/http.dart';

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController rPasswordController = TextEditingController();

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> register(
    String name, String email, String password, String rPassword) async {
  try {
    Response response = await post(
        Uri.parse('https://mindcare.allsites.es/public/api/register'),
        body: {
          'name': name,
          'email': email,
          'password': password,
          'rPassword': rPassword
        });
    if (response.statusCode == 200) {
      print('Usuario registrado');
    } else {
      print('error');
    }
  } catch (e) {
    print(e.toString());
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Register Page'),
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
              print('LOGIN!');
              Navigator.pushReplacementNamed(context, "login");
            },
            child: Text('LOGIN'),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  hintText: 'Introduzca su nombre y apellidos.'),
            ),
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
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: rPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirmar contraseña',
                  hintText: 'Introduzca de nuevo su contraseña.'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print('Ha iniciado sesión!');
              Navigator.pushReplacementNamed(context, "admin");
            },
            child: Text('REGISTRAR USUARIO'),
          ),
        ],
      ),
    );
  }
}
