import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

TextEditingController _mobileController = TextEditingController();

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const Text("Signup"),
              TextField(
                keyboardType: TextInputType.phone,
                controller: _mobileController,
                decoration: const InputDecoration(
                  hintText: "Enter your mobile number",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  registerUser();
                },
                child: const Text("Create"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> registerUser() async {
  final response = await http.post(
    Uri.parse("http://192.168.0.102:8000/register"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'mobile': _mobileController.text.toString(),
    }),
  );
  if (response.statusCode == 200) {
    final dynamic data = jsonDecode(response.body);
    print('Successfully registered $data');
    Fluttertoast.showToast(
      msg: "Successfully Registered✅",
    );
  } else {
    Fluttertoast.showToast(
      msg: "Y",
    );
  }
}
