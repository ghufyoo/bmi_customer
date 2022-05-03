import 'dart:async';

import 'package:bmi_order/components/roundedbutton.dart';
import 'package:bmi_order/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {

    super.initState();
    isEmailVerified = AuthController.instance.auth.currentUser!.emailVerified;

    if (!isEmailVerified) {
      timer = Timer.periodic(const Duration(seconds: 3),
          (_) => AuthController.instance.checkEmailVerified());
    }
  }

  @override
  void dispose() {

    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Please Check Your Inbox To Verify The Email Below',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Center(
            child: LoadingAnimationWidget.newtonCradle(
                color: Colors.teal, size: 45),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              child: Text(
                AuthController.instance.auth.currentUser!.email.toString(),
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RoundedButton(
              title: 'Re enter your email',
              colour: Colors.teal.shade600,
              onPressed: () async {
                await AuthController.instance.auth.currentUser!.delete();
              })
        ],
      ),
    );
  }
}
