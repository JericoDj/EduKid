import 'package:edukid/features/shop/cart/widgets/my_cart_items_listview.dart';
import 'package:edukid/features/shop/controller/product/cart_controller.dart';
import 'package:edukid/features/shop/screens/checkout/checkout.dart';
import 'package:flutter/material.dart';
import 'package:edukid/common/widgets/appbar.dart';
import 'package:edukid/common/widgets/products/cart/add_remove_button.dart';
import 'package:edukid/common/widgets/products/cart/cart_item.dart';
import 'package:edukid/common/widgets/texts/product_price_text.dart';
import 'package:edukid/common/widgets/texts/product_title_text.dart';
import 'package:edukid/common/widgets/appbar.dart';
import 'package:edukid/common/widgets/images/my_rounded_image.dart';
import 'package:edukid/common/widgets/icons/my_circular_icon.dart';
import 'package:edukid/common/widgets/texts/my_brand_title_text.dart';
import 'package:edukid/common/widgets/texts/my_brand_title_text_with_verified_icon.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/loaders/animation_loader.dart';
import '../../../navigation_Bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    return Scaffold(
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        /// Nothing Found Widget
        final emptyWidget = MyAnimationLoaderWidget(
          text: 'Whoops! Cart is EMPTY.',
          animation: MyImages.loaders,

          /// showAction: true,
          /// if want to use this
          ///actionText: 'Let\'s fill it',
          ///onActionPressed: () => Get.off(() => const NavigationBarMenu()),
        );
        if (controller.cartItems.isEmpty) {
          return emptyWidget;
        } else {
          return const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MySizes.defaultspace),

              ///Items in cart
              child: MyCartItemsListView(),
            ),
          );
        }
      }),

      /// checkout button
      bottomNavigationBar: controller.cartItems.isEmpty
          ? SizedBox()
          : Padding(
              padding: EdgeInsets.all(MySizes.defaultspace),
              child: ElevatedButton(
                onPressed: () => Get.to(() => CheckOutScreen()),
                child: Obx(() =>
                    Text('Check Out \$${controller.totalCartPrice.value}')),
              ),
            ),
    );
  }
}
