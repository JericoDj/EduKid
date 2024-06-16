import 'package:edukid/common/widgets/layouts/grid_layout.dart';
import 'package:edukid/common/widgets/shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class MyBrandShimmer extends StatelessWidget {
  const MyBrandShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return MyGridLayoutWidget(
      mainAxisExtent: 80,
        itemCount: itemCount,
      itemBuilder: (_, __) => const MyShimmerEffect(width: 300, height: 80),
    );
  }
}
