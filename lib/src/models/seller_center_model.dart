import 'product_model.dart';

class SellerDashboard {
  final int? totalSales;
  final int? customerCount;
  final List<ProductModel>? products;
  final List<Order>? orderHistory;
  final List<Category>? topSellingCategories;
  final List<Product>? topSellingProducts;

  SellerDashboard({
    this.totalSales,
    this.customerCount,
    this.products,
    this.orderHistory,
    this.topSellingCategories,
    this.topSellingProducts,
  });

  // Factory constructor to parse JSON data
  factory SellerDashboard.fromJson(Map<String, dynamic> json) {
    return SellerDashboard(
      totalSales: json['total_sales'] as int?,
      customerCount: json['customer_count'] as int?,
      products: (json['products'] as List<dynamic>?)
          ?.map((item) => ProductModel.fromJson(item))
          .toList(),
      orderHistory: (json['order_history'] as List<dynamic>?)
          ?.map((item) => Order.fromJson(item))
          .toList(),
      topSellingCategories: (json['top_selling_categories'] as List<dynamic>?)
          ?.map((item) => Category.fromJson(item))
          .toList(),
      topSellingProducts: (json['top_selling_products'] as List<dynamic>?)
          ?.map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}

// Example Model for a Product with nullable fields
class Product {
  final String? name;
  final double? price;

  Product({
    this.name,
    this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}

// Example Model for an Order with nullable fields
class Order {
  final String? id;
  final double? totalAmount;
  final String? date;

  Order({
    this.id,
    this.totalAmount,
    this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      date: json['date'] as String?,
    );
  }
}

// Example Model for a Category with nullable fields
class Category {
  final String? name;
  final int? salesCount;

  Category({
    this.name,
    this.salesCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String?,
      salesCount: json['sales_count'] as int?,
    );
  }
}
