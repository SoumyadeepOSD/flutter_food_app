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
  ProductModel(
    type: 'burger',
    image: burger,
    name: "Grilled Chicken Burger",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'burger',
    image: burger,
    name: "Spicy Mutton Kebab Burger",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'burger',
    image: burger,
    name: "Tandoori Chicken Burger",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'burger',
    image: burger,
    name: "BBQ Pulled Mutton Burger",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'burger',
    image: burger,
    name: "BBQ Pulled Mutton Burger",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
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

// *Drinks*
  ProductModel(
    type: 'meat',
    image: meat,
    name: "Chicken Curry",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'meat',
    image: meat,
    name: "Mutton Biryani",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'meat',
    image: meat,
    name: "Fish Tikka",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'meat',
    image: meat,
    name: "Keema (Minced Meat)",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'meat',
    image: meat,
    name: "Tandoori Lamb Chops",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  // *Veggies*
  ProductModel(
    type: 'veggie',
    image: veggies,
    name: "Chana Masala",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'veggie',
    image: veggies,
    name: "Vegetable Biryani",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'veggie',
    image: veggies,
    name: "Baingan Bharta",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'veggie',
    image: veggies,
    name: "Potato and Cauliflower Curry",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'veggie',
    image: veggies,
    name: "Tofu Tikka Masala",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  // *Desserts*
  ProductModel(
    type: 'desserts',
    image: desserts,
    name: "Chocolate Brownie",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'desserts',
    image: desserts,
    name: "Tiramisu",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'desserts',
    image: desserts,
    name: "Strawberry Cheesecake",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'desserts',
    image: desserts,
    name: "Apple Pie",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
  ProductModel(
    type: 'desserts',
    image: desserts,
    name: "Mango Sorbet",
    distance: 0.5,
    ratings: 4.5,
    price: 100.0,
  ),
];
