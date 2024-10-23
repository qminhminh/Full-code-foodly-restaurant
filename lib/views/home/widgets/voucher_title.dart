// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/vouchers.dart';

class CategoryVoucherTitle extends StatelessWidget {
  const CategoryVoucherTitle({super.key, required this.voucher, this.onTap});
  final Voucher voucher;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 80.h,
            width: width,
            decoration: const BoxDecoration(
                color: kLightWhite,
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 80.h,
                          width: 80.h,
                          child: SvgPicture.asset(
                            "assets/icons/vouvher.svg",
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.only(left: 2, bottom: 2),
                            color: kGray.withOpacity(0.6),
                            height: 16,
                            width: width,
                            child: ReusableText(
                              text: voucher.title,
                              style: appStyle(11, kGray, FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                        text: voucher.title,
                        style: appStyle(16, kGray, FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Feather.percent,
                            size: 14,
                            color: kPrimary,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ReusableText(
                            text: 'Discount: ${voucher.discount.toString()}%',
                            style: appStyle(14, kGray, FontWeight.w500),
                          ),
                        ],
                      ),
                      ReusableText(
                        text:
                            'Work: ${voucher.addVoucherSwitch ? 'On' : 'Off'}',
                        style: appStyle(14, Colors.red, FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 70.h,
            top: 6.h,
            child: Container(
              width: 19.h,
              height: 19.h,
              decoration: const BoxDecoration(
                  color: kSecondary,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: GestureDetector(
                onTap: () {},
                child: const Center(
                  child: Icon(
                    MaterialCommunityIcons.file_document_edit,
                    size: 15,
                    color: kLightWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
