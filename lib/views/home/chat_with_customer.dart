import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/hooks/fecthAllCustomer.dart';
import 'package:foodly_restaurant/models/user.dart';
import 'package:foodly_restaurant/views/home/widgets/chat_title_customer.dart';
import '../../common/shimmers/foodlist_shimmer.dart';

class ChatWithCustomer extends HookWidget {
  const ChatWithCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllCustomer();
    final driver = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      body: isLoading
          ? const FoodsListShimmer()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              height: hieght,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: driver.length,
                  itemBuilder: (context, i) {
                    User currentCustomer = driver[i];
                    return ChatTileCustomer(customer: currentCustomer);
                  }),
            ),
    );
  }
}
