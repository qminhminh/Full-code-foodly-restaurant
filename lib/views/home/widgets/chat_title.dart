// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/user_chat_model.dart';
import 'package:foodly_restaurant/views/home/widgets/message.dart';
import 'package:get/get.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.itemuser,
  });

  final UserChat itemuser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => Message(item: itemuser),
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
                            itemuser.customerId.profile,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                        text: itemuser.customerId.username,
                        style: appStyle(16, kDark, FontWeight.w400),
                      ),
                      ReusableText(
                        text: "Email: ${itemuser.customerId.email}",
                        style: appStyle(14, kGray, FontWeight.w400),
                      ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      SizedBox(
                        width: width * 0.7,
                        child: Text(
                          "UserType: ${itemuser.customerId.userType}",
                          overflow: TextOverflow.ellipsis,
                          style: appStyle(14, kGray, FontWeight.w400),
                        ),
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
        ],
      ),
    );
  }
}
