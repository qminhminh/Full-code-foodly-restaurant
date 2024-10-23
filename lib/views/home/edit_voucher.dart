import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_btn.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/voucher_controller.dart';
import 'package:foodly_restaurant/models/voucher_request.dart';
import 'package:foodly_restaurant/models/vouchers.dart';
import 'package:get/get.dart';

class EditVoucherPage extends StatefulWidget {
  const EditVoucherPage({super.key, required this.voucher});
  final Voucher voucher;

  @override
  State<EditVoucherPage> createState() => _EditVoucherPageState();
}

class _EditVoucherPageState extends State<EditVoucherPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController discountController;

  bool addVoucherSwitch = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.voucher.title);
    descriptionController =
        TextEditingController(text: widget.voucher.description);
    discountController =
        TextEditingController(text: widget.voucher.discount.toString());
    addVoucherSwitch = widget.voucher.addVoucherSwitch;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voucherController = Get.put(VoucherController());
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Edit Voucher', style: appStyle(20, kDark, FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Ionicons.chevron_back_circle, color: kPrimary),
          onPressed: () => Get.back(),
        ),
        backgroundColor: kLightWhite,
        elevation: 0,
      ),
      backgroundColor: kLightWhite,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20.h),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: appStyle(16, kGray, FontWeight.w400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: appStyle(16, kGray, FontWeight.w400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Discount (%)',
                  labelStyle: appStyle(16, kGray, FontWeight.w400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a discount percentage';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid discount percentage';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                    text: 'Voucher Active',
                    style: appStyle(18, kDark, FontWeight.w600),
                  ),
                  Switch(
                    value: addVoucherSwitch,
                    onChanged: (bool newValue) {
                      setState(() {
                        addVoucherSwitch = newValue;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              CustomButton(
                text: "SAVE",
                color: kPrimary,
                btnHieght: 45.h,
                btnWidth: double.infinity,
                radius: 10,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    VoucherModel vochermodel = VoucherModel(
                      title: titleController.text,
                      description: descriptionController.text,
                      discount: int.parse(discountController.text),
                      addVoucherSwitch: addVoucherSwitch,
                      restaurant: widget.voucher.restaurant,
                    );

                    String voucherItem = voucherModelToJson(vochermodel);
                    voucherController.updateVoucher(
                        voucherItem, widget.voucher.id);

                    Get.back(); // Go back after saving
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
