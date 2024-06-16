import 'package:edukid/features/authentication/password_configuration/forget_password.dart';
import 'package:edukid/features/screens/profilescreen/settings.dart';
import 'package:edukid/features/shop/screens/checkout/checkout.dart';
import 'package:edukid/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:edukid/features/shop/screens/wishlist/wishlist.dart';
import 'package:edukid/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../features/authentication/login/login.dart';
import '../features/screens/homescreen/HomeScreen.dart';
import '../features/screens/onboarding/onboarding.dart';
import '../features/screens/personalization/screens/address/address.dart';
import '../features/screens/signup/widgets/signup.dart';
import '../features/screens/signup/widgets/verifyemailscreen.dart';
import '../features/shop/cart/cart.dart';
import '../features/shop/screens/order/order.dart';
import '../features/shop/screens/store/store.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: MyRoutes.home, page: () => const HomeScreen()),
    GetPage(name: MyRoutes.store, page: () => const StoreScreen()),
    GetPage(name: MyRoutes.favourites, page: () => const WishlistScreen()),
    GetPage(name: MyRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: MyRoutes.productReviews, page: () => const ProductReviewsScreen()),
    GetPage(name: MyRoutes.order, page: () => const OrderScreen()),
    GetPage(name: MyRoutes.checkout, page: () => const CheckOutScreen()),
    GetPage(name: MyRoutes.cart, page: () => const CartScreen()),
    GetPage(name: MyRoutes.userProfile, page: () => const SettingsScreen()),
    GetPage(name: MyRoutes.userAddress, page: () => const UserAddressScreen()),
    GetPage(name: MyRoutes.signup, page: () => const SignUpScreen()),
    GetPage(name: MyRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: MyRoutes.signIn, page: () => const LoginScreen()),
    GetPage(name: MyRoutes.forgetPassword, page: () => const ForgetPasswordScreen()),
    GetPage(name: MyRoutes.onBoarding, page: () => const OnBoardingScreen()),
  ];
}
