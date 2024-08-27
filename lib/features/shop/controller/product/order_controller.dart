import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';


import '../../../../common/success_screen/sucess_screen.dart';
import '../../../../common/widgets/loaders/loaders.dart';
import '../../../../data/repositories.authentication/authentication_repository.dart';
import '../../../../data/repositories.authentication/product/order_repository.dart';
import '../../../../navigation_Bar.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../screens/personalization/controllers/address_controller.dart';
import '../../models/order_model.dart';
import '../../screens/checkout/widgets/unique_key_generator.dart';
import 'cart_controller.dart';
import 'checkout_controller.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      print('Length of userOrders: ${userOrders.length}');
      return userOrders;
    } catch (e, stackTrace) {
      print('Error fetching user orders: $e');
      print('Stack Trace: $stackTrace');
      MyLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// Process order with Square payment integration
  void processOrder(double totalAmount) async {
    try {
      // Start Loader
      MyFullScreenLoader.openLoadingDialog(
          'Processing your order',
          MyImages.loaders
      );

      // Get user authentication Id
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || userId.isEmpty) {
        print("User ID is null or empty");
        return;
      }

      // Retrieve the saved card nonce from storage or backend
      final String? savedCardNonce = await _retrieveSavedCardNonce();

      // Debugging print statements
      if (savedCardNonce != null) {
        print("Saved card nonce found: $savedCardNonce");
      } else {
        print("No saved card nonce found.");
      }

      // Print the total amount
      print("Total amount to be charged: $totalAmount");

      if (savedCardNonce != null) {
        // Print the saved card nonce
        print("Using saved card nonce: $savedCardNonce");

        // If you have a saved card nonce, process the payment using it
        bool paymentSuccess = await _chargeCard(savedCardNonce, totalAmount);

        if (paymentSuccess) {
          // Payment was successful, proceed to save the order and clear cart
          _saveOrderAndClearCart(userId, totalAmount);
        } else {
          MyLoaders.errorSnackBar(
            title: 'Payment Failed',
            message: 'There was an error processing your payment.',
          );
        }
      } else {
        // Handle case where there's no saved card nonce
        MyLoaders.errorSnackBar(
          title: 'Payment Error',
          message: 'No saved card information found.',
        );
      }
    } catch (e) {
      MyLoaders.errorSnackBar(
        title: 'Oh Snap',
        message: e.toString(),
      );
      print("Exception during order processing: $e");
    } finally {
      MyFullScreenLoader.stopLoading();
    }
  }


  Future<String?> _retrieveSavedCardNonce() async {
    // Ensure the user is authenticated
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Retrieve the nonce from Firestore
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('paymentInfo')
          .doc('cardNonce')
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return docSnapshot.get('nonce');
      } else {
        print("No saved card nonce found in Firestore.");
        return null;
      }
    } else {
      print("User not authenticated. Cannot retrieve card nonce.");
      return null;
    }
  }

  Future<void> _saveOrderAndClearCart(String userId, double totalAmount) async {
    final order = OrderModel(
      id: UniqueKeyGenerator.generateUniqueKey(),
      userId: userId,
      status: OrderStatus.processing,
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
      paymentMethod: checkoutController.selectedPaymentMethod.value.name,
      address: addressController.selectedAddress.value,
      deliveryDate: DateTime.now(),
      items: cartController.cartItems.toList(),
    );

    await orderRepository.saveOrder(order);
    cartController.clearCart();

    Get.offAll(() => SuccessScreen(
      image: MyImages.accountGIF,
      title: 'Payment Success!',
      subtitle: 'Your item will be shipped soon!',
      onPressed: () => Get.offAll(() => const NavigationBarMenu()),
    ));
  }

  Future<bool> _chargeCard(String nonce, double amount) async {
    try {
      final Uuid uuid = Uuid();  // Instantiate the UUID generator
      final response = await http.post(
        Uri.parse('https://connect.squareupsandbox.com/v2/payments'),
        headers: <String, String>{
          'Authorization': 'Bearer EAAAl3xPPZ-EQukdMTUZjnGlrPTN9rnLWeJRGJNaBCzenFSj7QmlGW4hNdR9HSvn',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'source_id': nonce,
          'amount_money': {
            'amount': (amount * 100).round(),
            'currency': 'USD',
          },
          'idempotency_key': uuid.v4(), // Unique key for this transaction
        }),
      );

      if (response.statusCode == 200) {
        print('Payment successful: ${response.body}');
        return true;
      } else {
        print('Payment failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error charging card: $e');
      return false;
    }
  }
}

