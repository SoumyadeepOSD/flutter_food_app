import 'package:foodapp/Frontend/constant/images.dart';

class ProductModel {
  String? type;
  String? image;
  String? name;
  double? distance;
  double? ratings;
  double? price;

  ProductModel({
    required this.type,
    required this.image,
    required this.name,
    required this.distance,
    required this.ratings,
    required this.price,
  });
}

List<ProductModel> products = [
  // *Burgers*

  // *Pizza*
  ProductModel(
    type: 'pizza',
    image: pizza,
    name: " Chicken Alfredo Pizza",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'pizza',
    image: pizza,
    name: "Tandoori Chicken Pizza",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'pizza',
    image: pizza,
    name: "Mutton Kebab Pizza",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'pizza',
    image: pizza,
    name: "BBQ Chicken Ranch Pizza",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'pizza',
    image: pizza,
    name: "Spicy Chicken Sausage Pizza",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  // *Noodles*
  ProductModel(
    type: 'noodles',
    image: noodles,
    name: "Pad Thai Noodles",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'noodles',
    image: noodles,
    name: "Ramen with Shoyu Broth",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'noodles',
    image: noodles,
    name: "Spicy Szechuan Noodles",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'noodles',
    image: noodles,
    name: "Italian Pesto Pasta",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'noodles',
    image: noodles,
    name: "Vietnamese Pho Noodles",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'drink',
    image: drink,
    name: "Vietnamese Pho Noodles",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
];
