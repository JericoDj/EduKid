import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edukid/data/repositories.authentication/user_repository.dart';
import 'package:edukid/features/screens/onboarding/onboarding.dart';
import 'package:edukid/features/screens/signup/widgets/verifyemailscreen.dart';
import 'package:edukid/navigation_Bar.dart';

import 'package:edukid/utils/local_storage/storage_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/authentication/login/login.dart';
import '../../utils/exception/my_firebase_auth_exception.dart';
import '../../utils/exception/my_firebase_exception.dart';
import '../../utils/exception/my_format_exception.dart';
import '../../utils/exception/my_platform_exception.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  // Constant representing no user
  static const String noUser = 'NoUser';

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      if (user.emailVerified) {
        // Initialize User Specific Storage
        await MyStorageUtility.init(user.uid);

        Get.offAll(() => const NavigationBarMenu());
      } else {
        final userEmail = user.email ?? noUser; // Use noUser if email is null
        Get.offAll(() => VerifyEmailScreen(
          email: userEmail,
        ));
      }
    } else {
      // Set user to noUser when it is null
      if (kDebugMode) {
        print('======== GET Storage Auth Repo =======');
        print(deviceStorage.read('IsFirstTime'));
      }

      // If IsFirstTime is not set or is set to true, navigate to OnBoardingScreen
      if (deviceStorage.read('IsFirstTime') != false) {
        deviceStorage.write('IsFirstTime', true); // Set IsFirstTime to true
        Get.offAll(const OnBoardingScreen());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    }
  }

  /// Sign in (email authentication)
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Register (email authentication)
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Email verification (mail verification)
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      print('Checking Firestore for existing user with email: $email');

      // Query Firestore to get all documents in the "Users" collection
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firestore.collection('Users').get();

      // Check if there are any documents with the same values for the "Email" field
      bool hasSameEmail =
      querySnapshot.docs.any((document) => document['Email'] == email);

      if (hasSameEmail) {
        print(
            'There is a document with the same email in the "Users" collection.');
      } else {
        print(
            'No document found with the same email in the "Users" collection.');
      }

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
      in querySnapshot.docs) {
        // Print the value of the "Email" field from the document
        String documentEmail = document['Email'];

        // Check if the email is already registered
        if (documentEmail == email) {
          // If the document's email matches the input email, return true
          return true;
        }
      }

      // If no matching email is found in any document, return false
      return false;
    } catch (e) {
      // If an error occurs, handle it accordingly
      print('Error checking Firestore: $e');
      return false;
    }
  }

  /// ReAuthenticate user (reauthenticate)
  Future<void> ReAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      // Create a credential
      AuthCredential credential =
      EmailAuthProvider.credential(email: email, password: password);

      await _auth.currentUser?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Forget password (email authentication)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Google Sign-In (google authentication)
  Future<UserCredential> signInWithGoogle() async {
    try {
      print("Starting Google Sign-In process");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted');
      }

      print("Google Sign-In successful, obtaining auth details");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("Signing in with credential");
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      print("Google Sign-In successful, user: ${userCredential.user?.email}");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      throw e.message ?? 'An error occurred during Google Sign-In';
    } catch (e) {
      print("General Exception: $e");
      throw e.toString();
    }
  }

  /// Facebook (facebook authentication)
  /// valid for any authentication (logout user)
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Remove user auth and Firestore account (delete user)
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Upload any image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
