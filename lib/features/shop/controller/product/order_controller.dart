import 'package:edukid/navigation_Bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../common/success_screen/sucess_screen.dart';
import '../../../../common/widgets/loaders/loaders.dart';
import '../../../../data/repositories.authentication/authentication_repository.dart';
import '../../../../data/repositories.authentication/product/order_repository.dart';
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

  /// Variables
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  /// Fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();

      // Print the length of userOrders
      print('Length of userOrders: ${userOrders.length}');

      return userOrders;
    } catch (e, stackTrace) {
      // Print the error message
      print('Error fetching user orders: $e');

      // Print the stack trace for more detailed information
      print('Stack Trace: $stackTrace');

      // Show a warning snack bar if ne eded
      MyLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());

      // Return an empty list as a fallback
      return [];
    }
  }


  /// Add methods for processing

  void processOrder(double totalAmount) async {
    try {
      // Start Loader
      MyFullScreenLoader.openLoadingDialog(
          'Processing your order', MyImages.loaders);

      // Get user authentication Id
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || userId.isEmpty) return;

      // Add Details
      final order = OrderModel(
        // Generate a unique ID for the order
        id: UniqueKeyGenerator.generateUniqueKey(),
        userId: userId,
        status: OrderStatus.processing,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        // Set Date as needed
        deliveryDate: DateTime.now(),
        items: cartController.cartItems.toList(),
      );

      // show button payment




      // Save the order to Firestore
      await orderRepository.saveOrder(order);

      // Update the cart status
      cartController.clearCart();

      // Show Success screen
      Get.offAll(() => SuccessScreen(
            image: MyImages.accountGIF,
            title: 'Payment Success!',
            subtitle: 'Your item will be shipped soon!',
            onPressed: () => Get.offAll(() => const NavigationBarMenu()),
          )); // SuccessScreen
    } catch (e) {
      MyLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
