class OrderHistoryModel {
  final String imageUrl;
  final String name;
  final String email;
  final String orderDetail;
  String status; // Add this field

  OrderHistoryModel({
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.orderDetail,
    this.status = 'Orders', // Default status
  });
}
