import 'package:edukid/utils/local_storage/storage_utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

import 'app.dart';
import 'data/repositories.authentication/authentication_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyStorageUtility.init('your_bucket_name');
  await GetStorage.init();

  // Splash screen
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  // Initialize Square In-App Payments SDK
  await InAppPayments.setSquareApplicationId('sandbox-sq0idb-a-JbuDtx-cqSBty0e5d2kA');
  runApp(const App());
}
