// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_btn.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/voucher_controller.dart';
import 'package:foodly_restaurant/models/vouchers.dart';
import 'package:foodly_restaurant/views/home/edit_voucher.dart';
import 'package:get/get.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key, required this.voucher});
  final Voucher voucher;
  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  @override
  Widget build(BuildContext context) {
    final voucherController = Get.put(VoucherController());

    return Scaffold(
      backgroundColor: kLightWhite,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Stack(
            children: [
              SizedBox(
                height: 230.h,
                child: Container(
                  height: 230.h,
                  width: width,
                  color: kLightWhite,
                  child: SvgPicture.asset(
                    "assets/icons/vouvher.svg",
                    width: 40.w,
                    height: 40.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 40.h,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Ionicons.chevron_back_circle,
                        color: kPrimary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                right: 15,
                child: CustomButton(
                  btnWidth: width / 2.9,
                  radius: 30,
                  color: kPrimary,
                  onTap: () {
                    Get.to(
                        () => EditVoucherPage(
                              voucher: widget.voucher,
                            ),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 400));
                  },
                  text: "Edit Voucher",
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(
                      text: widget.voucher.title,
                      style: appStyle(22, kDark, FontWeight.w600),
                    ),
                    ReusableText(
                      text: "\$ ${widget.voucher.discount.toString()} %",
                      style: appStyle(22, kPrimary, FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  widget.voucher.description,
                  maxLines: 8,
                  style: appStyle(19, kGray, FontWeight.w400),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(
                      text: 'Status: ',
                      style: appStyle(22, kDark, FontWeight.w600),
                    ),
                    ReusableText(
                      text: "${widget.voucher.addVoucherSwitch ? 'On' : 'Off'}",
                      style: appStyle(22, kPrimary, FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: CustomButton(
              text: "D E L E T E",
              onTap: () {
                voucherController.confirmDeleteVoucher(widget.voucher.id);
              },
              color: kRed,
              btnHieght: 35,
            ),
          )
        ],
      ),
    );
  }
}
