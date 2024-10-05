// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:foodapp/constant/color.dart';
import 'package:foodapp/models/product.dart';
import 'package:foodapp/screens/productDetails.dart';
import 'package:foodapp/services/api/api_service.dart';
import 'package:foodapp/utils/toogle_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

UtilityServices utils = UtilityServices();
ApiService service = ApiService();

class ProductWidget extends StatefulWidget {
  final Product item;
  const ProductWidget({
    super.key,
    required this.item,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String token = "";
  bool isLoading = false;

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? 'No token found';
    });
  }

  @override
  void initState() {
    super.initState();
    getToken().then((_) {
      service.fetchUserInfo(token, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade500,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey.shade100,
      ),
      height: 100,
      width: 150,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  service.addToCart(widget.item.id, context);
                },
                icon: isLoading
                    ? const Icon(Icons.shopping_cart)
                    : const Icon(
                        color: Colors.green,
                        Icons.shopping_cart_checkout_outlined,
                      ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              widget.item.image,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
              height: 90,
              width: 130,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            widget.item.name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            "₹${widget.item.price}",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.green,
              fontWeight: FontWeight.w900,
            ),
          ),
          GestureDetector(
            onTap: () {
              // openBottomSheet(context, widget.item);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProductDetails(item: widget.item);
                },
              ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                "View",
                style: TextStyle(
                  fontSize: 16,
                  color: white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
