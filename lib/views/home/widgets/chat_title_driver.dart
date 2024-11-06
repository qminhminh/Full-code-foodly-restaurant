// ignore_for_file: unnecessary_null_comparison, unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/models/user.dart';
import 'package:foodly_restaurant/views/home/widgets/chat_driver.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChatTileDriver extends HookWidget {
  const ChatTileDriver({
    super.key,
    required this.driver,
  });

  final User driver;

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    late final String uid = box.read("restaurantId").replaceAll('"', '');
    final messages = useState<List<dynamic>>([]);
    final isLoading = useState(false);
    final error = useState<Exception?>(null);

    Future<void> fetchData() async {
      isLoading.value = true;
      try {
        final url = Uri.parse(
            '${Environment.appBaseUrl}/api/chats/messages-driver-res/$uid/${driver.id}');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          messages.value = json.decode(response.body);
        } else {
          throw Exception('Failed to load messages');
        }
      } catch (e) {
        error.value = e as Exception?;
      } finally {
        isLoading.value = false;
      }
    }

    // Gọi fetchData khi build lần đầu
    useEffect(() {
      fetchData();
      return null;
    }, const []);

    // Lấy tin nhắn cuối cùng chưa đọc
    final lastUnreadMessage = messages.value.isNotEmpty
        ? messages.value.lastWhere(
            (msg) => msg['isRead'] == 'unread' && msg['sender'] != uid,
            orElse: () => null,
          )
        : null;
    return GestureDetector(
      onTap: () async {
        final result = await Get.to(
          () => ChatDriver(driver: driver),
          duration: const Duration(milliseconds: 300),
          transition: Transition.fadeIn,
        );

        if (result == true) {
          fetchData();
        }
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
                            driver.profile,
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
                          text: driver.username,
                          style: appStyle(16, kDark, FontWeight.w400)),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          if (lastUnreadMessage !=
                              null) // Chỉ hiển thị khi có tin chưa đọc
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 8), // Khoảng cách giữa tin nhắn và nhãn
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape
                                    .circle, // Đặt hình dạng bo tròn hoàn toàn
                              ),
                            ),
                          const SizedBox(
                            width: 1,
                          ),
                          Text(
                            lastUnreadMessage != null
                                ? "${lastUnreadMessage!['message']}"
                                : "No new messages",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(
                              13,
                              lastUnreadMessage != null
                                  ? Colors.grey
                                  : Colors.black,
                              FontWeight.w400,
                            ),
                          ),
                        ],
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
