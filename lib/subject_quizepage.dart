import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canvas_2/admin_drawer_widget.dart'; // Import your reusable AdminDrawer widget

class SubjectQuizPage extends StatefulWidget {
  @override
  _SubjectQuizPageState createState() => _SubjectQuizPageState();
}

class _SubjectQuizPageState extends State<SubjectQuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String username = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            username = userDoc.data()?['username'] ?? "Unknown User";
          });
        } else {
          setState(() {
            username = "User Not Found";
          });
        }
      }
    } catch (e) {
      print("Error fetching username: $e");
      setState(() {
        username = "Error";
      });
    }
  }

  // Fetch subjects from Firestore
  Future<List<Map<String, dynamic>>> _fetchSubjects() async {
    final subjectsSnapshot = await _firestore.collection('subjects').get();
    return subjectsSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'],
        'quizzes': [],
      };
    }).toList();
  }

  // Fetch quizzes for a specific subject
  Future<List<Map<String, dynamic>>> _fetchQuizzes(String subjectId) async {
    final quizzesSnapshot = await _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('quizes')
        .get();
    return quizzesSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'title': doc['title'],
        'questions': [],
      };
    }).toList();
  }

  // Fetch questions for a specific quiz
  Future<List<Map<String, dynamic>>> _fetchQuestions(
      String subjectId, String quizId) async {
    final questionsSnapshot = await _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('quizes')
        .doc(quizId)
        .collection('questions')
        .get();
    return questionsSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'question': doc['quesntion'],
        'options': [
          doc['option 1'],
          doc['option 2'],
          doc['option 3'],
          doc['option 4']
        ],
        'correctAnswer': doc['correct answer'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subjects and Quizzes"),
        backgroundColor: Color.fromARGB(255, 245, 181, 51), // Yellow app bar
      ),
      drawer: AdminDrawer(username: username), // Reusable Admin Drawer
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching data."));
          }

          final subjects = snapshot.data!;
          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return ExpansionTile(
                title: Text(
                  subject['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchQuizzes(subject['id']),
                    builder: (context, quizSnapshot) {
                      if (quizSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (quizSnapshot.hasError) {
                        return Text("Error fetching quizzes.");
                      }

                      final quizzes = quizSnapshot.data!;
                      return Column(
                        children: quizzes.map((quiz) {
                          return ExpansionTile(
                            title: Text(quiz['title']),
                            children: [
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: _fetchQuestions(
                                    subject['id'], quiz['id']),
                                builder: (context, questionSnapshot) {
                                  if (questionSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  if (questionSnapshot.hasError) {
                                    return Text("Error fetching questions.");
                                  }

                                  final questions = questionSnapshot.data!;
                                  return Column(
                                    children: questions.map((question) {
                                      return ListTile(
                                        title: Text(question['question']),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              question['options'].length,
                                              (i) => Text(
                                                  "Option ${i + 1}: ${question['options'][i]}")),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
