import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodapp/constant/images.dart';
import 'package:foodapp/pages/checkout.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constant/color.dart';
import 'dart:convert';

List<dynamic> cartDataList = [];

Future<List<dynamic>> fetchCartData(String mobileNumber) async {
  const apiUrl = 'http://192.168.0.102:8000/cart';
  final url = Uri.parse('$apiUrl?mobile=$mobileNumber');
  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    final cartData = jsonDecode(response.body);
    print(cartData);
    return cartData;
  } else {
    throw Exception("Failed to fetch data");
  }
}

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _storage = const FlutterSecureStorage();
  String _mobile = '';

  @override
  void initState() {
    _storage.read(key: 'mobile').then((value) {
      setState(() {
        _mobile = value.toString();
      });
    });
    super.initState();
  }

  Future<void> incrementItemQuantity(int index) async {
    setState(() {
      cartDataList[index]['items']++;
    });
    updateCartOnBackend(index, cartDataList[index]['items']);
  }

  Future<void> decrementItemQuantity(int index) async {
    setState(() {
      cartDataList[index]['items']--;
    });
    updateCartOnBackend(index, cartDataList[index]['items']);
  }

  Future<void> updateCartOnBackend(int index, int quantity) async {
    final apiUrl =
        'http://192.168.0.102:8000/cart/${cartDataList[index]['_id']}'; // Assuming you have an ID for the cart item
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'items': quantity}),
    );
    if (response.statusCode == 200) {
      print('Amount changed successfully');
    } else {
      print('Failed to update cart. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteCartItem(int index) async {
    final apiUrl =
        'http://192.168.0.102:8000/cart/${cartDataList[index]['_id']}'; // Assuming you have an ID for the cart item
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        cartDataList.removeAt(index);
      });
    } else {
      print('Failed to delete cart. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<List<dynamic>>(
          future: fetchCartData(_mobile),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle error gracefully
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.data!.isNotEmpty) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    const Image(
                      image: AssetImage(cartEmpty),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Your cart is empty! Fill it up!",
                      style: TextStyle(
                          color: black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            } else {
              // Data has been fetched, update the cartDataList
              cartDataList = snapshot.data!;
              return Container(
                height: cartDataList.length * 180,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: cartDataList.length * 150,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                              color: black, width: 1.0)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image(
                                          height: 100,
                                          width: 120,
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                            cartDataList[index]['image']
                                                .toString(),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            cartDataList[index]['name']
                                                .toString(),
                                            style: TextStyle(
                                              color: black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              deleteCartItem(index);
                                            },
                                            child:
                                                Icon(Icons.delete, color: red),
                                          )
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
                                          onPressed: () {
                                            incrementItemQuantity(index);
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: black,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          cartDataList[index]['items']
                                              .toString(),
                                          style: TextStyle(
                                              color: black, fontSize: 20.0),
                                        ),
                                        const SizedBox(width: 10.0),
                                        cartDataList[index]['items'] > 1
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: red),
                                                onPressed: () {
                                                  decrementItemQuantity(index);
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: black,
                                                ),
                                              )
                                            : const SizedBox(height: 0),
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
                    const SizedBox(height: 20.0),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Checkout(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: white,
                      ),
                      label: Text(
                        'Final Checkout',
                        style: TextStyle(color: white),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
