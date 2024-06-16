import 'package:edukid/utils/theme/custom_theme/appbar_theme.dart';
import 'package:edukid/utils/theme/custom_theme/bottom_sheet_theme.dart';
import 'package:edukid/utils/theme/custom_theme/checkbox_theme.dart';
import 'package:edukid/utils/theme/custom_theme/chip_theme.dart';
import 'package:edukid/utils/theme/custom_theme/elevated_button_theme.dart';
import 'package:edukid/utils/theme/custom_theme/outlined_button_theme.dart';
import 'package:edukid/utils/theme/custom_theme/text_field_theme.dart';
import 'package:edukid/utils/theme/custom_theme/text_theme.dart';
import 'package:flutter/material.dart';

//fontFamily: add to ThemeData



class MyTheme {
  MyTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    //fontFamily: add to ThemeData
    brightness: Brightness.light,
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    textTheme: MyTextTheme.lightTextTheme,
    chipTheme: MyChipTheme.lightChipTheme,
    appBarTheme: MyAppBarTheme.lightAppBarTheme,
    checkboxTheme: MyCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: MyBottomSheetTheme.lightBottomSheet,
    elevatedButtonTheme: MyElevatedTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.lightOutlinedButton,
    inputDecorationTheme: MyInputTextFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    //fontFamily: add to ThemeData
    brightness: Brightness.dark,
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.black,
    textTheme: MyTextTheme.darkTextTheme,
    chipTheme: MyChipTheme.darkChipTheme,
    appBarTheme: MyAppBarTheme.darkAppBarTheme,
    checkboxTheme: MyCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: MyBottomSheetTheme.darkBottomSheet,
    elevatedButtonTheme: MyElevatedTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.darkOutlinedButton,
    inputDecorationTheme: MyInputTextFieldTheme.darkInputDecorationTheme,
  );



}