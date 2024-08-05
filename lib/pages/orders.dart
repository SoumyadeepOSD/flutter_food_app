import 'package:foodapp/constant/color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

List<dynamic> _ordersDataList = [];
String? _timeSpan;

double? _sum;

int? _items;
Future<List<dynamic>> fetchOrders() async {
  const apiUrl = 'http://192.168.0.102:8000/orders';
  final url = Uri.parse(apiUrl);
  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    final ordersData = jsonDecode(response.body);
    _ordersDataList = ordersData[0]['order'];
    DateTime dateTime = DateTime.parse(ordersData[0]['createdAt'].toString());
    _timeSpan = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    _sum = _ordersDataList.fold(0, (double? sum, item) {
      double? price = item["price"].toDouble();
      double? items = item["items"].toDouble();
      return sum! + (price! * items!);
    });
    _items = _ordersDataList
        .map((e) => e["items"])
        .reduce((value, element) => value + element);
    return ordersData;
  } else {
    throw Exception("Failed to fetch data");
  }
}

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<List<dynamic>>(
          future: fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(_ordersDataList);
              return Container(
                color: white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Items($_items)",
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Total: ₹ $_sum',
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(color: extremelightgrey, thickness: 1),
                    ),
                    Text(
                      'Your Order Placed on: $_timeSpan',
                      style: const TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: _ordersDataList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: black, width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Image(
                                        height: 50,
                                        width: 50,
                                        image: NetworkImage(
                                          _ordersDataList[index]['image'],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 30.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _ordersDataList[index]['name']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(
                                          "Total: ₹ ${_ordersDataList[index]['price']} x ${_ordersDataList[index]['items']} = ₹ ${_ordersDataList[index]['price'] * _ordersDataList[index]['items']}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                          // return ListTile(
                          //   title: Text(_ordersDataList[index]['name'].toString()),
                          //   subtitle: Text(_ordersDataList[index]['items'].toString()),
                          //   trailing: Text(_ordersDataList[index]['price'].toString()),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
