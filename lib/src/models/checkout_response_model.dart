class CheckoutResponse {
  final String message;
  final int orderId;
  final String trackingId;
  final String dataeTime;
  final String clientSecret;

  CheckoutResponse({
    required this.message,
    required this.orderId,
    required this.trackingId,
    required this.dataeTime,
    required this.clientSecret,
  });

  factory CheckoutResponse.fromMap(Map<String, dynamic> map) {
    return CheckoutResponse(
      message: map['message'] as String? ?? '',
      orderId: map['order_id'] as int? ?? 0,
      trackingId: map['tracking_id'] as String? ?? '',
      dataeTime: map['date_time'] as String? ?? '',
      clientSecret: map['client_secret'] as String? ?? '',
    );
  }
}
