import 'package:edukid/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/payment_method_model.dart';
import '../../screens/checkout/widgets/payment_tile.dart';class CheckoutController extends GetxController {
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
              // List of payment methods with onPressed callbacks
              MyPaymentTile(
                paymentMethod: PaymentMethodModel(name: 'GooglePay', image: MyImages.googleLogo),
                onTap: () {
                  selectedPaymentMethod.value = PaymentMethodModel(name: 'GooglePay', image: MyImages.googleLogo);
                  Get.back(); // Close the modal after selecting the payment method
                },
              ),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              MyPaymentTile(
                paymentMethod: PaymentMethodModel(name: 'ApplePay', image: MyImages.applePay),
                onTap: () {
                  selectedPaymentMethod.value = PaymentMethodModel(name: 'ApplePay', image: MyImages.applePay);
                  Get.back();
                },
              ),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              // ... other payment methods
              MyPaymentTile(
                paymentMethod: PaymentMethodModel(name: 'Add Credit/Debit Card', image: MyImages.maya),
                onTap: () async {
                  await InAppPayments.startCardEntryFlow(
                    onCardNonceRequestSuccess: (CardDetails result) async {
                      // Handle the success and store the card nonce/token
                      print("Card Nonce: ${result.nonce}");
                      selectedPaymentMethod.value = PaymentMethodModel(
                        name: 'Saved Card',
                        image: MyImages.masterCard,
                        cardDetails: result,
                      );
                      InAppPayments.completeCardEntry(onCardEntryComplete: _onCardEntryComplete);
                      Get.back(); // Close the modal after adding the card
                    },
                    onCardEntryCancel: () {
                      print("Card Entry Cancelled");
                    },
                  );
                },
              ),
              const SizedBox(height: MySizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  void _onCardEntryComplete() {
    // Handle completion logic if needed
    print("Card entry completed successfully.");
  }
}
