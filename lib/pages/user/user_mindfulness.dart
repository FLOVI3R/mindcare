import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mindcare/models/Diary.dart';
import 'package:mindcare/models/Exercise.dart';
import 'package:mindcare/models/loggedUser.dart';
import 'package:mindcare/pages/user/user_diary.dart';

TextEditingController descriptionController = TextEditingController();

class UserMindFulnessPage extends StatefulWidget {
  final loggedUser user;

  UserMindFulnessPage({required this.user});

  @override
  State<UserMindFulnessPage> createState() => _UserMindFulnessState();
}

class _UserMindFulnessState extends State<UserMindFulnessPage> {
  late Future<List<Exercise>> exerciseList;
  late Future<List<Exercise>> exerciseMadeList;

  _UserMindFulnessState();

  @override
  void initState() {
    exerciseList = getExercises();
    exerciseMadeList = getExerciseMade();
    super.initState();
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
        duration: Duration(seconds: 20),
      ),
    );
  }

  Future<List<Exercise>> getExercises() async {
    try {
      final id = {'id': widget.user.id.toString()};
      final uri =
          Uri.https('mindcare.allsites.es', '/public/api/exercises', id);
      Response response = await get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.user.token}'
        },
      );
      final data = jsonDecode(response.body)['data'];
      List<Exercise> newExerciseList = [];
      for (var exercise in data) {
        Exercise e = Exercise(
            id: exercise['id'],
            name: exercise['name'].toString(),
            improvement: exercise['improvement'].toString(),
            type: exercise['type'].toString(),
            explanation: exercise['explanation'].toString(),
            image: exercise['image'].toString(),
            audio: exercise['audio'].toString(),
            video: exercise['video'].toString());
        newExerciseList.add(e);
      }
      return newExerciseList;
    } catch (e) {
      print(e.toString());
    }
    return exerciseList;
  }

  void exerciseMade(int id) async {
    try {
      Map<String, String> bodyType = {
        'user_id': widget.user.id.toString(),
        'exercise_id': id.toString(),
      };
      final uri =
          Uri.parse('https://mindcare.allsites.es/public/api/newExerciseMade');
      Response response = await post(
        uri,
        body: bodyType,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.user.token}'
        },
      );
      if (response.statusCode == 200) {
        print('oc.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Exercise>> getExerciseMade() async {
    try {
      final id = {'id': widget.user.id.toString()};
      final uri =
          Uri.https('mindcare.allsites.es', '/public/api/exercises', id);
      Response response = await get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.user.token}'
        },
      );
      final data = jsonDecode(response.body)['data'];
      List<Exercise> newExerciseMadeList = [];
      for (var exercise in data) {
        Exercise e = Exercise(
            id: exercise['id'],
            name: exercise['name'].toString(),
            improvement: exercise['improvement'].toString(),
            type: exercise['type'].toString(),
            explanation: exercise['explanation'].toString(),
            image: exercise['image'].toString(),
            audio: exercise['audio'].toString(),
            video: exercise['video'].toString());
        newExerciseMadeList.add(e);
      }
      return newExerciseMadeList;
    } catch (e) {
      print(e.toString());
    }
    return exerciseMadeList;
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
              title: const Text('MindFulness'),
              selectedColor: Colors.white,
              selectedTileColor: Colors.purple,
              selected: true,
              onTap: () {},
            ),
            ListTile(
              title: const Text('Diario'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserDiaryPage(user: widget.user)),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('USUARIO | MINDFULNESS | ${widget.user.name}'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: FutureBuilder<List<Exercise>>(
            future: exerciseList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                          color: Colors.white,
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
                              title: Text(snapshot.data![index].name),
                              subtitle: Text(snapshot.data![index].type),
                              leading: Icon(Icons.star_border),
                              onTap: () => {
                                showFlashMessage(
                                    context, snapshot.data![index].explanation)
                              },
                            ),
                            ElevatedButton(
                                onPressed: () =>
                                    {exerciseMade(snapshot.data![index].id)},
                                child: Icon(Icons.check))
                          ]));
                    });
              } else {
                return Text('No se han encontrado ejercicios...');
              }
            }),
      ),
    );
  }
}
