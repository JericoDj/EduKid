import 'package:edukid/common/widgets/customShapes/curvedEdges/curved_edges.dart';
import 'package:flutter/material.dart';

class MyCurvedEdgesWidget extends StatelessWidget {
  const MyCurvedEdgesWidget({
    super.key,
    required this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomCurvedEdges(),
      child: child,
    );
  }
}
