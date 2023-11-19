import 'package:flutter/material.dart';
import 'package:http/http.dart';

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController cPasswordController = TextEditingController();

class Register extends StatelessWidget {
  const Register({super.key});

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

Future<void> register(BuildContext context, String name, String email,
    String password, String cPassword) async {
  final navigator = Navigator.of(context);
  try {
    final uri = Uri.parse('https://mindcare.allsites.es/public/api/register');
    Response response = await post(
      uri,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'c_password': password
      },
      headers: {'Accept': '*/*'},
    );
    if (response.statusCode == 200) {
      navigator.pushNamed('login');
    } else {
      // ignore: use_build_context_synchronously
      showFlashError(
          context, 'Se ha producido un error al registrar el usuario');
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
        title: Text('Registro de Usuario'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "login");
            },
            child: Text('Iniciar Sesión'),
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
              controller: cPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirmar contraseña',
                  hintText: 'Introduzca de nuevo su contraseña.'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              register(
                  context,
                  nameController.text.toString(),
                  emailController.text.toString(),
                  passwordController.text.toString(),
                  cPasswordController.text.toString());
            },
            child: Text('REGISTRAR USUARIO'),
          ),
        ],
      ),
    );
  }
}
