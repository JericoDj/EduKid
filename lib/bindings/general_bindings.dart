import 'package:edukid/features/personalization/controllers/user_controller.dart';
import 'package:edukid/features/screens/personalization/controllers/address_controller.dart';
import 'package:edukid/features/shop/controller/bookings/booking_order_controller.dart';
import 'package:edukid/features/shop/controller/category_controller.dart';
import 'package:edukid/features/shop/controller/product/favorites_controller.dart';
import 'package:get/get.dart';
import '../features/shop/controller/product/checkout_controller.dart';
import '../features/shop/controller/product/variation_controller.dart';
import '../utils/network manager/network_manager.dart';


class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VariationController());
    Get.put(CheckoutController());
    Get.put(AddressController());
    Get.put(BookingOrderController());


  }
}