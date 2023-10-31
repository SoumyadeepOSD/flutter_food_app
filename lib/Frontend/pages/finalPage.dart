import 'package:flutter/material.dart';
import 'package:foodapp/Frontend/constant/color.dart';

class FinalPage extends StatelessWidget {
  const FinalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            ),
          ),
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
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
