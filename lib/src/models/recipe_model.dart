import 'dart:convert';
import 'dart:developer';

import 'package:pet_project/src/core/api_endpoints.dart';

import 'comment_model.dart';

class Recipe {
  final int id;
  final int userId;
  final String name;
  final String category;
  final String preparationSteps;
  final List<String> images;
  final String createdAt;
  final String updatedAt;
  final bool likedByUser;
  final bool savedByUser;
  int commentsCount;
  final int likedCount;
  final int savedCount;
  final User user;
  final List<Like> likes;
  final List<CommentModel> comments;

  Recipe({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.preparationSteps,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.likedByUser,
    required this.savedByUser,
    required this.commentsCount,
    required this.likedCount,
    required this.savedCount,
    required this.user,
    required this.likes,
    required this.comments,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    var likesList = ((json['likes'] ?? []) as List)
        .map((like) => Like.fromJson(like))
        .toList();
    var commentsList = ((json['comments'] ?? []) as List)
        .map((comment) => CommentModel.fromJson(comment))
        .toList();

    List<String> imageList = List<String>.from(json['images'] ?? []);
    if (imageList.isNotEmpty) {
      imageList = imageList.map((path) {
        if (path.contains('public')) {
          return path; // URL is already complete in JSON
        } else {
          final updatedPath = path.replaceAll('uploads', 'public/uploads');
          return updatedPath;
        }
      }).toList();
    }
    return Recipe(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      preparationSteps: json['preparation_steps'] ?? '',
      images: imageList,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      likedByUser: json['liked_by_user'],
      savedByUser: json['saved_by_user'],
      commentsCount: json['comments_count'],
      likedCount: json['liked_count'],
      savedCount: json['saved_count'],
      user: User.fromJson(json['user'] ?? {}),
      likes: likesList,
      comments: commentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'category': category,
      'preparation_steps': preparationSteps,
      'images': jsonEncode(images),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'liked_by_user': likedByUser,
      'saved_by_user': savedByUser,
      'comments_count': commentsCount,
      'liked_count': likedCount,
      'saved_count': savedCount,
      'user': user.toJson(),
      'likes': likes.map((like) => like.toJson()).toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String contactNumber;
  final String profileImage;
  final String username;
  final bool isPrivate;
  final String about;
  final String dogType;
  final String breed;
  final int age;
  final bool isActive;
  final double weight;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.profileImage,
    required this.username,
    required this.isPrivate,
    required this.about,
    required this.dogType,
    required this.breed,
    required this.age,
    required this.isActive,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String profileImage = json['profile_image'] != null
        ? ApiEndpoints.baseImageUrl + json['profile_image']
        : 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      profileImage: profileImage,
      username: json['username'] ?? '',
      isPrivate: json['is_private'] == 1,
      about: json['about'] ?? '',
      dogType: json['dog_type'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      isActive: json['is_active'] == 1,
      weight: (json['weight'] ?? 0).toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact_number': contactNumber,
      'profile_image': profileImage,
      'username': username,
      'is_private': isPrivate ? 1 : 0,
      'about': about,
      'dog_type': dogType,
      'breed': breed,
      'age': age,
      'is_active': isActive ? 1 : 0,
      'weight': weight,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Like {
  final int id;
  final int userId;
  final int recipeId;
  final String createdAt;
  final String updatedAt;

  Like({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      userId: json['user_id'],
      recipeId: json['recipe_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'recipe_id': recipeId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class MyRecipe {
  final int id;
  final int userId;
  final String name;
  final String category;
  final String preparationSteps;
  final List<String> images;
  final String createdAt;
  final String updatedAt;
  final int likesCount;
  int commentsCount;
  final int savesCount;
  final List<Like> likes;
  final bool likedByUser;
  final bool savedByUser;
  final List<CommentModel> comments;

  MyRecipe({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.preparationSteps,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.likedByUser,
    required this.savedByUser,
    required this.commentsCount,
    required this.savesCount,
    required this.likes,
    required this.comments,
  });

  factory MyRecipe.fromJson(Map<String, dynamic> json) {
    var likesList = ((json['likes'] ?? []) as List)
        .map((like) => Like.fromJson(like))
        .toList();
    var commentsList = ((json['comments'] ?? []) as List)
        .map((comment) => CommentModel.fromJson(comment))
        .toList();

    List<String> imageList = List<String>.from(json['images'] ?? []);
    if (imageList.isNotEmpty) {
      imageList = imageList.map((path) {
        if (path.contains('public')) {
          log(path);
          return path; // URL is already complete in JSON
        } else {
          final updatedPath = path.replaceAll('uploads', 'public/uploads');
          log(updatedPath);
          return updatedPath;
        }
      }).toList();
    }

    return MyRecipe(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      preparationSteps: json['preparation_steps'] ?? '',
      images: imageList,
      likedByUser: json['liked_by_user'],
      savedByUser: json['saved_by_user'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      savesCount: json['saves_count'] ?? 0,
      likes: likesList,
      comments: commentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'category': category,
      'preparation_steps': preparationSteps,
      'images': images,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'saves_count': savesCount,
      'liked_by_user': likedByUser,
      'saved_by_user': savedByUser,
      'likes': likes.map((like) => like.toJson()).toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
