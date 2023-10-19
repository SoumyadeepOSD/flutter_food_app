// ignore_for_file: use_build_context_synchronously
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodapp/Frontend/state/generalState.dart';
import 'package:foodapp/Frontend/pages/profile.dart';
import 'package:foodapp/Frontend/auth/login.dart';
import 'utils/user_simple_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'widgets/home_widgets.dart';
import 'constant/color.dart';

const _storage = FlutterSecureStorage();
String location = '';
final horizontalLine = Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0),
  child: Divider(color: verylightgrey, thickness: 1),
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    setState(() {
      location = UserSimplePreferences.getLocation() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Foody',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _storage.delete(key: 'mobile').then((value) {
                print('Key value removed');
              }).catchError((error) {
                print('Error removing key: $error');
              });
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.notifications_active,
              color: Colors.amber,
              size: 30,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 30.0),
            ListTile(
                title: const Text("Profile",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                }),
            horizontalLine,
            ListTile(
                title: const Text("Favorites",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                }),
            horizontalLine,
            ListTile(
                title: const Text("Cart",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {}),
            horizontalLine,
            ListTile(
                title: const Text("Notifications",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {}),
            horizontalLine,
            ListTile(
                title: const Text("Settings",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {}),
            horizontalLine,
            ListTile(
                title: const Text("Share",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {}),
            horizontalLine,
            ListTile(
                title: const Text("Log Out",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.exit_to_app_outlined,
                  color: lightGrey,
                ),
                onTap: () {
                  print("Hello");
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
                                style: TextStyle(
                                    color: black, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      await _storage
                                          .delete(key: 'mobile')
                                          .then((value) {
                                        print('Key value removed');
                                      }).catchError((error) {
                                        print('Error removing key: $error');
                                      });
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
                }),
            const SizedBox(height: 200.0),
            Center(
              child: Text(
                "v1.0.0",
                style: TextStyle(color: darkGrey, fontSize: 14.0),
              ),
            )
          ],
        ),
      ),
      body: Consumer<generalStateProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              color: white,
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: () async {
                      _getPosition().then((v) {
                        UserSimplePreferences.setLocation(v.toString());
                        value.setLocation(v.toString());
                      });
                    },
                    child: Chip(
                      label: Text(location),
                      avatar: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  automaticSlider(),
                  const SizedBox(height: 20.0),
                  searchBar(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// *Get position from GPS of mobile*
Future<String?> _getPosition() async {
  String? address;
  LocationPermission permission = await Geolocator.checkPermission();
  try {
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("No permission is given");
      await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(currentPosition.latitude.toString()),
        double.parse(currentPosition.longitude.toString()),
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        address =
            "${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
      } else {
        print("No location information found");
      }
    }
  } catch (e) {
    print("Error $e");
  }
  return address;
}
