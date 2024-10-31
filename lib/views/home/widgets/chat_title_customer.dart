// ignore_for_file: unnecessary_null_comparison, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/user.dart';
import 'package:foodly_restaurant/views/home/widgets/chat_customer.dart';
import 'package:get/get.dart';

class ChatTileCustomer extends StatelessWidget {
  const ChatTileCustomer({
    super.key,
    required this.customer,
  });

  final User customer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ChatCustomer(customer: customer),
          duration: const Duration(milliseconds: 300),
          transition: Transition.fadeIn,
        );
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 70,
            width: width,
            decoration: const BoxDecoration(
                color: kOffWhite,
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
                          height: 70.h,
                          width: 70.w,
                          child: Image.network(
                            customer.profile,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(
                                Icons.error,
                                color: kPrimary,
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.only(left: 6, bottom: 2),
                            color: kGray.withOpacity(0.6),
                            height: 16,
                            width: 70.w,
                            child: RatingBarIndicator(
                              rating: 5,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 15.0,
                              direction: Axis.horizontal,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                          text: customer.username,
                          style: appStyle(11, kDark, FontWeight.w400)),
                      ReusableText(
                          text: "${customer.email}",
                          style: appStyle(9, kGray, FontWeight.w400)),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      SizedBox(
                        width: width * 0.7,
                        child: Text(customer.phone,
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(9, kGray, FontWeight.w400)),
                      ),
                      const SizedBox(
                        height: 5,
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
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: GestureDetector(
                onTap: () {},
                child: const Center(
                  child: Icon(
                    MaterialCommunityIcons.shopping_outline,
                    size: 15,
                    color: kLightWhite,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
