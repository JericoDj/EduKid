import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      MyFullScreenLoader.openLoadingDialog('Processing your order', MyImages.loaders);

      // Get user authentication Id
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || userId.isEmpty) return;

      // Assume you have stored the nonce somewhere (like in Firebase)
      final String? savedCardNonce = await _retrieveSavedCardNonce(); // Retrieve from storage or backend

      if (savedCardNonce != null) {
        // If you have a saved card nonce, process the payment using it
        bool paymentSuccess = await _chargeCard(savedCardNonce, totalAmount);

        if (paymentSuccess) {
          // Payment was successful, proceed to save the order and clear cart
          await _saveOrderAndClearCart(userId, totalAmount);

        } else {
          MyLoaders.errorSnackBar(title: 'Payment Failed', message: 'There was an error processing your payment.');
        }

      } else {
        // Handle case where there's no saved card nonce (this shouldn't normally happen)
        MyLoaders.errorSnackBar(title: 'Payment Error', message: 'No saved card information found.');
      }
    } catch (e) {
      MyLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    } finally {
      MyFullScreenLoader.stopLoading();
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

  Future<String?> _retrieveSavedCardNonce() async {
    // Implement retrieval logic for saved card nonce
    // You can fetch this from Firebase or another secure storage
    // Example:
    // final secureStorage = new FlutterSecureStorage();
    // return await secureStorage.read(key: 'savedCardNonce');

    // Return a dummy nonce for this example
    return 'your_saved_card_nonce';
  }

  Future<bool> _chargeCard(String nonce, double amount) async {
    try {
      // Replace with your backend URL
      final response = await http.post(
        Uri.parse('https://your-backend-url.com/processPayment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nonce': nonce,
          'amount': (amount * 100).round(), // Convert to cents
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error charging card: $e');
      return false;
    }
  }
}
