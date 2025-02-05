class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final List<String> images;
  final String categoryName;
  final int categoryId;
  final SellerCenter sellerCenter;
  final Category category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.categoryName,
    required this.categoryId,
    required this.sellerCenter,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      categoryName: json['category_name'],
      categoryId: json['category_id'],
      sellerCenter: SellerCenter.fromJson(json['seller_center']),
      category: Category.fromJson(json['category']),
    );
  }
}

class SellerCenter {
  final int id;
  final int userId;
  final String storeName;
  final String ownerName;
  final String storeDetails;
  final String storeLogo;
  final bool isActive;
  final User user;

  SellerCenter({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.ownerName,
    required this.storeDetails,
    required this.storeLogo,
    required this.isActive,
    required this.user,
  });

  factory SellerCenter.fromJson(Map<String, dynamic> json) {
    return SellerCenter(
      id: json['id'],
      userId: json['user_id'],
      storeName: json['store_name'],
      ownerName: json['owner_name'],
      storeDetails: json['store_details'],
      storeLogo: json['store_logo'],
      isActive: json['is_active'] == 1,
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String username;
  final String? about;
  final String? profileImage;
  final bool isPrivate;
  final String dogType;
  final String breed;
  final int age;
  final double weight;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.about,
    this.profileImage,
    required this.isPrivate,
    required this.dogType,
    required this.breed,
    required this.age,
    required this.weight,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      about: json['about'] ?? '',
      profileImage: json['profile_image'] ??
          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
      isPrivate: json['is_private'] == 1,
      dogType: json['dog_type'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      weight: (json['weight'] as num).toDouble(),
      isActive: json['is_active'] == 1,
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      nextPageUrl: json['next_page_url'],
    );
  }
}
