import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/auth/otp_page.dart';
import 'package:foodapp/auth/signup.dart';
import 'package:http/http.dart' as http;

import '../constant/color.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void setLoading(bool loadingState) {
    setState(() {
      isLoading = loadingState;
    });
  }

  Future<void> sendOTP({context}) async {
    setLoading(true);
    try {
      final response = await http.post(
        Uri.parse(
          "https://food-app-backend-jgni.onrender.com/api/user/forgotpassword",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            "email": _emailController.text.toString(),
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
            builder: (context) => OtpPage(
              email: _emailController.text.toString(),
            ),
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Form(
              key: _formKey, // Correctly assign the formKey here
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  Text(
                    "OTP will be sent to mobile number associated with this email",
                    style: TextStyle(
                      color: blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  customTextField(
                    controller: _emailController,
                    hintText: "Enter Your email",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email address";
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
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                              sendOTP(context: context);
                            }
                          },
                          child: Text(
                            "Send OTP",
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
