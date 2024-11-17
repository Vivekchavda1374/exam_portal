import 'package:canvas_2/login_page.dart';
//core Firebase functionality needed to initialize Firebase in the app.
import 'package:firebase_core/firebase_core.dart';
// Material Design library,provides 
//a comprehensive set of widgets and tools to create visually appealing apps.
import 'package:flutter/material.dart';
//It contains configuration details (like API keys and project IDs) 
//specific to your Firebase project.
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // This line will wait until Firebase is initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),  // After login, navigate to the CodeCompilerScreen
    );
  }
}
