import 'package:bmi_order/controller/auth_controller.dart';
import 'package:bmi_order/controller/firestore_controller.dart';
import 'package:bmi_order/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bmi_order/components/roundedbutton.dart';
import 'package:bmi_order/components/constants.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var emailController = TextEditingController();
  var nicknameController = TextEditingController();
  var phonenumberController = TextEditingController();
  var passwordController = TextEditingController();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/web-logo.png'),
                ),
              ),
            ),
            const Center(
                child: Text(
              'Sila Isi Maklumat Berikut Untuk Daftar Masuk',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            )),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              onChanged: (value) {},
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email', label: const Text('Email')),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: nicknameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              onChanged: (value) {},
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your Nick Name', label: const Text('Name')),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: phonenumberController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              onChanged: (value) {},
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your phone number',
                  label: const Text('Phone Number')),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              onChanged: (value) {},
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                  label: const Text('Password')),
            ),
            const SizedBox(
              height: 24.0,
            ),
            !_loading
                ? RoundedButton(
                    title: 'Register',
                    colour: Colors.lightBlueAccent,
                    onPressed: () async {
                      final validUsername = await FirestoreController.instance
                          .usernameCheck(nicknameController.text);
                      final validUserphonenumber = await FirestoreController
                          .instance
                          .userphonenumberCheck(phonenumberController.text);
                      if (phonenumberController.text == '' ||
                          nicknameController.text == '') {
                        Get.snackbar('Sila isi maklumat berikut', '');
                      } else if (!validUsername) {
                        Get.snackbar('The Username has already been taken',
                            'Please reenter new username');
                      } else if (!validUserphonenumber) {
                        Get.snackbar('The Phonenumber has already been taken',
                            'Please reenter new phonenumber');
                      } else {
                        AuthController.instance.register(
                          emailController.text.trim(),
                          nicknameController.text.trim(),
                          phonenumberController.text.trim(),
                          passwordController.text.trim(),
                        );
                        setState(() => _loading = true);
                      }
                    })
                : LoadingAnimationWidget.newtonCradle(
                    color: Colors.black, size: 70),
            const SizedBox(
              height: 24.0,
            ),
            Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Dah Ada Akaun?  ",
                  style: TextStyle(fontSize: 19, color: Colors.black),
                ),
                InkWell(
                  onTap: () {
                    Get.to(const LoginScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset:
                              const Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 19, color: Colors.blueAccent),
                    ),
                  ),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
