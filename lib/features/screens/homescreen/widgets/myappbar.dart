import 'package:edukid/common/widgets/appbar.dart';
import 'package:edukid/common/widgets/products/cart_menu_icons.dart';
import 'package:edukid/features/personalization/controllers/user_controller.dart';
import 'package:edukid/common/widgets/shimmer/shimmer.dart';

import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../shop/controller/product/variation_controller.dart';

class MyHomeAppBar extends StatelessWidget {
  const MyHomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return MyAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyTexts.homeAppBarTitle,
            style: Theme.of(context).textTheme.labelMedium!.apply(color: MyColors.white),
          ),
          Obx(() {
            if (controller.profileLoading.value) {
              // Display a shimmer loading while user profile is being loaded
              return const MyShimmerEffect(width: 80, height: 15, radius: 8.0);
            } else {
              return Text(
                controller.user.value.fullName,
                style: Theme.of(context).textTheme.headlineSmall!.apply(color: MyColors.white),
              );
            }
          }),
        ],
      ),
      actions: [
        MyCartIcon(
          iconColor: MyColors.white,
        ),
      ],
    );
  }
}
