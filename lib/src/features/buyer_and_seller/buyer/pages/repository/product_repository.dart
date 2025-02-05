import 'dart:convert';
import 'dart:developer';
import '/src/core/api_helper.dart';
import '../../../../../models/cart_model.dart';
import '../../../../../models/order_response_model.dart';
import '../../../../../models/checkout_response_model.dart';
import '/src/models/product_model.dart';
import '../../../../../models/products_feed_model.dart';
import 'package:pet_project/src/common/utils/custom_snackbar.dart';
import 'package:pet_project/src/models/cart_Item_update_response_mc.dart';
import 'package:pet_project/src/models/cart_summary_response_mc.dart';

class ProductRepository {
  final ApiHelper _apiHelper = ApiHelper();
  final String baseUrl = 'https://pet-insta.nextwys.com/api';

  Future<Map<String, dynamic>> getProducts({
    required String accessToken,
    String? nextPageUrl,
  }) async {
    String url = nextPageUrl ?? '$baseUrl/products/feed';

    final response = await _apiHelper.getRequest(
      endpoint: url,
      authToken: accessToken,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final products = (data['data']['data'] as List)
          .map((item) => Product.fromJson(item))
          .toList();

      final pagination = Pagination.fromJson(data['data']);

      return {'products': products, 'pagination': pagination};
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future postAddToCart({
    required String accessToken,
    required int productId,
    required int quantity,
  }) async {
    // data
    final data = {
      "product_id": productId,
      "quantity": quantity,
    };

    try {
      final response = await _apiHelper.postRequest(
        endpoint: '$baseUrl/cart/add',
        authToken: accessToken,
        data: data,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log('Add To Cart ResponseBody $responseBody');
        return responseBody;
      } else {
        return responseBody;
      }
    } catch (e) {
      return "An error occurred while adding to cart";
    }
  }

  Future getCart({
    required String accessToken,
  }) async {
    String url = '$baseUrl/user/carts';

    final response = await _apiHelper.getRequest(
      endpoint: url,
      authToken: accessToken,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      log('data: $data');

      return CartResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch Cart');
    }
  }

  Future<CheckoutResponse?> postCheckOut({
    required String accessToken,
    required String address,
    required String promoCode,
  }) async {
    final data = {
      "address": address,
      "promo_code": promoCode,
    };

    try {
      final response = await _apiHelper.postRequest(
        endpoint: '$baseUrl/cart/checkout',
        authToken: accessToken,
        data: data,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log('checkout: $responseBody');
        return CheckoutResponse.fromMap(responseBody);
      } else {
        log('Error during checkout: $responseBody');
        return null;
      }
    } catch (e) {
      log("An error occurred while checking out: $e");
      return null;
    }
  }

  Future postPayment({
    required String accessToken,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required int orderId,
  }) async {
// data to pass in the body
    final data = {
      "card_number": cardNumber,
      "expiry_date": expiryDate,
      "cvv": cvv,
      "order_id": orderId
    };

    try {
      final response = await _apiHelper.postRequest(
        endpoint: '$baseUrl/payment',
        authToken: accessToken,
        data: data,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log('Payment $responseBody');
        return responseBody;
      } else {
        return responseBody;
      }
    } catch (e) {
      log('Error while paying: $e');
      return 'Error while paying: $e';
    }
  }

  Future<OrderNowResponse?> postBuyNow({
    required String accessToken,
    required int productId,
    required int quantity,
    required String address,
    required String promoCode,
  }) async {
    final data = {
      "product_id": productId,
      "quantity": quantity,
      "address": address,
      "promo_code": promoCode,
    };

    try {
      final response = await _apiHelper.postRequest(
        endpoint: '$baseUrl/order/buy',
        authToken: accessToken,
        data: data,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return OrderNowResponse.fromJson(responseBody);
      } else {
        log('Error response: ${response.body}');
        return null;
      }
    } catch (e) {
      log('An error occurred: $e');
      return null;
    }
  }

  Future postRating(
      {required String accessToken,
      required double rating,
      required int productId}) async {
// data
    final data = {"rating": rating};

    try {
      final response = await _apiHelper.postRequest(
        endpoint: '$baseUrl/products/$productId/rate',
        authToken: accessToken,
        data: data,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log('Rating $responseBody');
        return responseBody;
      } else {
        return responseBody;
      }
    } catch (e) {
      return "An error occurred while Rating";
    }
  }

  Future getOrderStatus(
      {required String accessToken, required int orderId}) async {
    String url = '$baseUrl/orders/$orderId/status';

    final response = await _apiHelper.getRequest(
      endpoint: url,
      authToken: accessToken,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("status data: $data");

      return data;
    } else {
      throw Exception('Failed to fetch Order Status');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategories(
      {required String accessToken}) async {
    String url = '$baseUrl/categories';

    final response = await _apiHelper.getRequest(
      endpoint: url,
      authToken: accessToken,
    );

    try {
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];

        log('message: $message');

        return List<Map<String, dynamic>>.from(responseData['data']);
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCatagories({
    required String accessToken,
    required int categoryId,
  }) async {
    String url = '$baseUrl/categories/$categoryId/products';

    final response = await _apiHelper.getRequest(
      endpoint: url,
      authToken: accessToken,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['data'] is List) {
        return (responseData['data'] as List)
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to fetch Products');
    }
  }

  Future<CartSummaryResponse> getCartSummary({
    required String accessToken,
  }) async {
    String url = '$baseUrl/cart/summary';

    final response = await _apiHelper.getRequest(
      endpoint: url,
      authToken: accessToken,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      return CartSummaryResponse.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch Cart Summaray');
    }
  }

  Future<CartItemUpdateResponse> updateCartItemQuantity({
    required String accessToken,
    required int itemId,
    required int quantity,
  }) async {
    String url = '$baseUrl/cart/$itemId';

    final response = await _apiHelper.patchRequest(
      endpoint: url,
      authToken: accessToken,
      data: {'quantity': quantity},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return CartItemUpdateResponse.fromJson(responseData);
    } else {
      throw Exception('Failed to update cart item quantity');
    }
  }

  Future deleteCartItem({
    required String accessToken,
    required int itemId,
  }) async {
    String url = '$baseUrl/cart/$itemId';

    try {
      final response = await _apiHelper.deleteRequest(
        endpoint: url,
      );

      if (response.statusCode == 200) {
        log("Item successfully removed from cart");

        final responseBody = jsonDecode(response.body);

        showSnackbar(message: "${responseBody['message']}");
      } else {
        throw Exception('Failed to remove item from cart');
      }
    } catch (e) {
      throw Exception('An error occurred while deleting cart item: $e');
    }
  }
}
