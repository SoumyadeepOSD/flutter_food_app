import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodapp/pages/prefinal.dart';
import '../constant/color.dart';
import '../utils/user_simple_preferences.dart';

TextEditingController _firstNameController = TextEditingController();
TextEditingController _lastNameController = TextEditingController();
TextEditingController _addressController = TextEditingController();
TextEditingController _mobileController = TextEditingController();
TextEditingController _pinController = TextEditingController();

const _storage = FlutterSecureStorage();
String _mobile = '';
String _address = '';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  void setPhoneNumber() {
    _storage.read(key: 'mobile').then((value) {
      setState(() {
        _mobile = value.toString();
        _mobileController.text = _mobile;
      });
    });
  }

  void setAddress() {
    setState(() {
      _address = UserSimplePreferences.getLocation() ?? '';
      _addressController.text = _address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            color: white),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        height: MediaQuery.of(context).size.height * 1.5,
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                "Personal Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: "First name",
                hintStyle: TextStyle(color: lightGrey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: black),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: "Last name",
                hintStyle: TextStyle(color: lightGrey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: black),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setPhoneNumber();
                  },
                  icon: Icon(Icons.auto_awesome_motion_outlined, color: black),
                ),
                hintText: "Phone Number",
                hintStyle: TextStyle(color: lightGrey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: black),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setAddress();
                  },
                  icon: Icon(Icons.location_searching_outlined, color: black),
                ),
                hintText: "Delivery address",
                hintStyle: TextStyle(color: lightGrey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: black),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                hintText: "Pincode",
                hintStyle: TextStyle(color: lightGrey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: black),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: green),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Prefinal(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      number: _mobileController.text,
                      address: _addressController.text,
                      pin: _pinController.text,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: white,
              ),
              label: Text(
                'Add',
                style: TextStyle(color: white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
