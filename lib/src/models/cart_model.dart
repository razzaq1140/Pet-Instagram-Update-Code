class CartResponse {
  final String message;
  final List<CartItem> data;

  CartResponse({required this.message, required this.data});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<CartItem> cartItems = list.map((i) => CartItem.fromJson(i)).toList();

    return CartResponse(
      message: json['message'],
      data: cartItems,
    );
  }
}

class CartItem {
  final int id;
  final int userId;
  final int productId;
  int quantity;
  final String createdAt;
  final String updatedAt;
  final CartProduct product;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      product: CartProduct.fromJson(json['product']),
    );
  }
}

class CartProduct {
  final int id;
  final int sellerCenterId;
  final String name;
  final String price;
  final String description;
  final List<String> images;
  final String createdAt;
  final String updatedAt;
  final int? categoryId;

  CartProduct({
    required this.id,
    required this.sellerCenterId,
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    // Directly parse 'images' as List<String>
    List<String> images = List<String>.from(json['images']);

    return CartProduct(
      id: json['id'],
      sellerCenterId: json['seller_center_id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      images: images,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryId: json['category_id'],
    );
  }
}
