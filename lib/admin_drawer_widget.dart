import 'package:canvas_2/add_subject_page.dart';
import 'package:canvas_2/admin_page.dart';
import 'package:canvas_2/create_quize_page.dart';
import 'package:canvas_2/subject_quizepage.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class AdminDrawer extends StatelessWidget {
  final String username;

  const AdminDrawer({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username), // Displaying the username here
            accountEmail: Text("admin@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("images/boy.png"),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 245, 181, 51),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);// Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminPage()), // Navigate to AdminPage
              ); // Replace with your route
            },
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('Add Subject'),
            onTap: () {
              Navigator.pop(context);// Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSubjectPage(username: username),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.quiz),
            title: Text('Quiz'),
            onTap: () {
              Navigator.pop(context);// Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SubjectQuizPage()), // Navigate to AdminPage
              ); // Replace with your route
            },
          ),
          ListTile(
            leading: Icon(Icons.create),
            title: Text('Create Quiz'),
            onTap: () {
              Navigator.pop(context);// Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateQuizPage(username: username)), // Navigate to AdminPage
              ); // Replace with your route
            },
          ),
          ListTile(
            leading: Icon(Icons.settings), // New Settings field
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(
                  context, '/settings'); // Replace with your route
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
