import 'package:flutter/material.dart';
import 'forgotpass.dart'; // Import the ForgotPassword page
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import dart:convert to use jsonDecode
import 'homescreen.dart';  // Import the HomeScreen

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Flag for showing/hiding password
  String? _emailError;  // For email validation error message
  String? _passwordError; // For password validation error message
  List<dynamic> userData = []; // Declare userData for storing users fetched from API

  // Email validation regex
  final RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  // Function to validate and proceed with login
  Future<void> _login() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      setState(() {
        userData = jsonDecode(response.body);
      });
      print('Fetched User Data: $userData');  // Debugging: Print fetched data
    } else {
      // If the server returns an error, handle it
      throw Exception('Failed to load data');
    }

    // Validate email and password
    setState(() {
      _emailError = _validateEmail(emailController.text);
      _passwordError = _validatePassword(passwordController.text);
    });

    // If both fields are valid, check if the credentials match and navigate
    if (_emailError == null && _passwordError == null) {
      String email = emailController.text;
      // String password = passwordController.text;

      // Check if the email and password exist in the user data
      bool isValidUser = userData.any((user) =>
      user['email'] == email);

      if (isValidUser) {
        _showLoadingDialog();
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(userData: userData)),
          );
        });
      } else {
        setState(() {
          _passwordError = 'Invalid email or password';
        });
      }
    }
  }

  // Function to show the loading dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),  // The loading spinner
        );
      },
    );
  }

  // Email validation function
  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email';
    } else if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation function
  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login.png'),  // Ensure the image path is correct
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Makes Scaffold background transparent
        body: Stack(
          children: [
            Positioned(
              left: 35,
              top: 130,
              child: Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    right: 35,
                    left: 35),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To avoid unnecessary space
                  children: [
                    // Email TextField
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _emailError == null ? Colors.black : Colors.red,
                          ),
                        ),
                        errorText: _emailError, // Display error message if any
                      ),
                    ),
                    SizedBox(height: 20), // Space between fields
                    // Password TextField
                    TextField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,  // Toggle password visibility
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _passwordError == null ? Colors.black : Colors.red,
                          ),
                        ),
                        errorText: _passwordError, // Display error message if any
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w700),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xff4c505b),
                          child: IconButton(
                            onPressed:_login, // Call login function when pressed
                            icon: Icon(Icons.arrow_forward),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Add the "Forgot Password?" link here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Navigate to ForgotPassword page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
