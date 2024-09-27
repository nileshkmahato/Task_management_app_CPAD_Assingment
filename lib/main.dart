import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_management_app/screens/Auth/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String appId = 'v7zpkflR9x2sPpTUv9Tdmpc0vPFTRXndQUhs7okd';
  const String clientKey = 'hqyr3sb2l3RqI02lQbXlKUXJ4wm1ytEXaSX7bLZP';
  const parseServerUrl = 'https://parseapi.back4app.com';

  // The corrected initialize method call with positional arguments
  await Parse().initialize(
    appId,
    parseServerUrl, 
    clientKey: clientKey, // Server URL as a positional argument, not named
    autoSendSessionId: true, // Named argument for session handling
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const LoginPage(),
    );
  }
}
