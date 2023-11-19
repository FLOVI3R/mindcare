import 'package:flutter/material.dart';
import 'package:http/http.dart';

TextEditingController nameController = TextEditingController();

class AdminUpdateUserPage extends StatefulWidget {
  final String token;
  final int id;

  const AdminUpdateUserPage({super.key, required this.token, required this.id});

  @override
  State<StatefulWidget> createState() => _AdminUpdateUserState();
}

Future<void> updateUser(
    int idUser, String tokenApi, String newName, BuildContext context) async {
  final navigator = Navigator.of(context);
  try {
    final uri = Uri.parse('https://mindcare.allsites.es/public/api/updated');
    Response response = await post(
      uri,
      body: {
        'id': idUser.toString(),
        'name': newName,
      },
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokenApi'
      },
    );
    navigator.pop();
  } catch (e) {
    print(e.toString());
  }
}

class _AdminUpdateUserState extends State<AdminUpdateUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('ADMIN | Edición de usuario'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/");
            },
            child: Text('<-'),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  hintText: 'Introduzca nuevo nombre y apellidos.'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              updateUser(widget.id, widget.token,
                  nameController.text.toString(), context);
            },
            child: Text('ACTUALIZAR NOMBRE USUARIO'),
          ),
        ],
      ),
    );
  }
}
