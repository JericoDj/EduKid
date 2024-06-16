import 'package:edukid/common/widgets/layouts/grid_layout.dart';
import 'package:edukid/common/widgets/shimmer/shimmer.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class MyVerticalProductShimmer extends StatelessWidget {
  const MyVerticalProductShimmer({
    Key? key,
    this.itemCount = 4,
  }) : super(key: key);

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return MyGridLayoutWidget(
      itemCount: itemCount,
      itemBuilder: (_, __) => SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            MyShimmerEffect(width: 50, height: 50),
            SizedBox(height: MySizes.spaceBtwItems), // Fixed typo: "-SizedBox" to "SizedBox"

            // Text
            MyShimmerEffect(width: 160, height: 15),
            SizedBox(height: MySizes.spaceBtwItems / 2),
            MyShimmerEffect(width: 110, height: 15),
          ],
        ),
      ),
    );
  }
}
