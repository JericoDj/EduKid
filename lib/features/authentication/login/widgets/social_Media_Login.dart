import 'package:edukid/features/authentication/controllers/login/login_controller.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MySocialButtons extends StatelessWidget {
  const MySocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          onPressed: () => controller.googleSignIn(),
          icon: const Image(
            width: MySizes.iconMd,
            height: MySizes.iconMd,
            image: AssetImage(MyImages.googleLogo),
          ),
        ),
      ),
      const SizedBox(width: MySizes.spaceBtwItems,),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Image(
            width: MySizes.iconMd,
            height: MySizes.iconMd,
            image: AssetImage(MyImages.facebookLogo),
          ),
        ),
      ),
    ],
    );
  }
}
