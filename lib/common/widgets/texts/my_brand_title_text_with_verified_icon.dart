import 'package:edukid/common/widgets/texts/my_brand_title_text.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/enums.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class MyBrandTitleWithVerifiedIcon extends StatelessWidget {
  const MyBrandTitleWithVerifiedIcon({
    super.key,
    this.textColor,
    this.maxLines = 1,
    required this.title,
    this.iconColor = MyColors.primaryColor,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: MyBrandTitleText(
              title: title,
              color: textColor,
              maxLines: maxLines,
              textAlign: textAlign,
              brandTextSize: brandTextSize,
            ) // TBrandTitleText
        ), // Flexible
        const SizedBox (width: MySizes.xs),
        Icon(Iconsax.verify5, color: iconColor, size: MySizes.iconXs),

      ],
    );
  }
}


