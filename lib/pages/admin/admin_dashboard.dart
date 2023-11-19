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
    final uri = Uri.parse('https://mindcare.allsites.es/public/api/deleted');
    Response response = await post(
      uri,
      body: {'id': idUser.toString()},
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.admin.token}'
      },
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
  }

  Future<void> _activateUser(int idUser) async {
    final uri = Uri.parse('https://mindcare.allsites.es/public/api/activate');
    Response response = await post(
      uri,
      body: {'id': idUser.toString()},
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.admin.token}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future<void> _deactivateUser(int idUser) async {
    final uri = Uri.parse('https://mindcare.allsites.es/public/api/deactivate');
    Response response = await post(
      uri,
      body: {'id': idUser.toString()},
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.admin.token}'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal ${widget.admin.name}'),
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
                            title: Text(snapshot.data![index].name),
                            subtitle:
                                Text(snapshot.data![index].actived.toString()),
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
