class CategoryModel {
  final String id;
  final String name;
  final List parentCategories;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.parentCategories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['name'],
      parentCategories: json['parentCategories'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
