import 'package:edukid/features/authentication/controllers/forgot_password/forgot_password_controller.dart';
import 'package:edukid/features/authentication/password_configuration/reset_password.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/constants/text_strings.dart';
import 'package:edukid/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
        appBar: AppBar(),
        body:  Padding(
          padding: const EdgeInsets.all(MySizes.defaultspace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              /// Headings
              Text(MyTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height:  MySizes.spaceBtwItems),
              Text(MyTexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height:  MySizes.spaceBtwItems * 2),

              /// Text fields
              Form(
                key: controller.forgetPasswordFormKey,
                child: TextFormField(
                  controller: controller.email,
                  validator: MyValidator.validateEmail,
                  decoration: const InputDecoration(labelText: MyTexts.email, prefixIcon: Icon(Iconsax.direct_right)),
                ),
              ),
              const SizedBox(height:  MySizes.spaceBtwItems),

              /// Submit Button
              SizedBox(width: double.infinity,child: ElevatedButton(onPressed: () => controller.sendPasswordResetEmail(), child: const Text("Submit"),))


            ],
          ),
        )
    );
  }
}
