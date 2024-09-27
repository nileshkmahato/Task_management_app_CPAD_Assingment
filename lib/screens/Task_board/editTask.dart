import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_management_app/screens/Task_board/task_dashboard.dart';

class Edit_Screen extends StatefulWidget {
  final String _todo;
  const Edit_Screen(this._todo, {super.key});

  @override
  State<Edit_Screen> createState() => _Edit_ScreenState();
}

class _Edit_ScreenState extends State<Edit_Screen> {
  TextEditingController? title;
  TextEditingController? subtitle;
  // TextEditingController? selectedDate;
  TextEditingController? objectId;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  int indexx = 0;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getTodoByID(widget._todo).then((List<ParseObject> todoList) {
      if (todoList.isNotEmpty) {
        final ParseObject todo = todoList.first;
        setState(() {
          objectId = TextEditingController(text: todo.get<String>('objectId'));
          title = TextEditingController(text: todo.get<String>('title'));
          subtitle = TextEditingController(text: todo.get<String>('subtitle'));
          // selectedDate = TextEditingController(
          //   text: todo.get<DateTime>('selectedDate').toString(),
          // );
        });
      } else {
        // Handle case where todo item with the given ID is not found
        print('Todo item not found');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management Tool'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title_widgets(),
            const SizedBox(height: 20),
            subtite_wedgite(),
            const SizedBox(height: 20),
            dateSelecter(context),
            const SizedBox(height: 40),
            button()
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(170, 48),
          ),
          onPressed: () async {
            if (title != null) {
              // Check if the title text field is not empty
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Task edited"),
                duration: Duration(seconds: 3),
              ));
              await updateTodo(objectId!.text, title!.text, subtitle!.text,
                  selectedDate); // Call saveTodo with text values
              // to redirect
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Home_Screen()), // Navigate to RegisterPage
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Title Cannot be Empty"),
                duration: Duration(seconds: 5),
              ));
            }
          },
          child: const Text(
            'Edit Task',
            style: TextStyle(
              color: Colors.white, // Set the text color here
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(170, 48),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const Home_Screen()), // Navigate to RegisterPage
            );
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white, // Set the text color here
            ),
          ),
        ),
      ],
    );
  }

  Widget title_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: 'title',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xffc5c5c5),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              )),
        ),
      ),
    );
  }

  Padding subtite_wedgite() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          maxLines: 3,
          controller: subtitle,
          focusNode: _focusNode2,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'subtitle',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dateSelecter(BuildContext context) {
    Future<void> selectDate() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2024),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20), // Add horizontal padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Due Date:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10), // Add spacing between text and date
              Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20), // Add spacing between text and date

              ElevatedButton(
                onPressed: () => selectDate(),
                child: const Text('Change Date'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> updateTodo(
    String _todo, String title, String subtitle, DateTime selectedDate) async {
  print(_todo);
  var todo = ParseObject('Todo')
    ..objectId = _todo
    ..set('title', title)
    ..set('subtitle', subtitle)
    ..set('selectedDate', selectedDate)
    ..set('done', false);
  await todo.save();
}

Future<List<ParseObject>> getTodoByID(_todo) async {
  QueryBuilder<ParseObject> queryTodo =
      QueryBuilder<ParseObject>(ParseObject('Todo'));

  if (_todo != null) {
    // If ID is provided, query for a specific todo item
    queryTodo.whereEqualTo('objectId', _todo);
  }

  final ParseResponse apiResponse = await queryTodo.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}