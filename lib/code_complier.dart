
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CodeCompilerScreen extends StatefulWidget {
  @override
  _CodeCompilerScreenState createState() => _CodeCompilerScreenState();
}

class _CodeCompilerScreenState extends State<CodeCompilerScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  String _output = '';
  String _selectedLanguage = 'Cpp';
  

  Future<void> _compileCode() async {
    var url = Uri.parse('http://10.80.5.148:8000/compile');
    var response;

    try {
      Map<String, dynamic> requestData = {
        'code': _codeController.text,
        'input': _inputController.text,
        'lang': _selectedLanguage,
      };

      response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _output = data['output'] ?? 'Error compiling code';
        });
      } else {
        setState(() {
          _output = 'Failed to compile code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _output = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Code Compiler"),
        backgroundColor: Color.fromARGB(255, 245, 181, 51),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Text(
                      "Welcome to Code Compiler!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    DropdownButton<String>(
                      value: _selectedLanguage,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                      items: <String>['Cpp', 'Java', 'Python']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _codeController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: 'Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _inputController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Input (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _compileCode,
                      child: Text('Compile'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Output:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _output,
                      style: TextStyle(color: Colors.black87),
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
