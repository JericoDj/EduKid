import 'package:cached_network_image/cached_network_image.dart';
import 'package:edukid/common/widgets/shimmer/shimmer.dart';
import 'package:edukid/features/shop/models/brand_model.dart';
import 'package:edukid/features/shop/screens/brands/brand_products.dart';
import 'package:edukid/features/shop/screens/store/mybrandcard.dart';
import 'package:flutter/material.dart';

import 'package:edukid/common/widgets/customShapes/containers/rounded_container.dart';

import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class MyBrandShowCase extends StatelessWidget {
  const MyBrandShowCase({
    super.key,
    required this.images, required this.brand,
  });


  final BrandModel brand;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: MyRoundedContainer(
        showBorder: true,
        borderColor: MyColors.darkGrey,
        padding: const EdgeInsets.all(MySizes.md),
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.only(bottom: MySizes.spaceBtwItems),
        child: Column(
          children: [
             MyBrandCard(showBorder: false, brand: brand),

            Row(children: images.map((image) => brandTopProductImageWidget(image, context)).toList())
          ],
        ),
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context) {
    return Expanded(
      child: MyRoundedContainer(
        height: 100,
        padding: const EdgeInsets.all(MySizes.md),
        margin: const EdgeInsets.only (right: MySizes.sm),
        backgroundColor: MyHelperFunctions.isDarkMode(context) ? MyColors
            .darkerGrey : MyColors.light,
        child: CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadprogress) => const MyShimmerEffect(width: 100, height: 100),
          errorWidget:(context, url, error) => const Icon(Icons.error),
        ),
      ), // TRoundedContainer
    ); // Expanded
  }
}
