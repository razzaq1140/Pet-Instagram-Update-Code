class OrderRequest {
  final int productId;
  final int quantity;
  final String address;
  final String promoCode;

  OrderRequest({
    required this.productId,
    required this.quantity,
    required this.address,
    required this.promoCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'address': address,
      'promo_code': promoCode,
    };
  }
}
