import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_restaurant/common/shimmers/voucher_shimmer.dart';
import 'package:foodly_restaurant/hooks/fetch_voucher.dart';
import 'package:foodly_restaurant/models/vouchers.dart';
import 'package:foodly_restaurant/views/home/widgets/empty_page.dart';
import 'package:foodly_restaurant/views/home/widgets/voucher_title.dart';
import 'package:foodly_restaurant/views/voucher/voucher_page.dart';
import 'package:get/get.dart';

class VoucherList extends HookWidget {
  const VoucherList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchVoucher();
    final vouchers = hookResult.data;
    final isLoading = hookResult.isLoading;

    if (isLoading) {
      return const VouchersListShimmer();
    } else if (vouchers!.isEmpty) {
      return const EmptyPage();
    }
    return Container(
      padding: const EdgeInsets.only(
        left: 12,
        top: 10,
        right: 12,
      ),
      height: 190.h,
      child: ListView.builder(
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          Voucher voucher = vouchers[index];
          return CategoryVoucherTitle(
            onTap: () {
              Get.to(() => VoucherPage(voucher: voucher),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 500));
            },
            voucher: voucher,
          );
        },
      ),
    );
  }
}
