import 'package:canvas_2/admin_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import the AdminDrawer widget

class AddSubjectPage extends StatefulWidget {
  final String username;

  const AddSubjectPage({Key? key, required this.username}) : super(key: key);

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final TextEditingController _subjectController = TextEditingController();

  Future<void> _addSubject() async {
    final subjectName = _subjectController.text.trim();

    if (subjectName.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('subjects').add({
          'name': subjectName,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subject "$subjectName" added successfully!')),
        );
        _subjectController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding subject: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a subject name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Subject'),
        backgroundColor: Color.fromARGB(255, 245, 181, 51),
      ),
      drawer: AdminDrawer(username: widget.username), // Reuse the drawer
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Subject Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., Flutter Development',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addSubject,
              child: Text('Add Subject'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 245, 181,
                    51), // Use backgroundColor instead of primary
              ),
            ),
          ],
        ),
      ),
    );
  }
}
