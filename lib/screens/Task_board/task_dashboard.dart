import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_management_app/screens/Task_board/addTask.dart';
import 'package:task_management_app/screens/Auth/login.dart';
import 'package:task_management_app/screens/Task_board/editTask.dart';
import 'package:intl/intl.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

bool show = true;

class _Home_ScreenState extends State<Home_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management Tool'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 40,
              ),
              onPressed: () => doUserLogout(context),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Add_creen(),
            ));
          },
          backgroundColor: Colors.blue, // Button background color
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white, // Icon color
          ),
        ),
      ),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                show = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                show = false;
              });
            }
            return true;
          },
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<List<ParseObject>>(
                      future: getTodo(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                              child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator()),
                            );
                          default:
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text("Error..."),
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                child: Text(
                                  "No Task",
                                  style: TextStyle(
                                    fontSize:
                                        40, // Adjust the font size as needed
                                    fontWeight: FontWeight
                                        .bold, // Optionally, set the font weight
                                  ),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    //*************************************
                                    //Get Parse Object Values
                                    final varTodo = snapshot.data![index];
                                    final varTitle =
                                        varTodo.get<String>('title')!;
                                    final varSubtitle =
                                        varTodo.get<String>('subtitle')!;
                                    final dueDate =
                                        varTodo.get<DateTime>('selectedDate')!;
                                    final varDone = varTodo.get<bool>('done')!;

                                    //*************************************

                                    return ListTile(
                                      title: Text(
                                        varTitle,
                                        style: const TextStyle(
                                          fontSize:
                                              20, // Adjust the font size as needed
                                          fontWeight: FontWeight
                                              .bold, // Optionally, set the font weight
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            varSubtitle,
                                            style: const TextStyle(
                                              fontSize:
                                                  18, // Adjust the font size as needed
                                            ),
                                          ),
                                          Text(
                                            'Due Date: ${DateFormat('dd/MM/yyyy').format(dueDate)}',
                                            style: const TextStyle(
                                              fontSize:
                                                  16, // Adjust the font size as needed
                                            ),
                                          ),
                                        ],
                                      ),
                                      leading: Transform.scale(
                                        scale:
                                            2.0, // Adjust scale factor as needed
                                        child: Checkbox(
                                          value: varDone,
                                          onChanged: (value) async {
                                            await updateTodo(
                                              varTodo.objectId!,
                                              value!,
                                            );
                                            setState(() {
                                              // Refresh UI
                                            });
                                          },
                                          checkColor: Colors
                                              .white, // Set the color of the checked checkbox
                                          activeColor: Colors
                                              .green, // Set the color of the unchecked checkbox
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.orange, size: 30),
                                            onPressed: () async {
                                              await editTodo(
                                                  varTodo.objectId!, context);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.black, size: 30),
                                            onPressed: () async {
                                              await deleteTodo(
                                                  varTodo.objectId!);
                                              setState(() {
                                                const snackBar = SnackBar(
                                                  content:
                                                      Text("Task deleted!"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                );
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(snackBar);
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

doUserLogout(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => const LoginPage()), // Navigate to RegisterPage
  );
}

Future<void> saveTodo(String title) async {
  final todo = ParseObject('Todo')
    ..set('title', title)
    ..set('done', false);
  await todo.save();
}

Future<List<ParseObject>> getTodo() async {
  QueryBuilder<ParseObject> queryTodo =
      QueryBuilder<ParseObject>(ParseObject('Todo'));
  final ParseResponse apiResponse = await queryTodo.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

Future<void> updateTodo(String id, bool done) async {
  var todo = ParseObject('Todo')
    ..objectId = id
    ..set('done', done);
  await todo.save();
}

Future<void> deleteTodo(String id) async {
  var todo = ParseObject('Todo')..objectId = id;
  await todo.delete();
}

Future<void> editTodo(String id, context) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => Edit_Screen(id),
  ));
}