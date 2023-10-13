import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/Frontend/home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/color.dart';
import '../constant/images.dart';
import 'signup.dart';

final List<String> countryCodeList = ["+91", "+89", "+03", "+09"];
String selectedCode = "+91";

TextEditingController _mobileController = TextEditingController();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
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
                  "Sign-In",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 50),
                ),
                const Image(
                  height: 300,
                  width: 300,
                  image: AssetImage(signupImage),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      DropdownButton<String>(
                        value: selectedCode,
                        onChanged: (value) {
                          setState(() {
                            value = selectedCode;
                          });
                        },
                        items: countryCodeList.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: _mobileController,
                          decoration: const InputDecoration(
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            hintText: "Enter your mobile number",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: yellow),
                    onPressed: () {
                      loginUser(context: context);
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
    );
  }
}

Future<void> loginUser({context}) async {
  final response = await http.post(
    Uri.parse("http://192.168.0.102:8000/login"),
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
      msg: "Successfully logged in✅",
    );
    Future.delayed(const Duration(seconds: 1), () {
      const CircularProgressIndicator();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  } else {
    Fluttertoast.showToast(
      msg: "Failed to login",
    );
  }
}
