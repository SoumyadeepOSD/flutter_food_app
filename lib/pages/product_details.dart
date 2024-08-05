import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/constant/color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'cart.dart';

class ProductDetails extends StatefulWidget {
  String name;
  dynamic price;
  String image;
  String type;
  dynamic distance;
  dynamic ratings;

  ProductDetails(
      {super.key,
      required this.name,
      required this.price,
      required this.image,
      required this.type,
      required this.distance,
      required this.ratings});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  double metersToKms({distance}) => distance / 1000;

  int counter = 1;
  final _storage = const FlutterSecureStorage();
  String mobile = '';

  void changeCounter({type}) {
    setState(() {
      type == 'add' ? ++counter : --counter;
    });
  }

  @override
  void initState() {
    super.initState();
    _storage.read(key: 'mobile').then((value) {
      setState(() {
        mobile = value.toString();
      });
    });
  }

  Future<void> addToCart() async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.0.102:8000/cart"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mobile': mobile.toString(),
          'name': widget.name.toString(),
          'price': widget.price.toString(),
          'image': widget.image,
          'distance': widget.distance.toString(),
          'items': counter.toString(),
          'ratings': widget.ratings.toString(),
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Item(s) added to cart",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to add to cart",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: Icon(
          Icons.abc,
          color: white,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: 1000,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Stack(
              children: [
                Image(
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.image),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: black,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      color: red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w800,
                        fontSize: 30),
                  ),
                  Text(
                    '₹ ${widget.price.toString()}',
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            Divider(
              color: extremelightgrey,
              thickness: 1,
            ),
            SizedBox(
              width: 150,
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: deepYellow,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    '${widget.ratings.toString()} reviews',
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
            Divider(
              color: extremelightgrey,
              thickness: 1,
            ),
            SizedBox(
              width: 150,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: green,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    widget.distance > 1000
                        ? '${metersToKms(distance: widget.distance).toString()} km'
                        : '${widget.distance} m',
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
            Divider(
              color: extremelightgrey,
              thickness: 1,
            ),
            const SizedBox(height: 20.0),
            Center(
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Chip(
                      backgroundColor: extremelightgrey,
                      label: IconButton(
                        icon: Icon(Icons.add, color: black),
                        onPressed: () {
                          changeCounter(type: 'add');
                        },
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      counter.toString(),
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
                    ),
                    const SizedBox(width: 5.0),
                    counter > 1
                        ? Chip(
                            backgroundColor: extremelightgrey,
                            label: IconButton(
                              icon: Icon(Icons.remove, color: black),
                              onPressed: () {
                                changeCounter(type: 'sub');
                              },
                            ),
                          )
                        : const SizedBox(
                            height: 0.0,
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: green),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cart(),
                    ),
                  );
                  addToCart();
                },
                child: Text(
                  'Add to cart',
                  style: TextStyle(color: white, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
