// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/api_error.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/models/hook_models/restaurant_data.dart';
import 'package:foodly_restaurant/models/restaurant_data.dart';
import 'package:http/http.dart' as http;

FetchRestaurantData fetchRestaurant(
  String id,
) {
  final restaurant = useState<Data?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<ApiError?>(null);
  final ordersTotal = useState<int>(0);
  final cancelledOrders = useState<int>(0);
  final payout = useState<List<LatestPayout>>([]);
  final revenueTotal = useState<double>(0);
  final processingOrders = useState<int>(0);
  final restaurantToken = useState<String>('');
  final appiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url =
          Uri.parse('${Environment.appBaseUrl}/api/restaurant/statistics/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Statistics data = statisticsFromJson(response.body);
        restaurant.value = data.data;
        ordersTotal.value = data.ordersTotal;
        cancelledOrders.value = data.cancelledOrders;
        revenueTotal.value = data.revenueTotal.toDouble();
        processingOrders.value = data.processingOrders;
        payout.value = data.latestPayout;
      } else {
        appiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchRestaurantData(
    restaurant: restaurant.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
    ordersTotal: ordersTotal.value,
    cancelledOrders: cancelledOrders.value,
    revenueTotal: revenueTotal.value,
    processingOrders: processingOrders.value,
    restaurantToken: restaurantToken.value,
    payout: payout.value,
  );
}
