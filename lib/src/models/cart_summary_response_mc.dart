class CartSummaryResponse {
  final String message;
  final CartData data;

  CartSummaryResponse({required this.message, required this.data});

  factory CartSummaryResponse.fromJson(Map<String, dynamic> json) {
    return CartSummaryResponse(
      message: json['message'],
      data: CartData.fromJson(json['data']),
    );
  }
}

class CartData {
  final int subtotal;
  final int discount;
  final int shipping;
  final int total;
  final List<CartItem> cartItems;

  CartData({
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.total,
    required this.cartItems,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      subtotal: json['subtotal'],
      discount: json['discount'],
      shipping: json['shipping'],
      total: json['total'],
      cartItems: List<CartItem>.from(
        json['cart_items'].map((item) => CartItem.fromJson(item)),
      ),
    );
  }
}

class CartItem {
  final String productName;
  final int quantity;
  final String price;
  final int subtotal;

  CartItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'],
      subtotal: json['subtotal'],
    );
  }
}
