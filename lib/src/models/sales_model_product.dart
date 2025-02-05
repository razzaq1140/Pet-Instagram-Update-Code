// sales_order_model.dart
class SalesProduct {
  final String imageUrl;
  final String productName;
  final int saleItems;
  final String productCategory;
  final double totalSale;

  SalesProduct({
    required this.imageUrl,
    required this.productName,
    required this.saleItems,
    required this.productCategory,
    required this.totalSale,
  });
}
