import 'package:edukid/common/widgets/customShapes/containers/rounded_container.dart';
import 'package:edukid/common/widgets/images/my_circular_image.dart';
import 'package:edukid/common/widgets/texts/my_brand_title_text.dart';
import 'package:edukid/common/widgets/texts/my_brand_title_text_with_verified_icon.dart';
import 'package:edukid/common/widgets/texts/product_price_text.dart';
import 'package:edukid/common/widgets/texts/product_title_text.dart';
import 'package:edukid/features/shop/controller/product/product_controller.dart';
import 'package:edukid/features/shop/controller/product/variation_controller.dart'; // Import VariationController
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/enums.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../models/product_model.dart';

class MyProductMetaData extends StatelessWidget {
  MyProductMetaData({super.key, required this.product});

  final ProductModel product;

// Lazily initialize VariationController
  final controller = Get.put(VariationController());

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final variationController =
        VariationController.instance; // Instantiate VariationController
    final salePercentage =
        controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = MyHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Price
        Row(
          children: [
            /// Sale Tag
            MyRoundedContainer(
              radius: MySizes.sm,
              backgroundColor: MyColors.secondaryColor.withOpacity(0.8),
              padding: EdgeInsets.symmetric(
                  horizontal: MySizes.sm, vertical: MySizes.xs),
              child: Text(
                '$salePercentage%',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .apply(color: MyColors.black),
              ),
            ),
            const SizedBox(width: MySizes.spaceBtwItems),

            /// Price
            if (product.productType == ProductType.single.toString() &&
                product.salePrice > 0)
              Text(
                '\$${product.price}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .apply(decoration: TextDecoration.lineThrough),
              ),
            if (product.productType == ProductType.single.toString() &&
                product.salePrice > 0)
              const SizedBox(width: MySizes.spaceBtwItems),
            Obx(
              () => MyProductPriceText(
                // Use selected variation price if available, otherwise use the original product price
                price: variationController.selectedVariation.value.id.isNotEmpty
                    ? variationController.getVariationPrice()
                    : controller.getProductPrice(product),
                isLarge: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: MySizes.spaceBtwItems / 1.5),

        /// Title
        MyProductTitleText(title: product.title),
        const SizedBox(height: MySizes.spaceBtwItems / 1.5),

        /// Stock Status
        Row(
          children: [
            const MyProductTitleText(title: 'Status'),
            const SizedBox(width: MySizes.spaceBtwItems),
            Text(
              controller.getProductStockStatus(product.stock),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        // Row
        const SizedBox(height: MySizes.spaceBtwItems / 1.5),

        /// Brand
        Row(
          children: [
            MyCircularImage(
              isNetworkImage: true,
              image: product.brand?.image ?? '',
              width: 32,
              height: 32,
            ),
            MyBrandTitleText(
              title: product.brand != null ? product.brand!.name : '',
              brandTextSize: TextSizes.medium,
            )
          ],
        )
      ],
    );
  }
}
