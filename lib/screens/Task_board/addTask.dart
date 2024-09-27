import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Due Date: '),
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? 'Select a date'
                        : _dueDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _dueDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty || _dueDate == null) {
      _showError('Please fill in all fields');
      return;
    }

    final task = ParseObject('Task')
      ..set('title', _titleController.text)
      ..set('dueDate', _dueDate)
      ..set('done', false);
    await task.save();

    Navigator.of(context).pop();
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
