class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final List<dynamic> categories;
  final String brand;
  final int countInStock;
  final String image;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categories,
    required this.brand,
    required this.countInStock,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      categories: json['categories'],
      brand: json['brand'],
      countInStock: json['countInStock'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'categories': categories,
      'brand': brand,
      'countInStock': countInStock,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
