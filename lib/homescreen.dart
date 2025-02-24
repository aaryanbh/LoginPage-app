import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class HomePage extends StatefulWidget {
  final List<dynamic> userData;

  HomePage({required this.userData});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> userData = [];

  @override
  void initState() {
    super.initState();
    userData = widget.userData; // Pass the fetched user data from LoginPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: userData.isEmpty
            ? CircularProgressIndicator()  // Show loading indicator while fetching data
            : ListView.builder(
          itemCount: userData.length,
          itemBuilder: (context, index) {
            var user = userData[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.w3schools.com/w3images/avatar2.png'), // Placeholder image
              ),
              title: Text(user['name']),
              subtitle: Text(user['email']),
            );
          },
        ),
      ),
    );
  }
}
