import 'package:flutter/material.dart';
import 'package:foodly_restaurant/common/custom_appbar.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/views/home/widgets/back_ground_container.dart';
import 'package:foodly_restaurant/views/home/widgets/voucher_list.dart';

class VouchersPage extends StatelessWidget {
  const VouchersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: CustomAppBar(
          title:
              "View all vouchers in your restaurant and edit to ad information",
          heading: "Welcome to Foodly",
        ),
        elevation: 0,
        backgroundColor: kLightWhite,
      ),
      body: const BackGroundContainer(
        child: VoucherList(),
      ),
    );
  }
}
