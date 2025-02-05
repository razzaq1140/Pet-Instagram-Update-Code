class MyOrderModel {
  final String orderId;
  final String productName;
  final double price;
  final String imageUrl;
  final OrderStatus status;

  MyOrderModel({
    required this.orderId,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.status,
  });
}

enum OrderStatus { delivered, inProcess, cancelled }
