class ProductCategoryModel {
  int id;
  String name;
  String imageUrl;
  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> map) {
    return ProductCategoryModel(
      id: map['id'],
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
