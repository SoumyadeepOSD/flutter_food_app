import 'package:flutter/material.dart';
import 'package:foodapp/Frontend/constant/color.dart';

class FinalPage extends StatelessWidget {
  const FinalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Page'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: blue,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
