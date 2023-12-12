import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mindcare/models/Diary.dart';
import 'package:mindcare/models/loggedUser.dart';

class UserDiaryPage extends StatefulWidget {
  final loggedUser user;

  UserDiaryPage({required this.user});

  @override
  State<UserDiaryPage> createState() => _UserDiaryState();
}

class _UserDiaryState extends State<UserDiaryPage> {
  late Future<List<Diary>> diaryList;

  _UserDiaryState();

  @override
  void initState() {
    super.initState();
    diaryList = getDiary();
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

  Future<List<Diary>> getDiary() async {
    try {
      final id = {'id': widget.user.id.toString()};
      final uri = Uri.https('mindcare.allsites.es', '/public/api/elements', id);
      Response response = await get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.user.token}'
        },
      );
      final data = jsonDecode(response.body)['data'];
      print(data);
      List<Diary> newDiaryList = [];
      for (var diary in data) {
        Diary d = Diary(
            id: diary['id'],
            type: diary['type'],
            name: diary['name'],
            description: diary['description'],
            date: diary['date'],
            image: diary['image'],
            created_at: diary['created_at']);
        newDiaryList.add(d);
      }
      return newDiaryList;
    } catch (e) {
      print(e.toString());
    }
    return diaryList;
  }

  void create() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Crear registro'),
            content: const Text('¿Está seguro?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      final uri = Uri.parse(
                          'https://mindcare.allsites.es/public/api/newElement');
                      Response response = await post(
                        uri,
                        body: {
                          'id_user': widget.user.id.toString(),
                          'type_user': widget.user.type.toString(),
                          'type': 'mood',
                          'mood_id': '1'
                        },
                        headers: {
                          'Accept': 'application/json',
                          'Authorization': 'Bearer ${widget.user.token}'
                        },
                      );
                      if (response.statusCode != 200) {
                        print(response.body);
                        // ignore: use_build_context_synchronously
                        showFlashError(context, 'Mal.');
                      } else {
                        // ignore: use_build_context_synchronously
                        showFlashMessage(context, 'Bien.');
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: const Text('Si')),
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
        title: Text('USUARIO | DIARIO | ${widget.user.name}'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
          child: FutureBuilder<List<Diary>>(
              future: diaryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: Column(children: <Widget>[
                            ListTile(
                              contentPadding:
                                  EdgeInsets.fromLTRB(15, 10, 25, 0),
                              title: Text(
                                  '${snapshot.data![index].id}   ${snapshot.data![index].name}'),
                              subtitle: Text(snapshot.data![index].description),
                              leading: Icon(Icons.emoji_emotions),
                            ),
                          ]));
                    },
                  );
                } else {
                  return Text('No se ha encontrado el diario...');
                }
              })),
    );
  }
}
