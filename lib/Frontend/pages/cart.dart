import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../auth/login.dart';
import '../constant/color.dart';
import 'dart:convert';

List<dynamic> cartDataList = [];
final _storage = const FlutterSecureStorage();
String _mobile = '';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    _storage.read(key: 'mobile').then((value) {
      setState(() {
        _mobile = value.toString();
      });
    });
    fetchCartData(_mobile);
  }

  Future<void> fetchCartData(String mobileNumber) async {
    const apiUrl = 'http://192.168.0.102:8000/cart';
    final url = Uri.parse('$apiUrl?mobile=$mobileNumber');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final cartData = jsonDecode(response.body);
        setState(() {
          cartDataList = cartData;
        });
        print(cartDataList);
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch data",
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
        centerTitle: true,
        title: Text(
          'Cart',
          style: TextStyle(color: black),
        ),
        backgroundColor: white,
        leading: Icon(
          Icons.abc,
          color: white,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.builder(
          itemCount: cartDataList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: extremelightgrey,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: black, width: 1.0)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            height: 100,
                            width: 120,
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              cartDataList[index]['image'].toString(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cartDataList[index]['name'].toString(),
                              style: TextStyle(
                                color: black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Icon(Icons.delete, color: red)
                          ],
                        ),
                      ),
                      Text(
                        'Total: ₹ ${(cartDataList[index]['price'] * cartDataList[index]['items']).toString()}',
                        style: TextStyle(
                          color: lightGrey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: green),
                            onPressed: () {},
                            child: Icon(
                              Icons.add,
                              color: black,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            cartDataList[index]['items'].toString(),
                            style: TextStyle(color: black, fontSize: 20.0),
                          ),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(backgroundColor: red),
                            onPressed: () {},
                            child: Icon(
                              Icons.remove,
                              color: black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
