import 'package:edukid/common/styles/shadows.dart';
import 'package:edukid/common/widgets/customShapes/containers/rounded_container.dart';
import 'package:edukid/common/widgets/images/my_rounded_image.dart';
import 'package:edukid/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:edukid/common/widgets/products/product_card/product_card_add_to_cart_button.dart';
import 'package:edukid/common/widgets/texts/my_brand_title_text.dart';
import 'package:edukid/common/widgets/texts/product_price_text.dart';
import 'package:edukid/common/widgets/texts/product_title_text.dart';
import 'package:edukid/features/shop/controller/product/product_controller.dart';
import 'package:edukid/features/shop/screens/product_detail/product_detail.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/enums.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/shop/models/product_model.dart';

class MyProductCardVertical extends StatelessWidget {
  const MyProductCardVertical({Key? key, required this.product})
      : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage =
        controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = MyHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [MyShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(MySizes.productImageRadius),
          color: dark ? MyColors.darkerGrey : MyColors.white,
        ),
        child: MyRoundedContainer(
          height: 500, // Adjust the height of this container
          padding: const EdgeInsets.all(MySizes.sm),
          backgroundColor: dark ? MyColors.dark : MyColors.light,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  MyRoundedImage(
                    imageUrl: product.thumbnail,
                    height: 200,
                    applyImageRadius: true,
                    isNetworkImage: true,
                    backgroundColor: Colors.transparent,
                  ),

                  /// sale tag
                  if (salePercentage != null)
                    Positioned(
                      top: 12,
                      child: MyRoundedContainer(
                        radius: MySizes.sm,
                        backgroundColor:
                            MyColors.secondaryColor.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: MySizes.sm,
                          vertical: MySizes.xs,
                        ),
                        child: Text(
                          '$salePercentage%',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: MyColors.black),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: MyFavoriteIcon(
                      productId: product.id,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: MySizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyProductTitleText(title: product.title, smallSize: true),
                    SizedBox(height: MySizes.spaceBtwItems / 2),
                    MyBrandTitleText(title: product.brand!.name),
                  ],
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        if (product.productType ==
                                ProductType.single.toString() &&
                            product.salePrice > 0)
                          Padding(
                            padding: EdgeInsets.only(left: MySizes.sm),
                            child: Text(
                              product.price.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(
                                      decoration: TextDecoration.lineThrough),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(left: MySizes.sm),
                          child: MyProductPriceText(
                            price: controller.getProductPrice(product),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// add to cart button
                  ProductCardAddToCartButton(product: product,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
