import 'dart:convert';

class CategoryModel {
  final String imagePath;
  final String title;
  String? name;

  CategoryModel({
    required this.imagePath,
    required this.title,
    this.name,
  });

  CategoryModel copyWith({
    String? imagePath,
    String? title,
  }) {
    return CategoryModel(
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      name: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imagePath': imagePath,
      'title': title,
      'name': name,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      imagePath: map['imagePath'] as String,
      title: map['title'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductModel {
  final int id;
  final int sellerCenterId;
  final String name;
  final double price;
  final String description;
  final List<String> images;
  final String createdAt;
  final String updatedAt;
  final int categoryId;

  ProductModel({
    required this.id,
    required this.sellerCenterId,
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      sellerCenterId: json['seller_center_id'] as int,
      name: json['name'] as String,
      price: double.parse(json['price'] as String), // Convert price to double
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      categoryId: json['category_id'] as int,
    );
  }
}

class SellerModels {
  final String imageUrl;
  final String name;

  SellerModels({required this.imageUrl, required this.name});
}
