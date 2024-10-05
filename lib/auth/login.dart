import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/auth/forgot_password.dart';
import 'package:foodapp/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/generalState.dart';
import '../constant/images.dart';
import 'package:http/http.dart' as http;
import '../constant/color.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
bool isLoading = false;
String token = "";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void setLoading(bool loadingState) {
    setState(() {
      isLoading = loadingState;
    });
  }

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
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

  Future<void> loginUser({context, setLoading}) async {
    try {
      setLoading(true);
      final response = await http.post(
        Uri.parse("https://food-app-backend-chi.vercel.app/api/user/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json', // Added Accept header
        },
        body: jsonEncode(<String, String>{
          "email": _emailController.text.trim(), // Trim any extra spaces
          "password": _passwordController.text.trim(), // Trim any extra spaces
        }),
      );
      setLoading(false);

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        Fluttertoast.showToast(msg: 'Successfully Login');
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
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Wrong email and password');
        _emailController.clear();
        _passwordController.clear();
      } else {
        Fluttertoast.showToast(msg: 'Failed to login. Please try again.');
        print('Failed to Login: ${response.statusCode} ${response.body}');
        _emailController.clear();
        _passwordController.clear();
      }
    } catch (e) {
      setLoading(false);
      Fluttertoast.showToast(msg: 'An error occurred: ${e.toString()}');
      print('An error occurred: ${e.toString()}');
      _emailController.clear();
      _passwordController.clear();
    }
  }

  // *Send OTP

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Consumer<GeneralStateProvider>(
        builder: (context, value, child) => SafeArea(
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
                    "Sign-In",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 50),
                  ),
                  Text(
                    'Token: $token',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 10),
                  ),
                  const Image(
                    height: 300,
                    width: 300,
                    image: AssetImage(signupImage),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
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
                        customTextField(
                          controller: _passwordController,
                          hintText: "Enter Password",
                          validator: (value) {
                            if (value!.isEmpty) {
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: yellow),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );
                                loginUser(
                                    context: context, setLoading: setLoading);
                              }
                            },
                            child: Text(
                              "Login",
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
                        "Don't have an account?",
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
                              builder: (context) => const Signup(),
                            ),
                          );
                        },
                        child: Text(
                          "Signup",
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
      ),
    );
  }
}
