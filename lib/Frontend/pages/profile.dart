import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodapp/Frontend/constant/color.dart';
import 'package:provider/provider.dart';
import '../state/generalState.dart';

final _storage = const FlutterSecureStorage();

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Consumer<generalStateProvider>(builder: (context, value, child) {
          print(value.thisnumber.toString());
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: lightGrey,
            child: Column(
              children: [
                Text(
                  value.thisnumber.toString(),
                  style: TextStyle(fontSize: 56, color: Colors.red),
                ),
                Text("herlo"),
              ],
            ),
          );
        }),
      ),
    );
  }
}
