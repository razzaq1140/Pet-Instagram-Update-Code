import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../buyer/model/product_category_model.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/features/buyer_and_seller/seller/repository/seller_product_repository.dart';
import '/src/models/product_model.dart';

class SellerProductController extends ChangeNotifier {
  final SellerProductRepository _sellerProductRepository =
      SellerProductRepository();

  bool isLoading = false;
  List<ProductModel> sellerProductsList = [];
  List<ProductCategoryModel> categories = [];

  toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> addProduct({
    required List<File> files,
    required Map<String, String> data,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    var overlay = context.loaderOverlay;
    overlay.show();
    try {
      bool? isDone =
          await _sellerProductRepository.addProduct(files: files, data: data);
      if (isDone == true) {
        onSuccess('Product Added');
      } else if (isDone == false) {
        onError('Failed to set name, please try again!');
      } else {
        onError('Try a different username!');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
      overlay.hide();
    }
  }

  Future<void> getAllProducts({
    required BuildContext context,
  }) async {
    var overlay = context.loaderOverlay;
    overlay.show();
    try {
      final result = await _sellerProductRepository.gerAllProducts();
      if (result.isNotEmpty) {
        sellerProductsList = result;
      }
    } catch (e) {
      showSnackbar(message: e.toString(), isError: true);
    } finally {
      notifyListeners();
      overlay.hide();
    }
  }

  Future<void> getProductCategories({
    required BuildContext context,
  }) async {
    var overlay = context.loaderOverlay;
    overlay.show();
    try {
      final result = await _sellerProductRepository.getAllCategories();
      if (result.isNotEmpty) {
        categories = result;
      }
    } catch (e) {
      showSnackbar(message: e.toString(), isError: true);
    } finally {
      notifyListeners();
      overlay.hide();
    }
  }
}
