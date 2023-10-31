// ignore_for_file: use_build_context_synchronously
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/Frontend/pages/finalPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constant/color.dart';
import 'dart:convert';
import 'cart.dart';

double? _sum;
int? _items;

List<dynamic> _cartDataList = [];

void renderValue() {
  _sum = cartDataList.fold(0, (double? sum, item) {
    double? price = item["price"].toDouble();
    double? items = item["items"].toDouble();
    return sum! + (price! * items!);
  });

  _items = cartDataList
      .map((e) => e["items"])
      .reduce((value, element) => value + element);
}

List<String> options = ['online', 'cod'];
String selectedValue = options[0];
bool? _flag;
Future<bool> createOrder(List<Map<String, dynamic>> orderData) async {
  const apiUrl = 'http://192.168.0.102:8000/order';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderData),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Successfully placed order✅",
      );
      return true;
    } else {
      Fluttertoast.showToast(
        msg: "Order already placed!",
      );
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

class Prefinal extends StatefulWidget {
  String firstName = '';
  String lastName = '';
  String number = '';
  String address = '';
  String pin = '';
  Prefinal({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.number,
    required this.address,
    required this.pin,
  });

  @override
  State<Prefinal> createState() => _PrefinalState();
}

class _PrefinalState extends State<Prefinal> {
  @override
  void initState() {
    renderValue();
    _fetchCartData(widget.number);
    print('rod');
    super.initState();
  }

  Future<void> _fetchCartData(String mobileNumber) async {
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
      setState(() {
        _cartDataList = cartData;
      });
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prefinal'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Details',
                style: TextStyle(
                    color: black, fontSize: 24, fontWeight: FontWeight.w800),
              ),
              Text(
                '${widget.firstName} ${widget.lastName}',
                style: TextStyle(
                  color: black,
                  fontSize: 14,
                ),
              ),
              Text(
                'Phone: ${widget.number}',
                style: TextStyle(
                  color: black,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 200,
                    child: Text(
                      widget.address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    widget.pin,
                    style: TextStyle(
                      color: black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                'Order Details',
                style: TextStyle(
                  color: black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Items',
                    style: TextStyle(
                      color: black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Price',
                    style: TextStyle(
                      color: black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Quantity',
                    style: TextStyle(
                      color: black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Divider(
                color: extremelightgrey,
                thickness: 1,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: cartDataList.length * 60,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartDataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cartDataList[index]['name']),
                      trailing: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("₹" +
                                "" +
                                cartDataList[index]['price'].toString()),
                            Text(cartDataList[index]['items'].toString()),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Divider(
                color: extremelightgrey,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '₹' + "" + _sum.toString(),
                    style: TextStyle(
                      color: black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    _items.toString(),
                    style: TextStyle(
                      color: black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Divider(
                color: extremelightgrey,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Online Payment',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Radio(
                        value: options[0],
                        groupValue: selectedValue,
                        onChanged: (val) {
                          setState(() {
                            selectedValue = val.toString();
                          });
                        },
                        activeColor: blue,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Cash On Delivery',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Radio(
                        value: options[1],
                        groupValue: selectedValue,
                        onChanged: (val) {
                          setState(() {
                            selectedValue = val.toString();
                          });
                        },
                        activeColor: blue,
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  onPressed: () async {
                    final dynamic finalOrderdata = [
                      {
                        "personal": {
                          "firstName": widget.firstName,
                          "lastName": widget.lastName,
                          "address": widget.address,
                          "pincode": widget.pin,
                          "mobile": widget.number,
                        },
                        "order": _cartDataList,
                        "orderType": selectedValue
                      }
                    ];
                    _flag = await createOrder(finalOrderdata);
                    _flag == true
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FinalPage(),
                            ),
                          )
                        : Fluttertoast.showToast(
                            msg: "Order did not place",
                          );
                  },
                  child: Text(
                    'Proceed',
                    style: TextStyle(color: white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
