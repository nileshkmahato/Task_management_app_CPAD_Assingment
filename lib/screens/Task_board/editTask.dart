import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_management_app/screens/Task_board/task_dashboard.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  const EditTaskScreen(this.taskId, {super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController? _titleController;
  TextEditingController? _subtitleController;
  TextEditingController? _objectIdController;
  DateTime selectedDate = DateTime.now();

  final FocusNode _focusTitle = FocusNode();
  final FocusNode _focusSubtitle = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadTask(widget.taskId).then((List<ParseObject> taskList) {
      if (taskList.isNotEmpty) {
        final ParseObject task = taskList.first;
        setState(() {
          _objectIdController =
              TextEditingController(text: task.get<String>('objectId'));
          _titleController =
              TextEditingController(text: task.get<String>('title'));
          _subtitleController =
              TextEditingController(text: task.get<String>('subtitle'));
          selectedDate = task.get<DateTime>('selectedDate')!;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task not found!")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitleField(),
              const SizedBox(height: 20),
              _buildSubtitleField(),
              const SizedBox(height: 20),
              _buildDateSelector(context),
              const SizedBox(height: 40),
              _buildActionButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      focusNode: _focusTitle,
      style: const TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Task Title',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }

  Widget _buildSubtitleField() {
    return TextField(
      controller: _subtitleController,
      focusNode: _focusSubtitle,
      maxLines: 3,
      style: const TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Task Description',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    Future<void> selectDate() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }

    return Row(
      children: [
        const Text(
          'Due Date:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 10),
        Text(
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => selectDate(),
          child: const Text('Change Date'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(170, 48),
          ),
          onPressed: () async {
            if (_titleController != null && _titleController!.text.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Task updated successfully!"),
                duration: Duration(seconds: 3),
              ));
              await _updateTask(
                _objectIdController!.text,
                _titleController!.text,
                _subtitleController!.text,
                selectedDate,
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TaskDashboard()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Title cannot be empty!"),
                duration: Duration(seconds: 5),
              ));
            }
          },
          child: const Text(
            'Update Task',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(170, 48),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TaskDashboard()),
            );
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _updateTask(
      String taskId, String title, String subtitle, DateTime selectedDate) async {
    var task = ParseObject('Todo')
      ..objectId = taskId
      ..set('title', title)
      ..set('subtitle', subtitle)
      ..set('selectedDate', selectedDate)
      ..set('done', false);
    await task.save();
  }

  Future<List<ParseObject>> _loadTask(String taskId) async {
    QueryBuilder<ParseObject> query = QueryBuilder(ParseObject('Todo'))
      ..whereEqualTo('objectId', taskId);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}
