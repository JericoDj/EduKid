import 'package:edukid/common/widgets/divider_signinwith_text.dart';
import 'package:edukid/features/authentication/login/widgets/social_Media_Login.dart';
import 'package:edukid/features/authentication/controllers/login/login_controller.dart';
import 'package:edukid/features/authentication/login/widgets/my_login_form.dart';
import 'package:edukid/features/authentication/login/widgets/my_login_header.dart';
import 'package:edukid/features/authentication/password_configuration/forget_password.dart';

import 'package:edukid/features/screens/signup/widgets/signup.dart';
import 'package:edukid/navigation_Bar.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:edukid/common/styles/spacing_styles.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/constants/text_strings.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final dark = MyHelperFunctions.isDarkMode(context);

    return Scaffold(
      key: controller.loginFormKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: MySpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title, Subtitle
              MyLoginHeader(dark: dark),

              /// email and password text field
              MyLoginForm(controller: controller),

              /// Divider sign in with text
              const MyFormDivider(dividerText: "Sign in with"),

              const SizedBox(
                height: MySizes.spaceBtwItems,
              ),

              ///Social Media Buttons
              const MySocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

