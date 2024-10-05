import 'package:flutter/material.dart';
import 'package:foodapp/constant/tabs.dart'; // Ensure this imports the correct icons
import 'package:foodapp/utils/removeToken.dart';
import '../auth/login.dart';
import '../constant/color.dart';
import '../home.dart';

Widget drawerComponent(context, _scaffoldKey) {
  return Drawer(
    child: Column(
      children: [
        const SizedBox(
          height: 100.0,
        ),
        SizedBox(
          height: tabsList.length * 90,
          child: ListView.builder(
            itemCount: tabsList.length,
            itemBuilder: (context, index) {
              final item = tabsList[index];
              return ListTile(
                leading: Icon(item['icon'], size: 30.0), // Icon on the left
                title: Text(
                  item['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Navigate using named routes
                  if (item['path'] == "/logout") {
                    _showLogoutDialog(context);
                  } else {
                    Navigator.of(context).pushNamed(item['path']);
                    // Close the drawer after navigation
                    _scaffoldKey.currentState!.openEndDrawer();
                  }
                },
              );
            },
          ),
        ),
        Text(
          "V 1.0.0",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Container(
          height: 100,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Text(
                "Logout",
                style: TextStyle(color: black, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      removeToken();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                          (route) => false);
                    },
                    child: const Text(
                      "Sure",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
