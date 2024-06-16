import 'package:edukid/common/widgets/customShapes/containers/rounded_container.dart';
import 'package:edukid/common/widgets/images/my_circular_image.dart';
import 'package:edukid/common/widgets/texts/my_brand_title_text.dart';
import 'package:edukid/features/shop/models/brand_model.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/enums.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class MyBrandCard extends StatelessWidget {
  const MyBrandCard({
    super.key,
    required this.showBorder,
    this.onTap, required this.brand,
  });


  final BrandModel brand;
  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,

      /// container design
      child: MyRoundedContainer(
        padding: const EdgeInsets.all(MySizes.sm),
        showBorder: showBorder,
        borderColor: MyColors.primaryColor,
        backgroundColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///Icon
             Flexible(
              child: MyCircularImage(
                isNetworkImage: true,
                image: brand.image,
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              width: MySizes.spaceBtwItems / 2,
            ),

            /// Text
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   MyBrandTitleText(
                    title: brand.name,
                    brandTextSize: TextSizes.medium,
                  ),
                  Text(
                    '${brand.productsCount ?? 0} products',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
