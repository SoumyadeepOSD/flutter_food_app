class CartDataModel {
  final String id;
  final List cartItems;

  CartDataModel({
    required this.id,
    required this.cartItems,
  });
  // Factory method to create a ProfileData instance from JSON
  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    return CartDataModel(id: json['_id'], cartItems: json['cartItems']);
  }
}
