

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edukid/common/widgets/appbar.dart';
import 'package:edukid/common/widgets/customShapes/curvedEdges/curved_edges_widget.dart';
import 'package:edukid/common/widgets/icons/my_circular_icon.dart';
import 'package:edukid/common/widgets/images/my_rounded_image.dart';
import 'package:edukid/features/shop/controller/product/images_controller.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/product_model.dart';

class MyProductImageSlider extends StatelessWidget {
  const MyProductImageSlider({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);

    final controller = Get.put(ImagesController());
    final images = controller.getAllProductImages(product);

    return MyCurvedEdgesWidget(
      child: Container(
        color: dark ? MyColors.darkerGrey : MyColors.light,
        child: Stack(children: [
          /// Main Large Image
          Positioned(
            child: SizedBox(
              height: 350,
              child: Padding(
                padding: EdgeInsets.all(MySizes.productImageRadius * 2),
                child: Center(
                  child: Obx(
                    () {
                      final image = controller.selectedProductImage.value;
                      return GestureDetector(
                        onTap: () => controller.showEnlargedImage(image),
                        child: CachedNetworkImage(
                          imageUrl: image ,
                          progressIndicatorBuilder: (_, __, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress, color: MyColors.primaryColor,),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 30,
            left: MySizes.defaultspace,
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                itemCount: images.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                separatorBuilder: (_, __) => SizedBox(
                  width: MySizes.spaceBtwItems,
                ),
                itemBuilder: (_, index) => Obx(
                  () {

                    final imageSelected = controller.selectedProductImage.value == images[index];
                    return MyRoundedImage(
                    width: 80,
                    isNetworkImage: true,
                    backgroundColor: dark ? MyColors.dark : MyColors.white,
                    onPressed: () => controller.selectedProductImage.value = images[index],
                    border: Border.all(color: imageSelected ? MyColors.primaryColor : Colors.transparent),
                    padding: EdgeInsets.all(MySizes.md),
                    imageUrl: images[index],
                  );
                  }
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
