import 'package:edukid/common/styles/shadows.dart';
import 'package:edukid/common/widgets/customShapes/containers/rounded_container.dart';
import 'package:edukid/common/widgets/icons/my_circular_icon.dart';
import 'package:edukid/common/widgets/images/my_rounded_image.dart';
import 'package:edukid/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:edukid/common/widgets/texts/my_brand_title_text.dart';
import 'package:edukid/common/widgets/texts/my_brand_title_text_with_verified_icon.dart';
import 'package:edukid/common/widgets/texts/product_price_text.dart';
import 'package:edukid/common/widgets/texts/product_title_text.dart';
import 'package:edukid/features/shop/models/product_model.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../features/shop/controller/product/product_controller.dart';
import '../../../../features/shop/screens/product_detail/product_detail.dart';
import '../../../../utils/constants/enums.dart';

class MyProductCardHorizontal extends StatelessWidget {
  const MyProductCardHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);

    final controller = ProductController.instance;
    final salePercentage =  controller.calculateSalePercentage(product.price, product.salePrice);

    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(product: product)); // Replace ProductDetailScreen with your actual product detail screen.
      },
      child: Container(
        width: 310,
        padding: const EdgeInsets.all(MySizes.sm),
        decoration: BoxDecoration(
          boxShadow: [MyShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(MySizes.productImageRadius),
          color: dark ? MyColors.darkerGrey : MyColors.white,
        ),
        child: Row(
          children: [
            MyRoundedContainer(
              height: 120,
              padding: EdgeInsets.all(0),
              backgroundColor: dark ? MyColors.dark : MyColors.light,
              child: Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: MyRoundedImage(
                      imageUrl: product.thumbnail,
                      applyImageRadius: true,
                      isNetworkImage: true,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    child: MyRoundedContainer(
                      radius: MySizes.sm,
                      backgroundColor: MyColors.secondaryColor.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: MySizes.sm, vertical: MySizes.xs),
                      child: Text('$salePercentage%',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: MyColors.black)),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: MyFavoriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 172,
              child: Padding(
                padding: EdgeInsets.only(top: MySizes.sm, left: MySizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyProductTitleText(
                          title: product.title,
                          smallSize: true,
                        ),
                        SizedBox(
                          height: MySizes.spaceBtwItems / 2,
                        ),
                        MyBrandTitleText(title: product.brand!.name),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              if (product.productType == ProductType.single.toString() &&
                                  product.salePrice > 0)
                                Padding(
                                  padding: EdgeInsets.only(left: MySizes.sm),
                                  child: Text(
                                    product.price.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .apply(decoration: TextDecoration.lineThrough),
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
                        Container(
                          decoration: BoxDecoration(
                            color: MyColors.dark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(MySizes.cardRadiusMd),
                              bottomRight: Radius.circular(MySizes.productImageRadius),
                            ),
                          ),
                          child: SizedBox(
                            width: MySizes.iconLg * 1.2,
                            height: MySizes.iconLg * 1.2,
                            child: Center(
                              child: Icon(Iconsax.add, color: MyColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
