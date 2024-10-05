import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodapp/constant/filters.dart';
import 'package:foodapp/models/product.dart';
import 'package:foodapp/providers/generalState.dart';
import 'package:foodapp/services/api/api_service.dart';
import 'package:foodapp/widgets/home_widgets.dart';
import 'package:foodapp/widgets/product_widget.dart';
import 'package:lottie/lottie.dart';
import 'components/drawer.dart';
import 'utils/user_simple_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

const _storage = FlutterSecureStorage();
final ApiService apiService = ApiService();
String location = "";
late Future<Iterable<Product>> _productList;
late Future<Map<String, dynamic>> _userInfo;
String _selectedCategory = "";

final Map<String, bool> favourites = {};

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String initialSearchQuery = '';
  String initialSearchCategory = '';

  @override
  void initState() {
    super.initState();
    location = UserSimplePreferences.getLocation() ?? '';
    final provider = Provider.of<GeneralStateProvider>(context, listen: false);
    initialSearchQuery = provider.thisQuery;
    initialSearchCategory = provider.thisCategory;

    _fetchProducts(initialSearchQuery, initialSearchCategory);
    _userInfo = apiService.decodedDataFromToken();

    provider.addListener(_updateSearchFilters);
  }

  void _updateSearchFilters() {
    final provider = Provider.of<GeneralStateProvider>(context, listen: false);
    String newSearchQuery = provider.thisQuery;
    String newSearchCategory = provider.thisCategory;

    if (initialSearchQuery != newSearchQuery ||
        initialSearchCategory != newSearchCategory) {
      _fetchProducts(newSearchQuery, newSearchCategory);
      initialSearchQuery = newSearchQuery;
      initialSearchCategory = newSearchCategory;
    }
  }

  void _fetchProducts(String query, String category) {
    setState(() {
      _productList = apiService.fetchProducts(query, category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            );
          },
        ),
        centerTitle: true,
        title:
            const Text('Foody', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      drawer: drawerComponent(context, _scaffoldKey),
      body: Consumer<GeneralStateProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                _buildLocationChip(value),
                _buildUserInfo(),
                const SizedBox(height: 20.0),
                automaticSlider(),
                const SizedBox(height: 20.0),
                searchBar(value.thisQuery, context, _fetchProducts),
                const SizedBox(height: 20.0),
                _buildCategoriesGrid(),
                const SizedBox(height: 20.0),
                _buildProductsGrid(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationChip(GeneralStateProvider value) {
    return InkWell(
      onTap: () async {
        final newLocation = await _getPosition();
        if (newLocation != null) {
          UserSimplePreferences.setLocation(newLocation);
          value.setLocation(newLocation);
        }
      },
      child: Center(
        child: Chip(
          label: Text(location),
          avatar: const Icon(Icons.location_on, color: Colors.red),
        ),
      ),
    );
  }

  Future<String?> _getPosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }

      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        return "${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return null;
  }

  Widget _buildUserInfo() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final userInfo = snapshot.data!;
          return Text(
            'Welcome, ${userInfo['fullName']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          );
        } else {
          return const Text('No user data found');
        }
      },
    );
  }

  Widget _buildCategoriesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categories',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
        const SizedBox(height: 10.0),
        Container(
          height: 230,
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 2 / 2.5,
            ),
            itemCount: filtersList.length,
            itemBuilder: (context, index) {
              final filter = filtersList[index];
              return imagesWithText(
                image: filter["icon"],
                text: filter["name"],
                onTap: () {
                  setState(() {
                    if (_selectedCategory == filter["catId"]) {
                      _selectedCategory =
                          ""; // Unselect if the same option is clicked
                    } else {
                      _selectedCategory =
                          filter["catId"]; // Set the selected category
                    }
                  });
                  Provider.of<GeneralStateProvider>(context, listen: false)
                      .setCategory(_selectedCategory);
                  _fetchProducts('', _selectedCategory);
                },
                isSelected: _selectedCategory == filter["catId"],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsGrid() {
    return FutureBuilder<Iterable<Product>>(
      future: _productList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final products = snapshot.data!.toList();
          if (products.isEmpty) {
            return Center(
              child: Lottie.network(
                  "https://lottie.host/9c64a5b9-bfd8-49f6-b5ea-dcb37a6b0881/w9DuWBM2i2.json",
                  height: 100,
                  width: 100),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 2 / 3,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductWidget(item: product);
            },
          );
        } else {
          return Center(
            child: Lottie.network(
                "https://lottie.host/embed/1ebf1143-3c9a-4557-9f1a-3ff3930ab0b1/g7MN9B6Z3a.json"),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    final provider = Provider.of<GeneralStateProvider>(context, listen: false);
    provider.removeListener(_updateSearchFilters);
    super.dispose();
  }
}
