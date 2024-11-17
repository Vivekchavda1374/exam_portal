import 'package:canvas_2/subject_quizepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canvas_2/admin_drawer_widget.dart'; // Import the AdminDrawer widget

class CreateQuizPage extends StatefulWidget {
  final String username;

  const CreateQuizPage({Key? key, required this.username}) : super(key: key);

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variables for managing the selected subject and quiz title
  String? selectedSubject;
  final TextEditingController quizTitleController = TextEditingController();
  final TextEditingController timeLimitController = TextEditingController();

  // List to manage the questions dynamically
  List<Map<String, String>> questions = [
    {
      "quesntion": "",
      "option 1": "",
      "option 2": "",
      "option 3": "",
      "option 4": "",
      "correct answer": ""
    }
  ];

  // Function to fetch subjects from Firestore
  Future<List<Map<String, dynamic>>> _fetchSubjects() async {
    final subjectsSnapshot = await _firestore.collection('subjects').get();
    return subjectsSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'],
      };
    }).toList();
  }

  // Function to save the quiz to Firestore
  void _addQuiz() async {
    if (selectedSubject == null || quizTitleController.text.isEmpty || timeLimitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please select a subject, enter a quiz title, and set a time limit")));
      return;
    }

    final quizRef = _firestore
        .collection('subjects')
        .doc(selectedSubject)
        .collection('quizes')
        .doc();

    try {
      // Saving the quiz title and time limit
      await quizRef.set({
        "title": quizTitleController.text,
        "timeLimit": int.parse(timeLimitController.text), // Save time limit as number
      });

      // Saving the questions
      for (var question in questions) {
        await quizRef.collection('questions').add(question);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quiz added successfully!")),
      );

      // Navigate to the Admin page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SubjectQuizPage(), // Navigate to Admin page
        ),
      );
    } catch (e) {
      // Show error message in case of an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving quiz: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subjects and Quizzes"),
        backgroundColor: Color.fromARGB(255, 245, 181, 51), // Yellow app bar
      ),
      drawer: AdminDrawer(username: widget.username), // Drawer with the username

      // Yellow panel part
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(  // Dropdown for subjects
              future: _fetchSubjects(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("Error fetching subjects");
                }

                final subjects = snapshot.data ?? [];
                return DropdownButton<String>(
                  value: selectedSubject, // Make sure selectedSubject has a value
                  hint: Text("Select Subject"),
                  items: subjects.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject['id'],
                      child: Text(subject['name']),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedSubject = value; // Update selectedSubject with the value
                    });
                  },
                );
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: quizTitleController,
              decoration: InputDecoration(labelText: "Quiz Title"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: timeLimitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Time Limit (in minutes)"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                question["quesntion"] = value;
                              });
                            },
                            decoration:
                                InputDecoration(labelText: "Question Text"),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                question["option 1"] = value;
                              });
                            },
                            decoration: InputDecoration(labelText: "Option 1"),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                question["option 2"] = value;
                              });
                            },
                            decoration: InputDecoration(labelText: "Option 2"),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                question["option 3"] = value;
                              });
                            },
                            decoration: InputDecoration(labelText: "Option 3"),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                question["option 4"] = value;
                              });
                            },
                            decoration: InputDecoration(labelText: "Option 4"),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                question["correct answer"] = value;
                              });
                            },
                            decoration:
                                InputDecoration(labelText: "Correct Answer"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  questions.add({
                    "quesntion": "",
                    "option 1": "",
                    "option 2": "",
                    "option 3": "",
                    "option 4": "",
                    "correct answer": ""
                  });
                });
              },
              child: Text("Add Another Question"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addQuiz,
              child: Text("Save Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
