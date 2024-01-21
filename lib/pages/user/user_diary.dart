import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mindcare/models/Diary.dart';
import 'package:mindcare/models/loggedUser.dart';
import 'package:mindcare/pages/user/user_mindfulness.dart';

TextEditingController descriptionController = TextEditingController();

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
      List<Diary> newDiaryList = [];
      for (var diary in data) {
        Diary d = Diary(
            id: diary['id'],
            type: diary['type'].toString(),
            name: diary['name'].toString(),
            description: diary['description'].toString(),
            date: diary['date'].toString(),
            image: diary['image'].toString(),
            created_at: diary['created_at'].toString());
        newDiaryList.add(d);
      }
      return newDiaryList;
    } catch (e) {
      print(e.toString());
    }
    return diaryList;
  }

  void create(String type, String description, String emotion, String mood) {
    Map<String, String> bodyType;
    if (type == 'mood') {
      bodyType = {
        'id_user': widget.user.id.toString(),
        'type_user': widget.user.type.toString(),
        'type': 'mood',
        'mood_id': mood
      };
    } else if (type == 'emotion') {
      bodyType = {
        'id_user': widget.user.id.toString(),
        'type_user': widget.user.type.toString(),
        'type': 'emotion',
        'emotion_id': emotion
      };
    } else {
      bodyType = {
        'id_user': widget.user.id.toString(),
        'type_user': widget.user.type.toString(),
        'type': 'event',
        'description': description,
        'date': DateTime.now().toString(),
      };
    }
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Crear nueva entrada para su Diario Personal'),
            content: const Text(
                '¿Está seguro de querer crear una nueva entrada para su Diario Personal?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      final uri = Uri.parse(
                          'https://mindcare.allsites.es/public/api/newElement');
                      Response response = await post(
                        uri,
                        body: bodyType,
                        headers: {
                          'Accept': 'application/json',
                          'Authorization': 'Bearer ${widget.user.token}'
                        },
                      );
                      if (response.statusCode == 200) {
                        // ignore: use_build_context_synchronously
                        showFlashMessage(context,
                            'Se ha añadido la entrada al diario correctamente.');
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => widget));
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text('Sí')),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text('Menú de navegación'),
            ),
            ListTile(
              title: const Text('Diario'),
              selectedColor: Colors.white,
              selectedTileColor: Colors.purple,
              selected: true,
              onTap: () {},
            ),
            ListTile(
              title: const Text('MindFulness'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserMindFulnessPage(user: widget.user)),
                );
              },
            ),
          ],
        ),
      ),
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
                      if (snapshot.data![index].type == 'mood') {
                        return Card(
                            color: Color.fromARGB(255, 236, 227, 144),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,
                            child: Column(children: <Widget>[
                              if (snapshot.data![index].image != '') ...[
                                Image(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage(snapshot.data![index].image),
                                )
                              ],
                              ListTile(
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 10, 25, 0),
                                title: Text(
                                    'ESTADO DE ÁNIMO  ${snapshot.data![index].created_at}'),
                                subtitle:
                                    Text(snapshot.data![index].description),
                                leading: Icon(Icons.mood),
                              )
                            ]));
                      } else if (snapshot.data![index].type == 'emotion') {
                        return Card(
                            color: Color.fromARGB(255, 235, 191, 129),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,
                            child: Column(children: <Widget>[
                              if (snapshot.data![index].image != '') ...[
                                Image(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage(snapshot.data![index].image),
                                )
                              ],
                              ListTile(
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 10, 25, 0),
                                title: Text(
                                    'EMOCIÓN:  ${snapshot.data![index].created_at}'),
                                subtitle: Text(snapshot.data![index].name),
                                leading: Icon(Icons.emoji_emotions),
                              )
                            ]));
                      } else {
                        return Card(
                            color: Color.fromARGB(255, 158, 236, 144),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,
                            child: Column(children: <Widget>[
                              if (snapshot.data![index].image != '') ...[
                                Image(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage(snapshot.data![index].image),
                                )
                              ],
                              ListTile(
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 10, 25, 0),
                                title: Text(
                                    'EVENTO  ${snapshot.data![index].date}'),
                                subtitle:
                                    Text(snapshot.data![index].description),
                                leading: Icon(Icons.event),
                              )
                            ]));
                      }
                    },
                  );
                } else {
                  return Text('No se ha encontrado el diario...');
                }
              })),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text('Crear registro'),
                    content: const Text('¿Está seguro?'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.mood),
                        tooltip: 'CREAR ESTADO DE ÁNIMO',
                        color: Color.fromARGB(255, 236, 227, 144),
                        hoverColor: Color.fromARGB(255, 162, 150, 45),
                        iconSize: 50,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text(
                                      'Elija un estado de ánimo para agregar al Diario Personal.'),
                                  actions: [
                                    IconButton(
                                        tooltip: 'CONTENTO',
                                        onPressed: () {
                                          create('mood', '', '', '2');
                                        },
                                        iconSize: 100,
                                        icon: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://mindcare.allsites.es/public/images/alegria.png'),
                                        )),
                                    IconButton(
                                        tooltip: 'ENFADADO',
                                        onPressed: () {
                                          create('mood', '', '', '1');
                                        },
                                        iconSize: 100,
                                        icon: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://mindcare.allsites.es/public/images/ira.png'),
                                        )),
                                  ],
                                );
                              });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.emoji_emotions_sharp),
                        tooltip: 'CREAR EMOCIÓN',
                        color: Color.fromARGB(255, 235, 191, 129),
                        hoverColor: Color.fromARGB(255, 255, 167, 52),
                        iconSize: 50,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text(
                                      'Elija una emoción para agregar al Diario Personal.'),
                                  actions: [
                                    IconButton(
                                        tooltip: 'ALEGRÍA',
                                        onPressed: () {
                                          create('emotion', '', '1', '');
                                        },
                                        iconSize: 100,
                                        icon: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://mindcare.allsites.es/public/images/alegria.png'),
                                        )),
                                    IconButton(
                                        tooltip: 'TRISTEZA',
                                        onPressed: () {
                                          create('emotion', '', '2', '');
                                        },
                                        iconSize: 100,
                                        icon: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://mindcare.allsites.es/public/images/tristeza.png'),
                                        )),
                                    IconButton(
                                        tooltip: 'ASCO',
                                        onPressed: () {
                                          create('emotion', '', '3', '');
                                        },
                                        iconSize: 100,
                                        icon: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://mindcare.allsites.es/public/images/asco.png'),
                                        )),
                                    IconButton(
                                        tooltip: 'IRA',
                                        onPressed: () {
                                          create('emotion', '', '4', '');
                                        },
                                        iconSize: 100,
                                        icon: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://mindcare.allsites.es/public/images/ira.png'),
                                        )),
                                    IconButton(
                                        tooltip: 'MIEDO',
                                        onPressed: () {
                                          create('emotion', '', '5', '');
                                        },
                                        iconSize: 100,
                                        icon: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://mindcare.allsites.es/public/images/miedo.png'),
                                        )),
                                  ],
                                );
                              });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.event),
                        tooltip: 'CREAR EVENTO',
                        color: Color.fromARGB(255, 158, 236, 144),
                        hoverColor: Color.fromARGB(255, 37, 148, 79),
                        iconSize: 50,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text(
                                      'Escriba una breve descripción.'),
                                  actions: [
                                    TextField(
                                      controller: descriptionController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText:
                                            'Escriba una breve descripción del evento sucedido.',
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          create(
                                              'event',
                                              descriptionController.text
                                                  .toString(),
                                              '',
                                              '');
                                        },
                                        child: Text('Aceptar')),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar'))
                                  ],
                                );
                              });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel),
                        tooltip: 'CANCELAR',
                        color: Color.fromARGB(255, 238, 94, 94),
                        hoverColor: Color.fromARGB(255, 249, 24, 24),
                        iconSize: 50,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
