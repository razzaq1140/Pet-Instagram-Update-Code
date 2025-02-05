class CartItemUpdateResponse {
  final String message;
  final CartItemData data;

  CartItemUpdateResponse({required this.message, required this.data});

  factory CartItemUpdateResponse.fromJson(Map<String, dynamic> json) {
    return CartItemUpdateResponse(
      message: json['message'],
      data: CartItemData.fromJson(json['data']),
    );
  }
}

class CartItemData {
  final int id;
  final String productName;
  final int quantity;
  final String price;
  final int subtotal;

  CartItemData({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      id: json['id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'],
      subtotal: json['subtotal'],
    );
  }
}
