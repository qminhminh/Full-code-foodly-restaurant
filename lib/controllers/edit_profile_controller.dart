// ignore_for_file: prefer_is_empty, prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfileController extends GetxController {
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();
  var logoFile = Rxn<File>();

  RxString _logoUrl = ''.obs;

  String get logoUrl => _logoUrl.value;

  set logoUrl(String value) {
    _logoUrl.value = value;
  }

  RxBool _statusRes = false.obs;

  bool get statusRes => _statusRes.value;

  set statusRes(bool value) {
    _statusRes.value = value;
  }

  RxString _genderres = ''.obs;

  String get genderres => _genderres.value;

  set genderres(String value) {
    _genderres.value = value;
  }

  RxString birthday = ''.obs;
  String get day {
    var parts = birthday.value.split(' ');
    return parts.length > 0 ? parts[0] : '1'; // Trả về '1' nếu không có giá trị
  }

  String get month {
    var parts = birthday.value.split(' ');
    return parts.length > 1
        ? parts[1]
        : 'January'; // Trả về 'January' nếu không có giá trị
  }

  String get year {
    var parts = birthday.value.split(' ');
    return parts.length > 2
        ? parts[2]
        : DateTime.now()
            .year
            .toString(); // Trả về năm hiện tại nếu không có giá trị
  }

  Future<void> pickImage() async {
    // Show dialog to choose source
    final source = await _showImageSourceDialog();
    if (source != null) {
      final pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) {
        logoFile.value = File(pickedImage.path);
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        title: const Text('Choose Image Source'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Get.back(result: ImageSource.gallery),
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Get.back(result: null),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> uploadImageToFirebase() async {
    if (logoFile.value == null) return;
    try {
      String fileName =
          'profiles/${DateTime.now().millisecondsSinceEpoch}_${logoFile.value!.path.split('/').last}';
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .putFile(logoFile.value!);
      logoUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading: $e");
    }
  }

  Future<void> updateProfile(String uid, String name, String phone, bool status,
      String image, String gender, String birthday) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    Uri url =
        Uri.parse('${Environment.appBaseUrl}/api/users/update-profile-res');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'id': uid,
          'name': name,
          'phone': phone,
          'status': status,
          'image': image,
          'gender': gender,
          'birthday': birthday
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check));
        Get.back();
      } else {
        Get.snackbar('Error', 'Failed to update profile, please try again',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      debugPrint("Error deleting: $e");
    }
  }

  Future<void> getProfile(String id) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    Uri url =
        Uri.parse('${Environment.appBaseUrl}/api/users/get-profile-res/$id');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        statusRes = data['profile']['status'];
        genderres = data['profile']['gender'];
        birthday.value = data['profile']['birthday'];
      } else {
        Get.snackbar('Error', 'Failed to update profile, please try again',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      debugPrint("Error deleting: $e");
    }
  }
}
