import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/generalState.dart';
import 'package:http/http.dart' as http;

const _storage = FlutterSecureStorage();
String mobile = '';
String token = "";
ProfileData? userData;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getToken().then((_) {
      fetchUserInfo(); // Fetch user info after getting the token
    });
    _storage.read(key: 'mobile').then((value) {
      setState(() {
        mobile = value.toString();
      });
    });
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? 'No token found';
    });
  }

  void fetchUserInfo() async {
    // Prepare the request body with the token
    Map<String, dynamic> requestBody = {"token": token};

    try {
      // Make the POST request to the API
      final response = await http.post(
        Uri.parse("https://food-app-backend-chi.vercel.app/api/user/profile"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody), // Properly encode the request body
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final userProfile = jsonResponse['data'];

        // Check if userProfile contains valid data
        if (userProfile != null) {
          ProfileData profile = ProfileData.fromJson(userProfile);
          setState(() {
            userData = profile; // Update the userData
          });
        } else {
          print('No user data found');
        }
      } else {
        print('Failed to fetch user data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profile"),
      ),
      body: Consumer<GeneralStateProvider>(builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Account",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20.0),
              Skeletonizer(
                enabled: userData == null,
                child: Text(
                  userData == null ? "" : userData!.email,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
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
                        const Text(
                          "Wallet",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton.outlined(
                          onPressed: () {},
                          icon: const Icon(Icons.chat),
                        ),
                        const Text(
                          "Support",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton.outlined(
                          onPressed: () {},
                          icon: const Icon(Icons.payments_sharp),
                        ),
                        const Text(
                          "Payment",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "YOUR INFORMATION",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: Colors.grey[200],
                  onPressed: () {},
                  icon: const Icon(Icons.trolley, color: Colors.grey),
                ),
                title: const Text(
                  "Your orders",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_outlined,
                    color: Colors.grey, size: 18),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: Colors.grey[200],
                  onPressed: () {},
                  icon: const Icon(Icons.location_on_sharp, color: Colors.grey),
                ),
                title: const Text(
                  "Address",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_outlined,
                    color: Colors.grey, size: 18),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "OTHER INFORMATION",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: Colors.grey[200],
                  onPressed: () {},
                  icon: const Icon(Icons.share, color: Colors.grey),
                ),
                title: const Text(
                  "Share",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_outlined,
                    color: Colors.grey, size: 18),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: Colors.grey[200],
                  onPressed: () {},
                  icon: const Icon(Icons.info, color: Colors.grey),
                ),
                title: const Text(
                  "About us",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_outlined,
                    color: Colors.grey, size: 18),
              ),
              ListTile(
                leading: IconButton.outlined(
                  color: Colors.grey[200],
                  onPressed: () {},
                  icon: const Icon(Icons.star_border, color: Colors.grey),
                ),
                title: const Text(
                  "Rate us",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_outlined,
                    color: Colors.grey, size: 18),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ProfileData {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String email;
  final bool isAdmin;
  final String profileImage;

  ProfileData({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.isAdmin,
    required this.profileImage,
  });

  // Factory method to create a ProfileData instance from JSON
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['_id'],
      fullName: json['fullName'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      isAdmin: json['isAdmin'],
      profileImage: json['profileImage'],
    );
  }

  // Optional: Convert ProfileData instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'email': email,
      'isAdmin': isAdmin,
      'profileImage': profileImage,
    };
  }
}
