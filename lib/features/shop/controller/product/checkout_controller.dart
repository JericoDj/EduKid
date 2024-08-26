import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edukid/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
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

  Future<void> storeCardNonce(String nonce) async {
    // Ensure the user is authenticated
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Create a reference to the Firestore document
      DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Store the nonce in the 'paymentInfo' collection under the user's document
      await userDoc.collection('paymentInfo').doc('cardNonce').set({
        'nonce': nonce,
        'timestamp': FieldValue.serverTimestamp(), // Store the time when the nonce was saved
      });

      print("Card nonce saved successfully in Firestore.");
    } else {
      print("User not authenticated. Cannot save card nonce.");
    }
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

              // Google Pay Tile
              MyPaymentTile(
                paymentMethod: PaymentMethodModel(
                    name: 'GooglePay', image: MyImages.googleLogo),
                onTap: () {
                  selectedPaymentMethod.value = PaymentMethodModel(
                      name: 'GooglePay', image: MyImages.googleLogo);
                  Get.back(); // Close the modal after selecting the payment method
                },
              ),
              const SizedBox(height: MySizes.spaceBtwItems / 2),

              // Apple Pay Tile
              MyPaymentTile(
                paymentMethod: PaymentMethodModel(
                    name: 'ApplePay', image: MyImages.applePay),
                onTap: () {
                  selectedPaymentMethod.value = PaymentMethodModel(
                      name: 'ApplePay', image: MyImages.applePay);
                  Get.back();
                },
              ),
              const SizedBox(height: MySizes.spaceBtwItems / 2),

              // Saved Card Tile
              MyPaymentTile(
                paymentMethod: PaymentMethodModel(
                    name: 'Saved Card', image: MyImages.masterCard),
                onTap: () async {
                  // Retrieve saved card nonce from Firestore
                  String? savedCardNonce = await _retrieveSavedCardNonce();

                  if (savedCardNonce != null) {
                    selectedPaymentMethod.value = PaymentMethodModel(
                      name: 'Saved Card',
                      image: MyImages.masterCard,
                      nonce: savedCardNonce,
                    );
                    Get.back(); // Close the modal after selecting the saved card
                  } else {
                    // Handle the case where no saved card was found
                    print("No saved card found.");
                    Get.snackbar('Error', 'No saved card found.',
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
              const SizedBox(height: MySizes.spaceBtwItems / 2),

              // Add Credit/Debit Card Tile
              MyPaymentTile(
                paymentMethod: PaymentMethodModel(
                    name: 'Add Credit/Debit Card', image: MyImages.maya),
                onTap: () async {
                  await InAppPayments.startCardEntryFlow(
                    onCardNonceRequestSuccess: (CardDetails result) async {
                      // Handle the success and store the card nonce/token
                      print("Card Nonce: ${result.nonce}");

                      // Store the nonce in Firebase
                      await storeCardNonce(result.nonce);

                      // Update the selected payment method
                      selectedPaymentMethod.value = PaymentMethodModel(
                        name: 'Saved Card',
                        image: MyImages.masterCard,
                        cardDetails: result,
                      );
                      InAppPayments.completeCardEntry(
                          onCardEntryComplete: _onCardEntryComplete);
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

  Future<String?> _retrieveSavedCardNonce() async {
    // Ensure the user is authenticated
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Create a reference to the Firestore document
      DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Retrieve the saved card nonce from the 'paymentInfo' collection
      DocumentSnapshot docSnapshot = await userDoc.collection('paymentInfo').doc('cardNonce').get();

      if (docSnapshot.exists) {
        // Get the nonce from the document
        String? nonce = docSnapshot.get('nonce');
        print("Retrieved nonce: $nonce");
        return nonce;
      } else {
        print("No saved nonce found.");
        return null;
      }
    } else {
      print("User not authenticated. Cannot retrieve card nonce.");
      return null;
    }
  }



  void _onCardEntryComplete() {
    // Handle completion logic if needed
    print("Card entry completed successfully.");
  }
}
