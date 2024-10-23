import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_restaurant/models/api_error.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/models/hook_models/hook_result.dart';
import 'package:foodly_restaurant/models/vouchers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

FetchHook useFetchVoucher() {
  final box = GetStorage();
  final vouchers = useState<List<Voucher>?>([]);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    String restaurantId = box.read('restaurantId');

    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          '${Environment.appBaseUrl}/api/vouchers/restaurant/get-all-vouchers/$restaurantId'));

      if (response.statusCode == 200) {
        vouchers.value = voucherFromJson(response.body);
      } else {
        var data = apiErrorFromJson(response.body);
        error.value = Exception(data.message);
        Get.snackbar(data.message, "Failed to get data, please try again",
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.fastfood_outlined));
      }
    } catch (e) {
      error.value = Exception('An error occurred: ${e.toString()}');
      Get.snackbar(e.toString(), "Failed to get data, please try again",
          snackPosition: SnackPosition.BOTTOM, icon: const Icon(Icons.error));
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: vouchers.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
