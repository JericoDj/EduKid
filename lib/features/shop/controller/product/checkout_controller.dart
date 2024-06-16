import 'package:edukid/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/payment_method_model.dart';
import '../../screens/checkout/widgets/payment_tile.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();
  final Rx<PaymentMethodModel> selectedPaymentMethod =
      PaymentMethodModel.empty().obs;



  @override
  void onInit() {
    selectedPaymentMethod.value =
        PaymentMethodModel(name: 'GCash', image: MyImages.gCash);
    super.onInit();
  }

  Future<PaymentMethodModel?> selectPaymentMethod(BuildContext context) {
    Get.lazyPut(() => CheckoutController());

    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(MySizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MySectionHeading(
                  title: 'Select Payment Method', showActionButton: false),
              const SizedBox(height: MySizes.spaceBtwSections),
              MyPaymentTile(paymentMethod: PaymentMethodModel(name: 'GooglePay', image: MyImages.googleLogo)),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              MyPaymentTile(paymentMethod: PaymentMethodModel(name: 'ApplePay', image: MyImages.applePay)),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              MyPaymentTile(paymentMethod: PaymentMethodModel(name: 'Mastercard', image: MyImages.masterCard)),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              MyPaymentTile(paymentMethod: PaymentMethodModel(name: 'Visa', image: MyImages.visa)),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              MyPaymentTile(paymentMethod: PaymentMethodModel(name: 'GCash', image: MyImages.gCash)),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              MyPaymentTile(paymentMethod: PaymentMethodModel(name: 'Maya', image: MyImages.maya)),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              const SizedBox(height: MySizes.spaceBtwSections),

            ],
          ),
        ),
      ),
    );
  }
}
