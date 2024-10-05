import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/auth/login.dart';
import 'package:foodapp/auth/signup.dart';
import 'package:http/http.dart' as http;
import '../constant/color.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.email});
  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isLoading = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void setLoading(bool loadingState) {
    setState(() {
      isLoading = loadingState;
    });
  }

  Future<void> resetPassword({context}) async {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Password fields cannot be empty",
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: "Passwords do not match",
      );
      return;
    }

    setLoading(true);
    try {
      final response = await http.post(
        Uri.parse(
          "https://food-app-backend-jgni.onrender.com/api/user/resetpassword",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            "email": widget.email,
            "password": _passwordController.text,
          },
        ),
      );

      if (response.statusCode == 404) {
        Fluttertoast.showToast(
          msg: "User not found",
        );
      } else if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: data['message'],
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print(e);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  customTextField(
                    controller: _passwordController,
                    hintText: "Enter Your New Password",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  customTextField(
                    controller: _confirmPasswordController,
                    hintText: "Enter Your Confirm Password",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your confirm password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellow,
                            side: BorderSide(
                              color: black,
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                              resetPassword(context: context);
                            }
                          },
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
