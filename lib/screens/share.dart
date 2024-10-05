import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/widgets/custom_button.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade200,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                "hello",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 100,
              ),
              customButton()
            ],
          ),
        ),
      ),
    );
  }
}
