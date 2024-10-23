// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/api_error.dart';
import 'package:foodly_restaurant/models/sucess_model.dart';
import 'package:foodly_restaurant/views/home/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:foodly_restaurant/models/environment.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VoucherController extends GetxController {
  final box = GetStorage();
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void addVoucher(String voucherItem) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    Uri url = Uri.parse('${Environment.appBaseUrl}/api/vouchers');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: voucherItem,
      );

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        setLoading = false;
        Get.snackbar(data.message, "Voucher successfully added",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));
        Get.to(() => const HomePage(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to add Voucher, please try again",
            backgroundColor: kRed, icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to add Voucher, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void updateVoucher(String voucherItem, String id) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    Uri url = Uri.parse('${Environment.appBaseUrl}/api/vouchers/update/$id');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: voucherItem,
      );

      if (response.statusCode == 200) {
        var data = successResponseFromJson(response.body);
        setLoading = false;
        Get.snackbar(data.message, "Voucher successfully updated",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));
        Get.back();
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(
            data.message, "Failed to update vouchers, please try again",
            backgroundColor: kRed, icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to update vouchers, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void confirmDeleteVoucher(String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: kPrimary, // Set the background color to kPrimary
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(color: Colors.white), // White text for the title
        ),
        content: const Text(
          'Are you sure you want to delete this voucher?',
          style: TextStyle(color: Colors.white), // White text for the content
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // Perform the product deletion
              deleteVoucher(id);
              Get.back(); // Close the dialog
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void deleteVoucher(String id) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    Uri url = Uri.parse('${Environment.appBaseUrl}/api/vouchers/delete/$id');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var data = successResponseFromJson(response.body);
        setLoading = false;
        Get.snackbar(data.message, "Voucher successfully delete",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));
        Get.back();
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to delete Voucher, please try again",
            backgroundColor: kRed, icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to delete Voucher, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
