import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:mindcare/models/loggedUser.dart';
import '../../models/user.dart';
import 'admin_updateUser.dart';

class AdminDashBoardPage extends StatefulWidget {
  final loggedUser admin;

  AdminDashBoardPage({required this.admin});

  @override
  State<AdminDashBoardPage> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoardPage> {
  late Future<List<User>> userList;

  _AdminDashBoardState();

  @override
  void initState() {
    super.initState();
    userList = getUserList();
  }

  void showFlashError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showFlashMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Future<List<User>> getUserList() async {
    final uri = Uri.parse('https://mindcare.allsites.es/public/api/users');
    Response response = await get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.admin.token}'
      },
    );
    final data = jsonDecode(response.body)['data'];
    List<User> userList = [];
    for (var user in data) {
      if (user['deleted'] == 0) {
        User u = User(
            id: user['id'],
            name: user['name'],
            email: user['email'],
            type: user['type'],
            email_confirmed: user['email_confirmed'],
            actived: user['actived'],
            deleted: user['deleted']);
        userList.add(u);
      }
    }
    return userList;
  }

  void _updateUser(int idUser) {
    final navigator = Navigator.of(context);
    navigator.push(MaterialPageRoute(
        builder: (context) =>
            AdminUpdateUserPage(id: idUser, token: widget.admin.token)));
  }

  Future<void> _deleteUser(int idUser) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Confirmar eliminación de usuario'),
            content:
                const Text('¿Está seguro de querer eliminar este usuario?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    final uri = Uri.parse(
                        'https://mindcare.allsites.es/public/api/deleted');
                    Response response = await post(
                      uri,
                      body: {'id': idUser.toString()},
                      headers: {
                        'Accept': 'application/json',
                        'Authorization': 'Bearer ${widget.admin.token}'
                      },
                    );
                    if (response.statusCode != 200) {
                      // ignore: use_build_context_synchronously
                      showFlashError(
                          context, 'No se ha podido borrar el usuario.');
                    } else {
                      // ignore: use_build_context_synchronously
                      showFlashMessage(
                          context, 'Usuario eliminado correctamente.');
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: const Text('Eliminar')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'))
            ],
          );
        });
  }

  Future<void> _activateUser(int idUser) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Confirmar activación usuario'),
            content: const Text('¿Esta seguro de querer activar este usuario?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    final uri = Uri.parse(
                        'https://mindcare.allsites.es/public/api/activate');
                    Response response = await post(
                      uri,
                      body: {'id': idUser.toString()},
                      headers: {
                        'Accept': 'application/json',
                        'Authorization': 'Bearer ${widget.admin.token}'
                      },
                    );
                    if (response.statusCode != 200) {
                      // ignore: use_build_context_synchronously
                      showFlashError(
                          context, 'No se ha podido activar el usuario.');
                    } else {
                      // ignore: use_build_context_synchronously
                      showFlashMessage(
                          context, 'Usuario activado correctamente.');
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: const Text('Activar')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'))
            ],
          );
        });
  }

  Future<void> _deactivateUser(int idUser) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Confirmar desactivación de usuario'),
            content:
                const Text('¿Está seguro de querer desactivar este usuario?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    final uri = Uri.parse(
                        'https://mindcare.allsites.es/public/api/deactivate');
                    Response response = await post(
                      uri,
                      body: {'id': idUser.toString()},
                      headers: {
                        'Accept': 'application/json',
                        'Authorization': 'Bearer ${widget.admin.token}'
                      },
                    );
                    if (response.statusCode != 200) {
                      // ignore: use_build_context_synchronously
                      showFlashError(
                          context, 'No se ha podido desactivar el usuario.');
                    } else {
                      // ignore: use_build_context_synchronously
                      showFlashMessage(
                          context, 'Usuario desactivado correctamente.');
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: const Text('Desactivar')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN | Menú Principal | ${widget.admin.name}'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
          child: FutureBuilder<List<User>>(
              future: userList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                          startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: <Widget>[
                                if (snapshot.data![index].actived == 0) ...[
                                  SlidableAction(
                                      backgroundColor:
                                          Color.fromARGB(255, 146, 241, 222),
                                      icon: Icons.verified_user_outlined,
                                      label: 'Activar',
                                      onPressed: ((context) => _activateUser(
                                          snapshot.data![index].id)))
                                ] else ...[
                                  SlidableAction(
                                      backgroundColor:
                                          Color.fromARGB(255, 246, 94, 185),
                                      icon: Icons.deselect_outlined,
                                      label: 'Desactivar',
                                      onPressed: ((context) => _deactivateUser(
                                          snapshot.data![index].id)))
                                ],
                                SlidableAction(
                                    backgroundColor:
                                        Color.fromARGB(255, 211, 99, 231),
                                    icon: Icons.edit,
                                    label: 'Editar',
                                    onPressed: ((context) =>
                                        _updateUser(snapshot.data![index].id))),
                                SlidableAction(
                                    backgroundColor:
                                        Color.fromARGB(255, 176, 39, 126),
                                    icon: Icons.delete,
                                    label: 'Eliminar',
                                    onPressed: ((context) =>
                                        _deleteUser(snapshot.data![index].id))),
                              ]),
                          direction: Axis.horizontal,
                          enabled: true,
                          closeOnScroll: true,
                          child: ListTile(
                            leading: Text(snapshot.data![index].id.toString()),
                            title: Text(
                                'Nombre: ${snapshot.data![index].name} | Email: ${snapshot.data![index].email}'),
                            subtitle: Text(
                                'Activado: ${snapshot.data![index].actived} | Email confirmado: ${snapshot.data![index].email_confirmed}'),
                          ));
                    },
                  );
                } else {
                  return Text('No se han encontrado usuarios...');
                }
              })),
    );
  }
}
