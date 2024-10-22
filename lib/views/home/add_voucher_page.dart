// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_btn.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/voucher_request.dart';
import 'package:foodly_restaurant/views/auth/widgets/email_textfield.dart';
import 'package:foodly_restaurant/views/home/widgets/back_ground_container.dart';
import 'package:get/get.dart';

import '../../controllers/restaurant_controller.dart';
import '../../controllers/voucher_controller.dart';

class AddVoucher extends StatefulWidget {
  const AddVoucher({super.key});

  @override
  State<AddVoucher> createState() => _AddVoucherState();
}

class _AddVoucherState extends State<AddVoucher> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _discount = TextEditingController();
  bool _switch = false;

  @override
  Widget build(BuildContext context) {
    final voucherController = Get.put(VoucherController());
    final restaurantController = Get.put(RestaurantController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: kPrimary,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 5.w),
          height: 50.h,
          child: Text(
            "Add Voucher",
            style: appStyle(24, kPrimary, FontWeight.bold),
          ),
        ),
      ),
      body: BackGroundContainer(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      ReusableText(
                        text: "Add Title",
                        style: appStyle(16, kGray, FontWeight.w600),
                      ),
                      ReusableText(
                        text:
                            "You are required to fill all the title fields with correct information",
                        style: appStyle(11, kGray, FontWeight.normal),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      EmailTextField(
                        hintText: "Discount Code Shop",
                        controller: _title,
                        prefixIcon: Icon(
                          Ionicons.time_outline,
                          color: Theme.of(context).dividerColor,
                          size: 20.h,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ReusableText(
                        text: "Add Description",
                        style: appStyle(16, kGray, FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      EmailTextField(
                        hintText: "Description of the food item ",
                        controller: _description,
                        prefixIcon: Icon(
                          Ionicons.time_outline,
                          color: Theme.of(context).dividerColor,
                          size: 20.h,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ReusableText(
                        text: "Add Discount",
                        style: appStyle(16, kGray, FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      EmailTextField(
                        hintText: "33%",
                        controller: _discount,
                        prefixIcon: Icon(
                          Ionicons.time_outline,
                          color: Theme.of(context).dividerColor,
                          size: 20.h,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          ReusableText(
                            text: "Open or Close Discount",
                            style: appStyle(16, kGray, FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Switch(
                            value: _switch,
                            onChanged: (value) {
                              setState(() {
                                _switch = value;
                              });
                            },
                            activeColor: kPrimary,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      CustomButton(
                        text: "S U B M I T",
                        color: kPrimary,
                        btnHieght: 40,
                        btnWidth: width / 2.5,
                        onTap: () {
                          if (_title.text.isEmpty ||
                              _description.text.isEmpty ||
                              _discount.text.isEmpty) {
                            Get.snackbar("Error", "Please enter a valid value",
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            VoucherModel voucher = VoucherModel(
                              title: _title.text,
                              description: _description.text,
                              discount: int.parse(_discount.text),
                              addVoucherSwitch:
                                  _switch, // This should now work properly
                              restaurant: restaurantController.restaurant!.id,
                            );
                            String json = voucherModelToJson(voucher);
                            voucherController.addVoucher(json);
                            _title.clear();
                            _description.clear();
                            _discount.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
