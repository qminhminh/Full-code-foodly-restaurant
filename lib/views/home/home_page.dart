// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_appbar.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/common/tab_widget.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/order_controller.dart';
import 'package:foodly_restaurant/controllers/restaurant_controller.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/views/home/add_foods.dart';
import 'package:foodly_restaurant/views/home/add_voucher_page.dart';
import 'package:foodly_restaurant/views/home/foods_page.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/cancelled_orders.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/picked_orders.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/preparing.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/delivered.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/new_orders.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/ready_for_pick_up.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/self_deliveries.dart';
import 'package:foodly_restaurant/views/home/self_delivered_page.dart';
import 'package:foodly_restaurant/views/home/vouchers_page.dart';
import 'package:foodly_restaurant/views/home/wallet_page.dart';
import 'package:foodly_restaurant/views/home/widgets/back_ground_container.dart';
import 'package:foodly_restaurant/views/home/widgets/chat_tab.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulHookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 7,
    vsync: this,
  );
  final box = GetStorage();
  late final String uid = box.read("restaurantId").replaceAll('"', '');

  List<dynamic> messages = [];
  bool isLoading = false;
  String? error;

  // Hàm fetch dữ liệu
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final url =
          Uri.parse('${Environment.appBaseUrl}/api/chats/messages-res/$uid');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          messages = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> navigateToChatTab() async {
    final result = await Get.to(() => const ChatTab(),
        duration: const Duration(milliseconds: 400));

    // Kiểm tra giá trị trả về
    if (result == true) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantController = Get.put(RestaurantController());
    final orderController = Get.put(OrdersController());
    _tabController.animateTo(orderController.tabIndex);
    final countUnreadMessage = messages.isNotEmpty
        ? messages.where((msg) => msg['isRead'] == 'unread').toList()
        : [];
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: CustomAppBar(
            type: true,
            onTap: () {
              restaurantController.restaurantStatus();
            },
          ),
          elevation: 0,
          backgroundColor: kLightWhite,
        ),
        body: BackGroundContainer(
          child: SizedBox(
            height: hieght,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  height: 125.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              HomeTile(
                                imagePath: "assets/icons/taco.svg",
                                text: "Add Foods",
                                onTap: () {
                                  Get.to(() => const AddFoodsPage(),
                                      transition: Transition.fadeIn,
                                      duration:
                                          const Duration(milliseconds: 400));
                                },
                              ),
                              const Positioned(
                                  child: Icon(
                                AntDesign.pluscircle,
                                color: Colors.green,
                              ))
                            ],
                          ),
                          HomeTile(
                            imagePath: "assets/icons/wallet.svg",
                            text: "Wallet",
                            onTap: () {
                              Get.to(() => const WalletPage(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 400));
                            },
                          ),
                          HomeTile(
                            imagePath: "assets/icons/french_fries.svg",
                            text: "Foods",
                            onTap: () {
                              Get.to(() => const FoodsPage(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 400));
                            },
                          ),
                          HomeTile(
                            imagePath: "assets/icons/deliver_food.svg",
                            text: "Self Delivered",
                            onTap: () {
                              Get.to(() => const SelfDeliveredPage(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 400));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            children: [
                              HomeTile(
                                imagePath: "assets/icons/vouvher.svg",
                                text: "Add Vouchers",
                                onTap: () {
                                  Get.to(() => const AddVoucher(),
                                      transition: Transition.fadeIn,
                                      duration:
                                          const Duration(milliseconds: 400));
                                },
                              ),
                              const Positioned(
                                  child: Icon(
                                AntDesign.pluscircle,
                                color: Colors.green,
                              ))
                            ],
                          ),
                          HomeTile(
                            imagePath: "assets/icons/vouchers.svg",
                            text: "Vouchers",
                            onTap: () {
                              Get.to(() => const VouchersPage(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 400));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Container(
                    height: 25.h,
                    width: width,
                    decoration: BoxDecoration(
                      color: kOffWhite,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      labelPadding: EdgeInsets.zero,
                      labelColor: Colors.white,
                      dividerColor: Colors.transparent,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      labelStyle: appStyle(12, kLightWhite, FontWeight.normal),
                      unselectedLabelColor: Colors.grey.withOpacity(0.7),
                      tabs: const <Widget>[
                        Tab(
                          child: TabWidget(text: "New Orders"),
                        ),
                        Tab(
                          child: TabWidget(text: "Preparing"),
                        ),
                        Tab(
                          child: TabWidget(text: "Ready"),
                        ),
                        Tab(
                          child: TabWidget(text: "Picked"),
                        ),
                        Tab(
                          child: TabWidget(text: "Self Deliveries"),
                        ),
                        Tab(
                          child: TabWidget(text: "Delivered"),
                        ),
                        Tab(
                          child: TabWidget(text: "Cancelled"),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: hieght * 0.7,
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      NewOrders(),
                      PreparingOrders(),
                      ReadyForDelivery(),
                      PickedOrders(),
                      SelfDeliveries(),
                      DeliveredOrders(),
                      CancelledOrders(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 60.0),
          child: Stack(
            clipBehavior: Clip.none, // Để phần badge hiển thị bên ngoài
            children: [
              FloatingActionButton(
                focusColor: kPrimary,
                hoverColor: kPrimary,
                onPressed: navigateToChatTab,
                child: const Icon(Icons.chat_bubble),
                backgroundColor: kPrimary,
              ),
              Positioned(
                top: 4, // Đặt vị trí của badge
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red, // Màu nền cho badge
                    shape: BoxShape.circle, // Đặt hình dạng là hình tròn
                  ),
                  child: Text(
                    '${countUnreadMessage != null ? countUnreadMessage.length : 0}', // Số đếm
                    style: const TextStyle(
                      color: Colors.white, // Màu chữ của số đếm
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
    required this.imagePath,
    required this.text,
    this.onTap,
  });

  final String imagePath;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            imagePath,
            width: 40.w,
            height: 40.h,
          ),
          ReusableText(text: text, style: appStyle(11, kGray, FontWeight.w500))
        ],
      ),
    );
  }
}
