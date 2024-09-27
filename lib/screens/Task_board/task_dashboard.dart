import 'package:flutter/material.dart';
import 'addTask.dart';
import 'package:task_management_app/screens/Task_board/edittask.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:intl/intl.dart';

class TaskDashboard extends StatefulWidget {
  const TaskDashboard({Key? key}) : super(key: key);

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Dashboard'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/background.jpg', // Correct asset path
              fit: BoxFit.cover, // Make sure it covers the screen
            ),
          ),
          // Task content
          SafeArea(
            child: FutureBuilder<List<ParseObject>>(
              future: _getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching tasks."));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No tasks available."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final task = snapshot.data![index];
                    final title = task.get<String>('title')!;
                    final dueDate = task.get<DateTime>('dueDate')!;
                    final isCompleted = task.get<bool>('done')!;

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          title,
                          style: TextStyle(
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle:
                            Text('Due: ${DateFormat.yMMMd().format(dueDate)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: isCompleted,
                              onChanged: (value) {
                                setState(() {
                                  task.set('done', value);
                                  task.save();
                                });
                              },
                            ),
                            if (!isCompleted)
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditTaskScreen(task.objectId!),
                                    ),
                                  );
                                },
                              ),
                            if (isCompleted)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await task.delete();
                                  setState(() {}); // Refresh task list after deletion
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          if (result == true) {
            setState(() {}); // Refresh task list
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Future<List<ParseObject>> _getTasks() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;

    if (currentUser == null) {
      return [];
    }

    QueryBuilder<ParseObject> query = QueryBuilder(ParseObject('Task'))
      ..whereEqualTo('createdBy', currentUser.objectId); // Filter by user ID

    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}
