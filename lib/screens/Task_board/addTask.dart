import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_management_app/screens/Task_board/task_dashboard.dart';

class Add_creen extends StatefulWidget {
  const Add_creen({super.key});

  @override
  State<Add_creen> createState() => _Add_creenState();
}

class _Add_creenState extends State<Add_creen> {
  final title = TextEditingController();
  final subtitle = TextEditingController();
  final todoController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  int indexx = 0;
  DateTime selectedDate = DateTime.now();

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
            if (title.text.isNotEmpty) {
              // Check if the title text field is not empty
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Task created"),
                duration: Duration(seconds: 3),
              ));
              await saveTodo(title.text, subtitle.text,
                  selectedDate); // Call saveTodo with text values
              setState(() {
                title.clear(); // Clear both text fields after saving todo
                subtitle.clear();
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Title Cannot be Empty"),
                duration: Duration(seconds: 5),
              ));
            }
          },
          child: const Text(
            'Add Task',
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
                child: const Text('Select Date'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> saveTodo(
    String title, String subtitle, DateTime selectedDate) async {
  print("in save");
  final todo = ParseObject('Todo')
    ..set('title', title)
    ..set('subtitle', subtitle)
    ..set('selectedDate', selectedDate)
    ..set('done', false);
  await todo.save();
}