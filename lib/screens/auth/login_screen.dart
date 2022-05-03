import 'package:bmi_order/screens/auth/registration_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bmi_order/components/roundedbutton.dart';
import 'package:bmi_order/components/constants.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../controller/auth_controller.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
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
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('images/web-logo.png'),
                ),
              ),
            ),
            const Center(
                child: Text(
              'Sila Log Masuk Untuk Membuat Pesanan',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black),
            )),
            const Center(
                child: Text(
              'Please Log In To Make An Order',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
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
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              textAlign: TextAlign.center,
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
                    title: 'Log In',
                    colour: Colors.lightBlueAccent,
                    onPressed: () {
                      AuthController.instance.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      setState(() => _loading = true);
                    })
                : LoadingAnimationWidget.newtonCradle(
                    color: Colors.black, size: 70),
            const SizedBox(
              height: 10,
            ),
            // const Center(
            //     child: Text(
            //   'Or Log In Using Google',
            //   style: TextStyle(
            //       fontFamily: 'Roboto',
            //       fontWeight: FontWeight.bold,
            //       fontSize: 12,
            //       color: Colors.black),
            // )),
            // SignInButton(
            //   Buttons.Google,
            //   text: "Sign up with Google",
            //   onPressed: () {
            //     AuthController.instance.signInWithGoogle();
            //   },
            // ),
            const SizedBox(
              height: 14,
            ),
            Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Baru?  ",
                  style: TextStyle(fontSize: 19, color: Colors.black),
                ),
                InkWell(
                  onTap: () {
                    Get.to(const RegistrationScreen());
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
                      "Daftar Dahulu",
                      style: TextStyle(fontSize: 19, color: Colors.blueAccent),
                    ),
                  ),
                )
              ],
            )),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                    text: 'Lupa Password ?',
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Tekan Sini?',
                          style: const TextStyle(
                              color: Colors.blueAccent, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const ForgotPasswordScreen());
                            })
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
