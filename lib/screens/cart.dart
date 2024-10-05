// ignore_for_file: use_build_context_synchronously

import 'dart:async'; // Import for StreamController and Stream
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodapp/providers/generalState.dart';
import 'package:foodapp/utils/toogle_toast.dart';
import 'package:foodapp/widgets/cart_widget.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

UtilityServices utils = UtilityServices();

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String token = "";
  String userId = "";
  late StreamController<List<dynamic>> _cartStreamController;
  String? cid = "";
  int? itemCount = 0;

  @override
  void initState() {
    super.initState();
    _cartStreamController = StreamController<List<dynamic>>();
    _initializeCartData();
  }

  @override
  void dispose() {
    _cartStreamController.close();
    super.dispose();
  }

  Future<void> _initializeCartData() async {
    await getToken();
    if (token.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      userId = decodedToken['id'] ?? '';
      if (userId.isNotEmpty) {
        fetchCartData();
      }
    }
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  void fetchCartData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://food-app-backend-chi.vercel.app/api/cart?uid=$userId"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        setState(() {
          itemCount = data[0]['cartItems'].length;
        });

        _cartStreamController.sink.add(data);
      } else {
        _cartStreamController.sink.addError('Failed to load cart data');
      }
    } catch (e) {
      _cartStreamController.sink.addError('Error: $e');
    }
  }

  void deleteItemFromCart(String pid) async {
    try {
      final response = await http.delete(Uri.parse(
          "https://food-app-backend-chi.vercel.app/api/cart?pid=${pid}"));
      if (response.statusCode == 200) {
        // After deleting, refetch the updated cart data
        fetchCartData();
        if (mounted) {
          // Show a success message after incrementing or decrementing
          utils.callToast(
            context,
            "Item deleted from cart successfully",
            "error",
          );
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void onCounter(String pid, String cid, String type) async {
    print("pid:${pid}, cid:${cid}");
    try {
      final response = await http.put(
        Uri.parse(
            "https://food-app-backend-chi.vercel.app/api/cart?pid=${pid}&cid=${cid}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            "action": type == "up" ? "increment" : "decrement",
          },
        ),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // After deleting, refetch the updated cart data
        fetchCartData();
        if (mounted) {
          // Show a success message after incrementing or decrementing
          utils.callToast(
            context,
            "Item ${type == "up" ? "incremented" : "decremented"} by 1",
            type == "up"
                ? "success"
                : type == "down"
                    ? "info"
                    : "",
          );
        }
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        // Show a success message after incrementing or decrementing
        utils.callToast(
          context,
          "Item incremented successfully",
          "failure",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Cart ($itemCount)",
                      style: TextStyle(
                        color: Colors.indigo.shade900,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<dynamic>>(
                  stream: _cartStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final cart = snapshot.data!.first; // Cart object
                      final cartItems = cart['cartItems'] as List<dynamic>;

                      return ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return cartItemWidget(
                            item: item,
                            cid: cart['_id'],
                            context: context,
                            onDelete: deleteItemFromCart,
                            onCounter: onCounter,
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("No items in the cart"),
                      );
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 30.0,
                ),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.blue,
                  ),
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    backgroundColor: Colors.blue.shade100,
                  ),
                  onPressed: () {},
                  label: const Text(
                    "Checkout",
                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
