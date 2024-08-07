// ignore_for_file: use_build_context_synchronously, unused_element
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/auth/login.dart';
import 'package:foodapp/constant/images.dart';
import 'package:foodapp/pages/orders.dart';
import 'package:foodapp/pages/product_details.dart';
import 'package:foodapp/pages/profile.dart';
import 'package:foodapp/state/generalState.dart';
import 'utils/user_simple_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'widgets/home_widgets.dart';
import 'constant/color.dart';
import 'dart:convert';

const _storage = FlutterSecureStorage();
String location = '';
List<dynamic> products = [];
List<dynamic> filterProducts = [];
String _mobile = '';

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
    fetchData();
    _storage.read(key: 'mobile').then((value) {
      setState(() {
        _mobile = value.toString();
        location = UserSimplePreferences.getLocation() ?? '';
      });
    });

    super.initState();
  }

  // *Set lables based on filter*
  void setLabel({flag}) {
    setState(() {
      if (flag == 'all') {
        filterProducts = products;
      } else {
        filterProducts = products
            .where((element) => element['type'].toString() == flag)
            .toList();
      }
    });
  }

  // *Fetch Products from backend*
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.102:8000/products'));

    if (response.statusCode == 200) {
      // Successful response
      final data = response.body;
      products = json.decode(data);
      print(products[0]);
    } else {
      // Handle the error
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
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
                onTap: () {
                  Navigator.of(context).pushNamed('/cart').then((_) {
                    _scaffoldKey.currentState!.openEndDrawer();
                  });
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Cart(),
                  //   ),
                  // );
                }),
            horizontalLine,
            ListTile(
                title: const Text("Orders",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Orders(),
                    ),
                  );
                }),
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
              height: 2000,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: () async {
                      _getPosition().then((v) {
                        UserSimplePreferences.setLocation(v.toString());
                        value.setLocation(v.toString());
                      });
                    },
                    child: Center(
                      child: Chip(
                        label: Text(location),
                        avatar: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  automaticSlider(),
                  const SizedBox(height: 20.0),
                  searchBar(),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      imagesWithText(
                          image: burger, text: "Burger", onTap: () {}),
                      imagesWithText(image: pizza, text: "Pizza", onTap: () {}),
                      imagesWithText(
                          image: noodles, text: "Noodles", onTap: () {}),
                      imagesWithText(image: meat, text: "Meat", onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      imagesWithText(
                          image: veggies, text: "Vegan", onTap: () {}),
                      imagesWithText(
                          image: desserts, text: "Dessert", onTap: () {}),
                      imagesWithText(image: drink, text: "Drink", onTap: () {}),
                      imagesWithText(image: more, text: "More", onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Recommended For You 😍',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                          onTap: () {
                            value.setAll();
                            setLabel(flag: value.flag);
                          },
                          child: Chip(
                            backgroundColor:
                                value.flag == 'all' ? lightGreen : white,
                            side: BorderSide(width: 1.0, color: blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text(
                              "All",
                            ),
                            avatar: CircleAvatar(
                              backgroundColor: green,
                              radius: 50,
                              child: Icon(
                                Icons.done,
                                color: white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            value.setBurger();
                            setLabel(flag: value.flag);
                          },
                          child: Chip(
                            backgroundColor:
                                value.flag == 'burger' ? lightGreen : white,
                            side: BorderSide(width: 1.0, color: blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text(
                              "Burger",
                            ),
                            avatar: const Image(
                              height: 30,
                              width: 30,
                              image: AssetImage(burger),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            value.setPizza();
                            setLabel(flag: value.flag);
                          },
                          child: Chip(
                            backgroundColor:
                                value.flag == 'pizza' ? lightGreen : white,
                            side: BorderSide(width: 1.0, color: blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text(
                              "Pizza",
                            ),
                            avatar: const Image(
                              height: 30,
                              width: 30,
                              image: AssetImage(pizza),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            value.setNoodles();
                            setLabel(flag: value.flag);
                          },
                          child: Chip(
                            backgroundColor:
                                value.flag == 'noodles' ? lightGreen : white,
                            side: BorderSide(width: 1.0, color: blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text(
                              "Noodles",
                            ),
                            avatar: const Image(
                              height: 30,
                              width: 30,
                              image: AssetImage(noodles),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            value.setMeat();
                            setLabel(flag: value.flag);
                          },
                          child: Chip(
                            backgroundColor:
                                value.flag == 'meat' ? lightGreen : white,
                            side: BorderSide(width: 1.0, color: blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text(
                              "Meat",
                            ),
                            avatar: const Image(
                              height: 30,
                              width: 30,
                              image: AssetImage(meat),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            value.setVeggie();
                            setLabel(flag: value.flag);
                          },
                          child: Chip(
                            backgroundColor:
                                value.flag == 'veggies' ? lightGreen : white,
                            side: BorderSide(width: 1.0, color: blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text(
                              "Vegan",
                            ),
                            avatar: const Image(
                              height: 30,
                              width: 30,
                              image: AssetImage(veggies),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            value.setDesserts();
                            setLabel(flag: value.flag);
                          },
                          child: Chip(
                            backgroundColor:
                                value.flag == 'dessert' ? lightGreen : white,
                            side: BorderSide(width: 1.0, color: blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text(
                              "Dessert",
                            ),
                            avatar: const Image(
                              height: 30,
                              width: 30,
                              image: AssetImage(desserts),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            value.setDrink();
                            setLabel(flag: value.flag);
                          },
                          child: Chip(
                            backgroundColor:
                                value.flag == 'drink' ? lightGreen : white,
                            side: BorderSide(width: 1.0, color: blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text(
                              "Drink",
                            ),
                            avatar: const Image(
                              height: 30,
                              width: 30,
                              image: AssetImage(drink),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // *Ending of Filter Chips*
                  const SizedBox(height: 20.0),

                  SizedBox(
                    height: filterProducts.length * 130,
                    width: double.infinity,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filterProducts.length,
                      itemBuilder: (context, index) {
                        print(filterProducts[index]['price'].toString());
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  name:
                                      filterProducts[index]['name'].toString(),
                                  price: filterProducts[index]['price'],
                                  image:
                                      filterProducts[index]['image'].toString(),
                                  type:
                                      filterProducts[index]['type'].toString(),
                                  distance: filterProducts[index]['distance'],
                                  ratings: filterProducts[index]['ratings'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: extremelightgrey,
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border:
                                          Border.all(color: black, width: 1.0)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                      height: 100,
                                      width: 120,
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        filterProducts[index]['image']
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                SizedBox(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        filterProducts[index]['name']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Text(
                                              '${filterProducts[index]['distance'].toString()}m\t\t|\t\t'),
                                          const Icon(Icons.star,
                                              color: Colors.amber),
                                          const SizedBox(width: 5.0),
                                          Text(filterProducts[index]['ratings']
                                              .toString()),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '₹ ${filterProducts[index]['price'].toString()}'),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                                Icons.favorite_border,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
