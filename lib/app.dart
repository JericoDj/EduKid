
import 'package:edukid/bindings/general_bindings.dart';

import 'package:edukid/features/screens/onboarding/onboarding.dart';
import 'package:edukid/features/screens/profilescreen/settings.dart';
import 'package:edukid/features/screens/profilescreen/widgets/editprofile.dart';
import 'package:edukid/features/shop/screens/product_detail/product_detail.dart';
import 'package:edukid/navigation_Bar.dart';
import 'package:edukid/routes/app_routes.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      initialBinding: GeneralBindings(),
      getPages: AppRoutes.pages,
      /// Show Loader or Circular progress indicator meanwhile Authentication repository is deciding to show relevant screen.
      home: const Scaffold(backgroundColor: MyColors.primaryColor, body:  Center(child: CircularProgressIndicator(color: MyColors.white,),)),
    );
  }
}