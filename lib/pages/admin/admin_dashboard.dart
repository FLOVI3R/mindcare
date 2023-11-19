import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:mindcare/models/loggedUser.dart';

import '../../models/user.dart';

class AdminDashBoardPage extends StatefulWidget {
  final loggedUser admin;

  AdminDashBoardPage({required this.admin});

  @override
  State<AdminDashBoardPage> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoardPage> {
  late Future<List<User>> userList;

  _AdminDashBoardState();

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
    return userList;
  }

  @override
  void initState() {
    super.initState();
    userList = getUserList();
  }

  void _updateUser() {}

  void _deleteUser() {}

  void _activateUser() {}

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
                              children: [
                                SlidableAction(
                                    backgroundColor:
                                        Color.fromARGB(255, 146, 241, 222),
                                    icon: Icons.verified_user_outlined,
                                    label: 'Activar',
                                    onPressed: ((context) => _activateUser())),
                                SlidableAction(
                                    backgroundColor:
                                        Color.fromARGB(255, 211, 99, 231),
                                    icon: Icons.update,
                                    label: 'Editar',
                                    onPressed: ((context) => _updateUser())),
                                SlidableAction(
                                    backgroundColor:
                                        Color.fromARGB(255, 176, 39, 126),
                                    icon: Icons.delete,
                                    label: 'Eliminar',
                                    onPressed: ((context) => _deleteUser())),
                              ]),
                          direction: Axis.horizontal,
                          enabled: true,
                          closeOnScroll: true,
                          child: ListTile(
                            title: Text(snapshot.data![index].name),
                            subtitle: Text(snapshot.data![index].email),
                          ));
                    },
                  );
                } else {
                  return Text('No data');
                }
              })),
    );
  }
}
