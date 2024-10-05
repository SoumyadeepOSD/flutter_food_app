// ignore_for_file: use_build_context_synchronously, control_flow_in_finally, body_might_complete_normally_nullable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodapp/models/categories_model.dart';
import 'package:foodapp/models/product.dart';
import 'package:foodapp/providers/generalState.dart';
import 'package:foodapp/screens/profile.dart';
import 'package:foodapp/utils/toogle_toast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

UtilityServices utils = UtilityServices();

class ApiService {
  final String baseUrl = "https://food-app-backend-chi.vercel.app";

  Future<List<Product>> fetchProducts(String searchQuery, String cat) async {
    try {
      // Construct the full API URL with query parameters
      final uri =
          Uri.parse("$baseUrl/api/products?search=$searchQuery&cat=$cat");

      // Send the GET request
      final response = await http.get(uri);

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> jsonData = json.decode(response.body);

        // Map the JSON data to a list of Product objects
        List<Product> products = jsonData
            .map((product) => Product.fromJson(product as Map<String, dynamic>))
            .toList();

        return products;
      } else {
        // Handle unexpected status codes
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (error) {
      // Log the error and rethrow it
      debugPrint('Error fetching products: $error');
      throw Exception('Error fetching products: $error');
    }
  }

  Future<bool?> verifyToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final jwtData = jwtDecode(token!);
    bool isExpired = jwtData.isExpired!;
    return !isExpired;
  }

  Future<Map<String, dynamic>> decodedDataFromToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.post(
        Uri.parse("$baseUrl/api/user/profile"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          // Convert body to JSON string
          "token": token,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = jsonDecode(response.body);
        final data = userData['data']; // Access 'data' from the response
        debugPrint("userdata ${response.body}");
        return data; // Return the 'data' object
      } else {
        throw Exception(
            'Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching Data: $e');
    }
  }

  void fetchUserInfo(String token, BuildContext context) async {
    Map<String, dynamic> requestBody = {"token": token};
    Provider.of<GeneralStateProvider>(context, listen: false).setLoading(true);
    try {
      // Make the POST request to the API
      final response = await http.post(
        Uri.parse("https://food-app-backend-chi.vercel.app/api/user/profile"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody), // Properly encode the request body
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final userProfile = jsonResponse['data'];
        // Check if userProfile contains valid data
        if (userProfile != null) {
          ProfileData profile = ProfileData.fromJson(userProfile);
          Provider.of<GeneralStateProvider>(context, listen: false)
              .setUserData(profile);
          Provider.of<GeneralStateProvider>(context, listen: false)
              .setLoading(false);
        } else {
          print('No user data found');
          Provider.of<GeneralStateProvider>(context, listen: false)
              .setLoading(false);
        }
      } else {
        print('Failed to fetch user data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        Provider.of<GeneralStateProvider>(context, listen: false)
            .setLoading(false);
      }
    } catch (e) {
      print('Exception caught: $e');
      Provider.of<GeneralStateProvider>(context, listen: false)
          .setLoading(false);
    }
  }

  void addToCart(String pid, BuildContext context) async {
    String uid =
        Provider.of<GeneralStateProvider>(context, listen: false).userData!.id;

    Provider.of<GeneralStateProvider>(context, listen: false).setLoading(true);
    try {
      print("uid: $uid pid: $pid");
      final response = await http.post(
        Uri.parse(
            'https://food-app-backend-chi.vercel.app/api/cart?uid=$uid&pid=$pid'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        utils.callToast(context, "Item added to cart", "success");
        print(jsonResponse);
      } else if (response.statusCode == 400) {
        utils.callToast(context, "Item already is in cart", "info");
      } else {
        // Handle cases where the status code is not 200 or 201
        print("Failed to add to cart. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      // Handle any exceptions that may occur during the HTTP call
      print("Error: $e");
    } finally {
      Provider.of<GeneralStateProvider>(context, listen: false)
          .setLoading(false);
    }
  }

  Future<CategoryModel?> fetchCategories(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/products/category/?id=$id"),
      );

      if (response.statusCode == 200) {
        // Decode the response body and use CategoryModel.fromJson
        final jsonData = jsonDecode(response.body);
        CategoryModel categoryData = CategoryModel.fromJson(jsonData);
        return categoryData;
      } else {
        print('Failed to load category data');
        return null;
      }
    } catch (e) {
      print('Exception caught: $e');
      return null;
    }
  }
}
