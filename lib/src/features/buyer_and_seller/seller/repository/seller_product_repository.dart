import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../../buyer/model/product_category_model.dart';
import '/src/core/api_endpoints.dart';
import '/src/core/api_helper.dart';
import '/src/models/product_model.dart';

class SellerProductRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<bool> addProduct(
      {required List<File> files, required Map<String, String> data}) async {
    try {
      final response = await _apiHelper.postFilesWithDataRequest(
        endpoint: ApiEndpoints.products,
        data: data,
        key: 'images[]',
        files: files,
      );

      // final response = await request.send();
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('message');
        return true;
      } else {
        log(await response.stream.bytesToString());
        return false;
      }
    } catch (e) {
      log('Error : $e');
      return false;
    }
  }

  Future<List<ProductModel>> gerAllProducts() async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: ApiEndpoints.products,
      );
      log("response is $response");
      // final response = await request.send();
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        final List data = responseBody['data'];
        log("$data");
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      log('Error : $e');
      return [];
    }
  }

  Future<List<ProductCategoryModel>> getAllCategories() async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: ApiEndpoints.categories,
      );
      log("response is $response");
      // final response = await request.send();
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        final List data = responseBody['data'];
        log("$data");
        return data.map((json) => ProductCategoryModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      log('Error : $e');
      return [];
    }
  }
}
