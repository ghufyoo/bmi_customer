import 'package:bmi_order/controller/firestore_controller.dart';
import 'package:bmi_order/model/user_model.dart';
import 'package:bmi_order/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:bmi_order/screens/auth/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  late Rx<GoogleSignInAccount?> googleSignInAccount;
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    // _user.bindStream(auth.userChanges());
    // ever(_user, _initialScreen);
    googleSignInAccount = Rx<GoogleSignInAccount?>(googleSignIn.currentUser);

    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);

    googleSignInAccount.bindStream(googleSignIn.onCurrentUserChanged);
    ever(googleSignInAccount, _setInitialScreenGoogle);
  }

  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) {
    if (googleSignInAccount == null) {
      // if the user is not found then the user is navigated to the Register Screen
      Get.offAll(() => const LoginScreen());
    } else {
      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(() => const MenuScreen());
    }
  }

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await auth.signInWithCredential(credential);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  _initialScreen(User? user) {
    if (user == null) {
      // Get.offAll(() => MyApp());
      Get.offAll(() => const LoginScreen());
    } // else if (!user.emailVerified) {
    //  sendVerificationEmail();
    //  Get.to(const EmailVerificationScreen());
    // }
    else {
      FirestoreController.instance.getUserNickname(
          AuthController.instance.auth.currentUser!.email.toString());
      // Get.offAll(() => const ReceiptScreen(
      //       receiptUniqueId: '1drZNvsI0UAchOZBNGDm',
      //     ));
      Get.offAll(() => const MenuScreen());
    }
  }

//VERIFY EMAIL
  Future sendVerificationEmail() async {
    try {
      final user = AuthController().auth.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Get.snackbar('$e', 'Verification');
    }
  }

//CHECK EMAIL VERIFICATION
  Future checkEmailVerified() async {
    await AuthController.instance.auth.currentUser!.reload();
  }

  void register(
    String email,
    nickname,
    phonenumber,
    password,
  ) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {});

      final user = Users(
        nickname: nickname,
        email: email,
        phone: phonenumber,
      );
      FirestoreController.instance.createUser(user);
    } catch (e) {
      Get.snackbar(
        "About User",
        "User message",
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Registration Failed",
          style: TextStyle(color: Colors.black),
        ),
        messageText: const Text(
          'Please Try Again',
          style: TextStyle(color: Colors.black),
        ),
      );
    }
  }

  void login(String email, password, bool isEnglish) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar(
        "About Login",
        "Login message",
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          isEnglish ? "Log Masuk Gagal" : "Login failed",
          style: const TextStyle(color: Colors.black),
        ),
        messageText: Text(
          isEnglish
              ? 'Sila pastikan Email atau Password Anda Betul'
              : 'Please make sure your email or password is right',
          style: const TextStyle(color: Colors.black),
        ),
      );
      Get.offAll(const LoginScreen());
    }
  }

  void logOut() async {
    await auth.signOut();
  }
}
