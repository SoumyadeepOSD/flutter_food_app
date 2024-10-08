import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/auth/login.dart';
import 'package:foodapp/constant/color.dart';
import 'package:foodapp/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constant/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<String> countryCodeList = ["+91", "+89", "+03", "+09"];
String selectedCode = "+91";
bool isLoading = false;
String token = "";

TextEditingController _fullNameController = TextEditingController();
TextEditingController _mobileNumberController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  void setLoading(bool loadingState) {
    setState(() {
      isLoading = loadingState;
    });
  }

  Future<bool> setToken(String tokenKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString("token", tokenKey);
    if (result) {
      print("Token $tokenKey saved");
      return true;
    } else {
      print("Failed to save token");
      return false;
    }
  }

  Future<void> registerUser({context, setLoading}) async {
    try {
      setLoading(true);
      final response = await http.post(
        Uri.parse("https://food-app-backend-jgni.onrender.com/api/user/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "fullName": _fullNameController.text.toString(),
          "mobileNumber": _mobileNumberController.text.toString(),
          "email": _emailController.text.toString(),
          "password": _passwordController.text.toString()
        }),
      );

      setLoading(false);

      if (response.statusCode == 201) {
        final dynamic data = jsonDecode(response.body);
        Fluttertoast.showToast(msg: 'Successfully registered');
        bool result = await setToken(data['token']);
        if (result) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: 'Failed to save token');
        }
      } else {
        // Handle different status codes and show relevant message
        Fluttertoast.showToast(msg: 'Failed to register. Please try again.');
        print('Failed to register: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      setLoading(false);
      Fluttertoast.showToast(msg: 'An error occurred: ${e.toString()}');
      print('An error occurred: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Sign-up",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 50),
                ),
                const Image(
                  height: 200,
                  width: 200,
                  image: AssetImage(signupImage),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // *Full Name
                      customTextField(
                        controller: _fullNameController,
                        hintText: "Your Full Name",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your full name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // *Mobile Number
                      customTextField(
                        controller: _mobileNumberController,
                        hintText: "Your Mobile Number",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your mobile number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // *Email Address
                      customTextField(
                        controller: _emailController,
                        hintText: "Your Email Address",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // *Password
                      customTextField(
                        controller: _passwordController,
                        hintText: "Enter Password",
                        validator: (value) {
                          if (value!.isEmpty || value!.length < 6) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: deepYellow),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                              registerUser(
                                  context: context, setLoading: setLoading);
                            }
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: darkGrey,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blue,
                          fontSize: 16,
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
    );
  }
}

Widget customTextField({
  required String hintText,
  required TextEditingController controller,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: lightGrey),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: black),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    validator: validator,
    controller: controller,
  );
}
