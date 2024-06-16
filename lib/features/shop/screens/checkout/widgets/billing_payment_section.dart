import 'package:edukid/common/widgets/customShapes/containers/rounded_container.dart';
import 'package:edukid/common/widgets/texts/section_heading.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/product/checkout_controller.dart';
import '../../../models/payment_method_model.dart';

class MyBillingPaymentSection extends StatelessWidget {
  const MyBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final dark = MyHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        MySectionHeading(title: 'Payment Method', buttonTitle: 'Change', onPressed: () => controller.selectPaymentMethod(context)),
        SizedBox(height: MySizes.spaceBtwItems / 2,),
        Obx(
          () => Row(
            children: [
              MyRoundedContainer(
                width: 60,
                height: 35,
                backgroundColor: dark ? MyColors.light : MyColors.white,
                padding: EdgeInsets.all(MySizes.sm),
                child: Image(image: AssetImage(controller.selectedPaymentMethod.value.image), fit: BoxFit.contain),
              ),
              SizedBox(width: MySizes.spaceBtwItems / 2,),
              Text(controller.selectedPaymentMethod.value.name, style: Theme.of(context).textTheme.bodyLarge,)
            ],
          ),
        )
      ],
    );
  }
}
