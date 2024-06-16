import 'package:edukid/common/widgets/images/my_rounded_image.dart';
import 'package:edukid/common/widgets/texts/my_brand_title_text.dart';
import 'package:edukid/common/widgets/texts/product_title_text.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../../features/shop/models/cart_item_model.dart';

class MyCartItem extends StatelessWidget {
  const MyCartItem({
    super.key,
    required this.cartItem,
  });

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image
        MyRoundedImage(
          imageUrl: cartItem.image ?? '',
          width: 60,
          height: 60,
          isNetworkImage: true,
          padding: const EdgeInsets.all(MySizes.sm),
          backgroundColor: MyHelperFunctions.isDarkMode(context)
              ? MyColors.darkerGrey
              : MyColors.light,
        ), // MyRoundedImage
        const SizedBox(width: MySizes.spaceBtwItems),

        /// Title, Price, & Size
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyBrandTitleText(title: cartItem.brandName ?? ''),
              Flexible(
                child: MyProductTitleText(
                  title: cartItem.title,
                  maxLines: 1,
                ),
              ),

              /// Attributes
              Text.rich(
                TextSpan(
                  children: (cartItem.selectedVariation ?? {})
                      .entries
                      .map(
                        (e) => TextSpan(
                          children: [
                            TextSpan(
                                text: '${e.key}',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                                text: '${e.value}',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
