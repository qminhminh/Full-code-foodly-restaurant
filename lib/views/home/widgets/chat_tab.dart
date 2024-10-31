import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/tab_controller.dart';
import 'package:foodly_restaurant/views/home/chat_with_driver.dart';
import 'package:foodly_restaurant/views/home/widgets/back_ground_container.dart';

import 'package:get/get.dart';

import '../chat_with_customer.dart';

class ChatTab extends StatefulHookWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    final tabController = Get.put(MainScreenController());
    _tabController.animateTo(tabController.tabIndex);

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
              text: "Chat with ...",
              style: appStyle(12, kGray, FontWeight.w600)),
        ),
        body: BackGroundContainer(
          child: SizedBox(
            height: hieght,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Container(
                    height: 25.h,
                    width: width,
                    decoration: BoxDecoration(
                      color: kOffWhite,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Center(
                      // Đảm bảo TabBar được căn giữa trong Container
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        labelPadding: EdgeInsets.zero,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.withOpacity(0.7),
                        labelStyle:
                            appStyle(12, kLightWhite, FontWeight.normal),
                        tabs: const <Widget>[
                          Tab(
                            child: Align(
                              alignment:
                                  Alignment.center, // Căn giữa text trong Tab
                              child: Text(
                                "Customer",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment:
                                  Alignment.center, // Căn giữa text trong Tab
                              child: Text(
                                "Driver",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    height: height * 0.7,
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        ChatWithCustomer(),
                        ChatWithDriver(),
                      ],
                    ),
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
