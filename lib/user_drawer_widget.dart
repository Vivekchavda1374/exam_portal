import 'package:canvas_2/code_complier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class UserDrawerWidget extends StatefulWidget {
  final String username;
  final String email;

  const UserDrawerWidget({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);

  @override
  State<UserDrawerWidget> createState() => _UserDrawerWidgetState();
}

class _UserDrawerWidgetState extends State<UserDrawerWidget> {
  // Function to sign out the user
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header with username and email
          UserAccountsDrawerHeader(
            accountName: Text(widget.username),
            accountEmail: Text(widget.email),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("images/boy.png"), // Placeholder image
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 245, 181, 51),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Profile'),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.pop(context);// Close the drawer
            },// Navigate to Profile screen
          ),
          ListTile(
            title: const Text('Code Compiler'),
            leading: const Icon(Icons.code),
            onTap: () {
              Navigator.pop(context);// Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CodeCompilerScreen(),
                ),
              );
            }, // Navigate to Code Compiler screen
          ),
          ListTile(
            title: const Text('Grades'),
            leading: const Icon(Icons.school),
            onTap: () {
              Navigator.pop(context);// Close the drawer
            }, // Navigate to Grades screen
          ),
          ListTile(
            title: const Text('Quizzes'),
            leading: const Icon(Icons.quiz),
            onTap: () {
              Navigator.pop(context);// Close the drawer
            }, // Navigate to Quizzes screen
          ),
          ListTile(
            title: const Text('Sign Out'),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.pop(context);// Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            }, // Sign out and navigate to Login page
          ),
        ],
      ),
    );
  }
}
