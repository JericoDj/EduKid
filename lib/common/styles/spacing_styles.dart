import 'package:edukid/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class MySpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: MySizes.appBarHeight,
    left: MySizes.defaultspace,
    bottom: MySizes.defaultspace,
    right: MySizes.defaultspace,
  );
}