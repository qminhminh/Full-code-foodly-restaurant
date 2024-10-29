import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/hooks/fetch_chat_user.dart';
import 'package:foodly_restaurant/models/user_chat_model.dart';
import 'package:foodly_restaurant/views/home/widgets/chat_title.dart';

class ChatWith extends HookWidget {
  const ChatWith({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchChatUser();
    final chatsuer = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: AppBar(
        elevation: .4,
        backgroundColor: kLightWhite,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.grid_view),
          ),
        ],
        title: ReusableText(
            text: "Chat with ", style: appStyle(16, kGray, FontWeight.w600)),
      ),
      body: isLoading
          ? const FoodsListShimmer()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              height: hieght,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: chatsuer.length,
                  itemBuilder: (context, i) {
                    UserChat chattitle = chatsuer[i];
                    return ChatTile(itemuser: chattitle);
                  }),
            ),
    );
  }
}
