import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodapp/Frontend/constant/color.dart';
import 'package:provider/provider.dart';
import '../state/generalState.dart';

final _storage = const FlutterSecureStorage();
String mobile = '';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    _storage.read(key: 'mobile').then((value) {
      setState(() {
        mobile = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        title: const Text("Profile"),
      ),
      body: Consumer<generalStateProvider>(builder: (context, value, child) {
        print(value.thisnumber.toString());
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Account",
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                mobile,
                style: TextStyle(fontSize: 18, color: black),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
                height: 100,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton.outlined(
                          onPressed: () {},
                          icon: const Icon(Icons.account_balance_wallet),
                        ),
                        Text(
                          "Wallet",
                          style: TextStyle(fontSize: 14, color: black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton.outlined(
                          onPressed: () {},
                          icon: const Icon(Icons.chat),
                        ),
                        Text(
                          "Support",
                          style: TextStyle(fontSize: 14, color: black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton.outlined(
                          onPressed: () {},
                          icon: const Icon(Icons.payments_sharp),
                        ),
                        Text(
                          "Payment",
                          style: TextStyle(fontSize: 14, color: black),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                "YOUR INFORMATION",
                style: TextStyle(fontSize: 16, color: darkGrey),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: verylightgrey,
                  onPressed: () {},
                  icon: Icon(Icons.trolley, color: darkGrey),
                ),
                title: Text(
                  "Your orders",
                  style: TextStyle(fontSize: 16, color: black),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: darkGrey, size: 18),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: verylightgrey,
                  onPressed: () {},
                  icon: Icon(Icons.location_on_sharp, color: darkGrey),
                ),
                title: Text(
                  "Address",
                  style: TextStyle(fontSize: 16, color: black),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: darkGrey, size: 18),
              ),
              const SizedBox(height: 20.0),
              Text(
                "OTHER INFORMATION",
                style: TextStyle(fontSize: 16, color: darkGrey),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: verylightgrey,
                  onPressed: () {},
                  icon: Icon(Icons.share, color: darkGrey),
                ),
                title: Text(
                  "Share",
                  style: TextStyle(fontSize: 16, color: black),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: darkGrey, size: 18),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: verylightgrey,
                  onPressed: () {},
                  icon: Icon(Icons.info, color: darkGrey),
                ),
                title: Text(
                  "About us",
                  style: TextStyle(fontSize: 16, color: black),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: darkGrey, size: 18),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: verylightgrey,
                  onPressed: () {},
                  icon: Icon(Icons.star_border, color: darkGrey),
                ),
                title: Text(
                  "Rate us",
                  style: TextStyle(fontSize: 16, color: black),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: darkGrey, size: 18),
              ),
            ],
          ),
        );
      }),
    );
  }
}
