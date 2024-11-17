import 'resuable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _phoneError;
  String? _passwordError;
  String? _emailError;
  String? _confirmPasswordError;

  // Validation methods
  String? _validatePhone(String value) {
    if (value.length != 10) {
      return "Phone number must be 10 digits";
    }
    return null;
  }

  String? _validatePassword(String value) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return "Password must be at least 8 characters, with uppercase, lowercase, and number.";
    }
    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value != _passwordController.text) {
      return "Passwords do not match.";
    }
    return null;
  }

  Future<void> _signup() async {
    setState(() {
      _phoneError = _validatePhone(_phoneController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError = _validateConfirmPassword(_confirmPasswordController.text);
    });

    if (_phoneError != null || _passwordError != null || _confirmPasswordError != null) {
      return;
    }

    try {
      await AuthService().signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
        _phoneController.text.trim(),
        _addressController.text.trim(),
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _emailError = 'This email is already in use.';
        });
      } else {
        print('Signup failed: ${e.message}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 229, 248),
      body: Column(
        children: [
          // Top panel
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 245, 181, 51),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        "images/book.png",
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      "MY exam Portal",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        "images/boy.png",
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                  children: <Widget>[
                    logoWidget("images/logo1.png"),
                    const SizedBox(height: 30),
                    reusableTextField("Enter Email", Icons.email_outlined, false, _emailController,
                        errorText: _emailError),
                    const SizedBox(height: 20),
                    reusableTextField("Enter Username", Icons.person_outline, false, _usernameController),
                    const SizedBox(height: 20),
                    reusableTextField("Enter Password", Icons.lock_outline, true, _passwordController,
                        errorText: _passwordError),
                    const SizedBox(height: 20),
                    reusableTextField("Confirm Password", Icons.lock_outline, true, _confirmPasswordController,
                        errorText: _confirmPasswordError),
                    const SizedBox(height: 20),
                    reusableTextField("Enter Address", Icons.location_on_outlined, false, _addressController),
                    const SizedBox(height: 20),
                    reusableTextField("Enter Phone Number", Icons.phone_outlined, false, _phoneController,
                        errorText: _phoneError),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 83, 109, 254),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?",
                            style: TextStyle(color: Color.fromARGB(179, 10, 10, 10))),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>  LoginPage()));
                          },
                          child: const Text(
                            " Login",
                            style: TextStyle(
                              color: Color.fromARGB(255, 9, 9, 9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
