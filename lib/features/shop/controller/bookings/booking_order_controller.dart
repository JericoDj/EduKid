import 'package:edukid/navigation_Bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../common/success_screen/sucess_screen.dart';
import '../../../../common/widgets/loaders/loaders.dart';
import '../../../../data/repositories.authentication/authentication_repository.dart';
import '../../../../data/repositories.authentication/bookings/booking_order_repository.dart';

import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../screens/personalization/controllers/address_controller.dart';
import 'package:edukid/features/shop/models/booking_orders_model.dart';

import '../../models/picked_date_and_time_model.dart';
import '../../screens/checkout/widgets/unique_key_generator.dart';
import '../product/checkout_controller.dart';


class BookingOrderController extends GetxController {
  static BookingOrderController get instance => Get.find();

  late final List<DateTime> pickedDates;
  late final List<TimeOfDay?> pickedTimes;


  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final bookingOrderRepository = Get.put(BookingOrderRepository());






  Future<List<BookingOrderModel>>? fetchUserBookings() async {
    try {
      final bookings = await bookingOrderRepository.fetchUserBookings();

      return bookings;
    } catch (e, stackTrace) {


      // Show a warning snack bar if needed
      MyLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  Future<List<BookingOrderModel>> fetchAllBookings() async {
    try {
      final bookings = await bookingOrderRepository.fetchAllBookings();
      return bookings;
    } catch (e, stackTrace) {
      // Handle error fetching bookings
      print('Error fetching all bookings: $e');
      print('Stack Trace: $stackTrace');
      // Show error snackbar or handle error
      return [];
    }
  }
  void processOrder(double totalAmount, List<DateTime> pickedDates, List<TimeOfDay?> pickedTimes) async {
    try {
      MyFullScreenLoader.openLoadingDialog('Processing your order', MyImages.loaders);
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || userId.isEmpty) return;

      // Create a list to store pickedDateTimeModels
      List<PickedDateTimeModel> pickedDateTimeModels = [];

      // Iterate through the pickedDates and pickedTimes to create PickedDateTimeModels
      for (int i = 0; i < pickedDates.length; i++) {
        // Convert TimeOfDay to DateTime
        DateTime pickedDateTime = DateTime(
          pickedDates[i].year,
          pickedDates[i].month,
          pickedDates[i].day,
          pickedTimes[i]!.hour,
          pickedTimes[i]!.minute,
        );

        // Create PickedDateTimeModel and add to the list
        pickedDateTimeModels.add(PickedDateTimeModel(pickedDate: pickedDates[i], pickedTime: pickedDateTime));
      }

      final booking = BookingOrderModel(
        id: UniqueKeyGenerator.generateUniqueKey(),
        userId: userId,
        status: OrderStatus.processing,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now(),
        booking: [],
        pickedDateTime: pickedDateTimeModels,
      );


      await bookingOrderRepository.saveBooking(booking);

      Get.offAll(() => SuccessScreen(
        image: MyImages.accountGIF,
        title: 'Payment Success!',
        subtitle: 'Your item will be shipped soon!',
        onPressed: () => Get.offAll(() => const NavigationBarMenu()),
      ));
    } catch (e) {
      MyLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
