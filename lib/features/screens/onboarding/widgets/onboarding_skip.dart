import 'package:edukid/features/authentication/onboarding_controller.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/device/device_utitility.dart';
import 'package:flutter/material.dart';



class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top: MyDeviceUtils.getAppBarheight(),
        right: MySizes.defaultspace,
        child:TextButton(onPressed: () => OnBoardingController.instance.skipPage(),
          child: const Text('Skip'),));
  }
}