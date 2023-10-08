import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> users = [];
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse("http://192.168.0.102:8000/users"));
    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> fetchedUsers = json.decode(response.body);
      setState(() {
        users = fetchedUsers;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(users);
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          // Customize how you want to display each user
          return ListTile(
            title: Text(users[index]['mobile']),
            // Add more user information as needed
          );
        },
      ),
    );
  }
}
