import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/auth/reset_password.dart';
import 'package:foodapp/constant/color.dart';
import 'package:http/http.dart' as http;

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.email});
  final String email;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String? p_1, p_2, p_3, p_4, p_5, p_6;

  void setLoading(bool loadingState) {
    setState(() {
      isLoading = loadingState;
    });
  }

  Future<void> verifyOTP({context}) async {
    formKey.currentState?.save(); // Save the form to populate the variables
    if (p_1 == null ||
        p_2 == null ||
        p_3 == null ||
        p_4 == null ||
        p_5 == null ||
        p_6 == null) {
      Fluttertoast.showToast(
        msg: "Please enter the complete OTP",
      );
      return;
    }
    try {
      setLoading(true);
      final response = await http.post(
        Uri.parse(
          "https://food-app-backend-jgni.onrender.com/api/user/verifyotp",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            "email": widget.email,
            "otp": "$p_1$p_2$p_3$p_4$p_5$p_6",
          },
        ),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: data['message'],
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPassword(
              email: widget.email,
            ),
          ),
        );
      } else {
        final dynamic data = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: data['message'],
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

  Widget otpTextField(Function(String?) onSaved) {
    return SizedBox(
      height: 28,
      width: 28,
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        onSaved: onSaved,
        style: Theme.of(context).textTheme.headlineMedium,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 200.0,
            ),
            Text(
              "Enter OTP",
              style: TextStyle(
                color: black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 80.0,
            ),
            Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  otpTextField((p1) => p_1 = p1),
                  otpTextField((p2) => p_2 = p2),
                  otpTextField((p3) => p_3 = p3),
                  otpTextField((p4) => p_4 = p4),
                  otpTextField((p5) => p_5 = p5),
                  otpTextField((p6) => p_6 = p6),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
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
                          const SnackBar(content: Text('Processing Data')),
                        );
                        // verifyOTP(context: context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPassword(
                              email: widget.email,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Verify OTP",
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
    );
  }
}
