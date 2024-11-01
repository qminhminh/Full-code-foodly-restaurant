// ignore_for_file: unnecessary_const

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_btn.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/common/text_filed.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/edit_profile_controller.dart';
import 'package:foodly_restaurant/controllers/login_response.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.user});
  final LoginResponse user;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final EditProfileController controller = Get.put(EditProfileController());
  late String name;
  late String email;
  late String phone;
  String? gender;
  int? selectedDay;
  String? selectedMonth;
  int? selectedYear;
  bool? _isOnline;

  void _toggleSwitch(bool value) {
    setState(() {
      _isOnline = value; // Update the state
    });
  }

  final List<int> days = List.generate(31, (index) => index + 1);
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<int> years = List.generate(100, (index) => 2024 - index);

  @override
  void initState() {
    super.initState();
    controller.getProfile(widget.user.id).then((_) {
      // Cập nhật sau khi lấy profile xong
      setState(() {
        gender =
            controller.genderres.isNotEmpty ? controller.genderres : 'Male';
        selectedDay =
            int.tryParse(controller.day) ?? 1; // Ép kiểu và xử lý null
        selectedMonth = controller.month.isNotEmpty
            ? controller.month
            : 'January'; // Lấy tháng
        selectedYear = int.tryParse(controller.year) ??
            DateTime.now().year; // Ép kiểu cho năm
        _isOnline = controller.statusRes; // Lấy trạng thái online
      });
    });

    name = widget.user.username;
    email = widget.user.email;
    phone = widget.user.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 5.w),
          height: 50.h,
          child: Text(
            "Edit Profile",
            style: appStyle(24, kPrimary, FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            SizedBox(
              height: 135,
              width: 135,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: Container(
                        color: Colors.grey.shade100,
                        child: controller.logoUrl == ''
                            ? Image.network(
                                widget.user.profile,
                                fit: BoxFit.cover,
                                width: 235,
                                height: 235,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Feather
                                        .user, // Default icon in case of image load failure
                                    size: 50,
                                    color: Colors.grey,
                                  );
                                },
                              )
                            : Image.network(
                                controller.logoUrl,
                                fit: BoxFit.cover,
                                width: 235,
                                height: 235,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Feather
                                        .user, // Default icon in case of image load failure
                                    size: 50,
                                    color: Colors.grey,
                                  );
                                },
                              )),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.pickImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ReusableText(
                text: "Username",
                style: appStyle(18, Colors.black, FontWeight.bold)),
            const SizedBox(height: 10),
            CTextField(
              hintText: "Username",
              initialValue: name,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              prefixIcon: Icon(
                CupertinoIcons.person,
                color: Theme.of(context).dividerColor,
                size: 20.h,
              ),
              keyboardType: TextInputType.text,
            ),

            // Phone
            const SizedBox(height: 10),
            ReusableText(
                text: "Phone",
                style: appStyle(18, Colors.black, FontWeight.bold)),
            const SizedBox(height: 10),
            CTextField(
              hintText: "Phone",
              initialValue: phone,
              onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
              prefixIcon: Icon(
                CupertinoIcons.phone,
                color: Theme.of(context).dividerColor,
                size: 20.h,
              ),
              keyboardType: TextInputType.text,
            ),
            // Switch

            const SizedBox(height: 20),
            ReusableText(
                text: "Gender",
                style: appStyle(18, Colors.black, FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ReusableText(
                text: "Date of birth",
                style: appStyle(18, Colors.black, FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      value: selectedDay,
                      items: days.map((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(day.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDay = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedMonth,
                      items: months.map((month) {
                        return DropdownMenuItem(
                          value: month,
                          child: Text(month),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: DropdownButton<int>(
                      value: selectedYear,
                      items: years.map((year) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ReusableText(
                  text: "Online",
                  style: appStyle(18, Colors.black, FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: _isOnline ?? false, // Use the switch state variable
                  onChanged: _toggleSwitch, // Update state on switch change
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
                btnHieght: 37.h,
                color: kPrimary,
                text: "S A V E",
                onTap: () {
                  controller.updateProfile(
                      widget.user.id,
                      name,
                      phone,
                      _isOnline!,
                      controller.logoUrl == ''
                          ? widget.user.profile
                          : controller.logoUrl,
                      gender!,
                      "${selectedDay.toString()} $selectedMonth $selectedYear");
                }),
          ],
        ),
      ),
    );
  }
}
