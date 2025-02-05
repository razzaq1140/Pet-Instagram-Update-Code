import 'dart:developer';
import 'package:flutter/material.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/shared_preferences_helper.dart';
import '/src/features/buyer_and_seller/buyer/pages/repository/product_repository.dart';
import '../../../../../models/cart_model.dart';
import '../../../../../models/order_response_model.dart';
import '/src/models/product_model.dart';
import '../../../../../models/products_feed_model.dart';
import 'package:pet_project/src/models/cart_Item_update_response_mc.dart';
import 'package:pet_project/src/models/cart_summary_response_mc.dart';
import '../../../../../models/checkout_response_model.dart';

class ProductController extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Product> products = [];
  Pagination? pagination;
  bool _isLoading = false;
  bool isFetchingMore = false;
  String? _errorMessage;
  List<Map<String, dynamic>>? _categories;
  List<ProductModel>? _catagoriesProducts;
  CartResponse? _cartResponse;
  CheckoutResponse? _checkoutResponse;
  CartSummaryResponse? _cartSummaryResponse;
  CartItemUpdateResponse? _cartItemUpdateResponse;
  OrderNowResponse? _orderNowResponse;

  CartItemUpdateResponse? get cartItemUpdateResponse => _cartItemUpdateResponse;
  CartSummaryResponse? get cartSummary => _cartSummaryResponse;
  CheckoutResponse? get checkoutResponse => _checkoutResponse;
  CartResponse? get cartResponse => _cartResponse;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>>? get categories => _categories;
  List<ProductModel>? get catagoriesProducts => _catagoriesProducts;
  OrderNowResponse? get orderNowResponse => _orderNowResponse;

  Future<void> fetchProducts({bool loadMore = false}) async {
    if (_isLoading || (loadMore && isFetchingMore)) return;

    _isLoading = !loadMore;
    isFetchingMore = loadMore;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final result = await _repository.getProducts(
        accessToken: accessToken,
        nextPageUrl: loadMore ? pagination?.nextPageUrl : null,
      );

      final newProducts = result['products'] as List<Product>;
      final newPagination = result['pagination'] as Pagination;

      if (loadMore) {
        products.addAll(newProducts);
      } else {
        products = newProducts;
      }
      pagination = newPagination;
    } catch (e) {
      _errorMessage = e.toString();
      log('Error fetching products: $e');
    } finally {
      _isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  Future addToCart({
    required int productId,
    required int quantity,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final result = await _repository.postAddToCart(
        accessToken: accessToken,
        productId: productId,
        quantity: quantity,
      );

      if (result != null) {
        final message = result['message'];
        showSnackbar(message: message);
        log('message $message');
      } else {
        log(_errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Error switching profile: $e';
      log(_errorMessage!);
      showSnackbar(message: _errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future fetchCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final result = await _repository.getCart(
        accessToken: accessToken,
      );

      if (result != null) {
        _cartResponse = result;
        log('Fetched Cart Data: ${_cartResponse?.data}');
      } else {
        _errorMessage = 'Error fetching Cart: $_errorMessage';
        log(_errorMessage!);
      }
    } catch (e) {
      _errorMessage = e.toString();
      log('Error fetching Cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkOut({
    required String address,
    required String promoCode,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final result = await _repository.postCheckOut(
        accessToken: accessToken,
        address: address,
        promoCode: promoCode,
      );

      if (result != null) {
        _checkoutResponse = result;

        // showSnackbar(message: result.message);
        log('Checkout successful: Order ID ${result.orderId}');
      } else {
        _errorMessage = 'Error while checking out.';
        log(_errorMessage!);
      }
    } catch (e) {
      _errorMessage = e.toString();
      log('Error while checking out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future payment({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required int orderId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final result = await _repository.postPayment(
        accessToken: accessToken,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
        orderId: orderId,
      );

      if (result != null) {
        final message = result['message'];

        showSnackbar(message: message);
      } else {
        _errorMessage = 'Error while paying: $_errorMessage';
        log(_errorMessage!);
      }
    } catch (e) {
      _errorMessage = e.toString();
      log('Error while paying: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderNowResponse?> buyNow({
    required int productId,
    required int quantity,
    required String address,
    required String promoCode,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      // Call the repository to place the order
      final orderResponse = await _repository.postBuyNow(
        accessToken: accessToken,
        productId: productId,
        quantity: quantity,
        address: address,
        promoCode: promoCode,
      );

      // Check if the response is not null and return it
      if (orderResponse != null) {
        _orderNowResponse = orderResponse;
        return orderResponse; // Return the order response successfully
      } else {
        _errorMessage = 'Error occurred while processing Buy Now';
        log(_errorMessage!);
        return null; // If the response is null, return null
      }
    } catch (e) {
      _errorMessage = 'Error occurred while processing Buy Now: $e';
      log(_errorMessage!);
      showSnackbar(message: _errorMessage!);
      return null; // Return null on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future rateProducts({required int productId, required double rating}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final result = await _repository.postRating(
        accessToken: accessToken,
        productId: productId,
        rating: rating,
      );

      if (result != null) {
        final message = result['message'];

        showSnackbar(message: message);
        log('message: $message');
      } else {
        _errorMessage = 'Error while fetching message : $_errorMessage';
        log(_errorMessage!);
      }
    } catch (e) {
      _errorMessage = e.toString();
      log('Error while fetching message: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future orderStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final result = await _repository.getCart(
        accessToken: accessToken,
      );

      if (result != null) {
        final message = result['message'];
        showSnackbar(message: message);
        log('message: $message');
      } else {
        _errorMessage = 'Error fetching Order Status: $_errorMessage';
        log(_errorMessage!);
      }
    } catch (e) {
      _errorMessage = e.toString();
      log('Error fetching Order Status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future catagories() async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      _categories = await _repository.fetchCategories(accessToken: accessToken);

      log('result $_categories');
    } catch (e) {
      _errorMessage = e.toString();
      log('Error fetching catagories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future productsByCatagories({required int categoryId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final result = await _repository.getProductsByCatagories(
        accessToken: accessToken,
        categoryId: categoryId,
      );

      // Fetch products using repository
      _catagoriesProducts = result;

      log('catagoriesProducts! length: ${_catagoriesProducts!.length.toString()}');
    } catch (e) {
      _errorMessage = 'Failed to fetch products: $e';
      log(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future fetchCartSummary() async {
    _errorMessage = null;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;
      _cartSummaryResponse =
          await _repository.getCartSummary(accessToken: accessToken);

      log("_cartSummaryResponse ${_cartSummaryResponse!.message}");
    } catch (e) {
      _errorMessage = 'Failed to fetch Cart Summary: $e';
      log(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future updateCartItem({required int itemId, required int quantity}) async {
    _errorMessage = null;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      _cartItemUpdateResponse = await _repository.updateCartItemQuantity(
        accessToken: accessToken,
        itemId: itemId,
        quantity: quantity,
      );

      log("_cartItemUpdateResponse: ${_cartItemUpdateResponse!.message}");
    } catch (e) {
      _errorMessage = 'Failed to update cart item quantity: $e';
      _cartItemUpdateResponse = null;
    } finally {
      notifyListeners();
    }
  }
}
