class PaymentRequest {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final int orderId;

  PaymentRequest({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'card_number': cardNumber,
      'expiry_date': expiryDate,
      'cvv': cvv,
      'order_id': orderId,
    };
  }

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      cardNumber: json['card_number'],
      expiryDate: json['expiry_date'],
      cvv: json['cvv'],
      orderId: json['order_id'],
    );
  }
}
