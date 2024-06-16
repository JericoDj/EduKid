import 'package:edukid/common/widgets/customShapes/containers/circular_container.dart';
import 'package:edukid/common/widgets/customShapes/curvedEdges/curved_edges_widget.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class MyPrimaryHeaderContainer extends StatelessWidget {
  const MyPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MyCurvedEdgesWidget(
      child: Container(
        color: MyColors.primaryColor,
        padding: EdgeInsets.all(0),
        child: Stack(
          children: [
            /// backround custom shapes
            Positioned(
              top: -150,
              right: -250,
              child: MyCircularWidget(backroundColor: MyColors.textWhite.withOpacity(0.1)),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: MyCircularWidget(backroundColor: MyColors.textWhite.withOpacity(0.1))),
              child,
        ],
            ),
      ),
    );
  }
}

