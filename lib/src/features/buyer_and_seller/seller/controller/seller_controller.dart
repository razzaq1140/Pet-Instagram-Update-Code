import 'dart:developer';

import 'package:flutter/foundation.dart';
import '/src/common/utils/shared_preferences_helper.dart';
import '/src/features/buyer_and_seller/seller/repositroy/seller_repository.dart';
import '../../../../models/seller_center_model.dart';

class SellerController extends ChangeNotifier {
  final SellerRepository _repository = SellerRepository();

  bool isLoading = false;
  String _errorMessage = '';
  SellerDashboard? dashboardData;

  String get errorMessage => _errorMessage;

  Future<void> getSellerDashboard() async {
    isLoading = true;
    // notifyListeners();
    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;
      final response =
          await _repository.getSellerDashboard(accessToken: accessToken);

      if (response != null) {
        // Parse JSON response into SellerDashboard model
        dashboardData = SellerDashboard.fromJson(response);
        log("Fetched seller dashboard: $dashboardData");
      } else {
        _errorMessage = 'Failed to fetch seller dashboard';
        log(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error fetching seller dashboard: $e';
      log(_errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
