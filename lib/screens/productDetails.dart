// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:foodapp/constant/color.dart';
import 'package:foodapp/models/product.dart';
import 'package:foodapp/services/api/api_service.dart';
import 'package:foodapp/utils/catId_to_catName.dart';

ApiService service = ApiService();

class ProductDetails extends StatefulWidget {
  Product item;
  ProductDetails({required this.item, super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: categoryIdToCategoryName(catIds: widget.item.categories),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            // Handle errors during data fetching
            return const Center(
              child: Text("Something went wrong"),
            );
          } else if (snapshot.hasData) {
            // When data is successfully fetched, display the bottom sheet content
            final categoryNames = snapshot.data!;

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              height: 900,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.cancel,
                          color: red,
                        ),
                      )
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Image.network(
                      fit: BoxFit.cover,
                      widget.item.image,
                      height: 200,
                      width: MediaQuery.of(context).size.width - 50,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.item.name,
                            style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      widget.item.brand.toString(),
                      style: TextStyle(
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  // Render fetched category names
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: categoryNames
                        .map(
                          (name) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: green)),
                            child: Text(
                              name,
                              style: TextStyle(
                                color: black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About Product',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        Text(widget.item.description.toString()),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "₹${widget.item.price.toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: green,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "In Stock: ${widget.item.countInStock.toString()} items",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: black,
                      ),
                      onPressed: () {
                        service.addToCart(widget.item.id, context);
                      },
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          // Fallback UI if no data is available
          return const Text('No categories available');
        },
      ),
    );
  }
}
