import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_management_app/screens/Task_board/task_dashboard.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  color: Colors.blueAccent,
                  size: 100,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                    controller: _usernameController, label: 'Username'),
                const SizedBox(height: 12),
                _buildTextField(
                    controller: _emailController, label: 'Email'),
                const SizedBox(height: 12),
                _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true),
                const SizedBox(height: 16),
                _buildRegisterButton(),
                const SizedBox(height: 20),
                _buildLoginText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _doRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Register', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Login',
              style: TextStyle(color: Colors.blueAccent)),
        ),
      ],
    );
  }

  Future<void> _doRegister() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    final user = ParseUser(username, password, email);
    var response = await user.signUp();

    setState(() {
      _isLoading = false;
    });

    if (response.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskDashboard()),
      );
    } else {
      _showError(response.error!.message);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Registration Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
