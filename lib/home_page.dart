import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user_drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "Loading..."; // Default text until we fetch the username
  String email = "Loading..."; // Default email text

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data on page load
  }

  // Fetching username and email from Firestore
  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final uid = user.uid;
        print("Logged in user UID: $uid");

        // Fetch the user's data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        // Check if the document exists and update the username and email
        if (userDoc.exists) {
          setState(() {
            username = userDoc.data()?['username'] ?? "Unknown User";
            email = userDoc.data()?['email'] ?? "No email found";
          });
        } else {
          setState(() {
            username = "User Not Found";
            email = "No email found";
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        username = "Error";
        email = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 229, 248),
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: const Color.fromARGB(255, 245, 181, 51),
      ),
      drawer: UserDrawerWidget(
        username: username,
        email: email,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: const <Widget>[
                    SizedBox(height: 30),
                    Text(
                      "Welcome to Home Page!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
