class OrderNowResponse {
  final String message;
  final OrderNow order;

  OrderNowResponse({required this.message, required this.order});

  factory OrderNowResponse.fromJson(Map<String, dynamic> json) {
    return OrderNowResponse(
      message: json['message'],
      order: OrderNow.fromJson(json['order']),
    );
  }
}

class OrderNow {
  final int id;
  final int userId;
  final double subtotal;
  final double discount;
  final double shipping;
  final double total;
  final String address;
  final String? promoCode;
  final String trackingId;
  final String createdAt;
  final String updatedAt;

  OrderNow({
    required this.id,
    required this.userId,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.total,
    required this.address,
    this.promoCode,
    required this.trackingId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderNow.fromJson(Map<String, dynamic> json) {
    return OrderNow(
      id: json['id'],
      userId: json['user_id'],
      subtotal: json['subtotal'].toDouble(),
      discount: json['discount'].toDouble(),
      shipping: json['shipping'].toDouble(),
      total: json['total'].toDouble(),
      address: json['address'],
      promoCode: json['promo_code'],
      trackingId: json['tracking_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
