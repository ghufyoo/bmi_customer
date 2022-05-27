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
  var _loadingEnglish = false;
  bool _isHidden = true;
  bool isEnglish = false;
  String language = 'Eng';
  String choiceLanguage = 'Tukar Bahasa  ';
  void _onSubmitLoadingEnglish() {
    setState(() => _loadingEnglish = true);
    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() {
        if (isEnglish == false) {
          language = "BM";
          choiceLanguage = "Change Language ";
          isEnglish = true;
        } else if (isEnglish == true) {
          language = "Eng";
          choiceLanguage = 'Tukar Bahasa ';
          isEnglish = false;
        }
        _loadingEnglish = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Made With   "),
              Image.asset(
                "images/EasyOrder.png",
                width: 70,
                height: 70,
              ),
            ],
          ),
          backgroundColor: Colors.black,
          toolbarHeight: MediaQuery.of(context).size.height / 8,
          leading: Container(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width / 2, 50.0),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$choiceLanguage : '),
                  !_loadingEnglish
                      ? InkWell(
                          child: Center(
                            child: Container(
                              width: 70,
                              height: 30,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                color: Colors.teal,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.6),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(
                                        0, 5), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Text(
                                language,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: () {
                            _onSubmitLoadingEnglish();
                          },
                        )
                      : LoadingAnimationWidget.newtonCradle(
                          color: Colors.black, size: 30)
                ],
              ),
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('images/web-logo.png'),
                  ),
                ),
              ),
              Center(
                  child: Text(
                isEnglish
                    ? 'Sila Log Masuk Untuk Membuat Pesanan\n Tidak Perlu Beratur'
                    : 'Please Log In To Make An Order\n No Need To Que',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              )),
              const SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  onChanged: (value) {},
                  decoration: kTextFieldDecoration.copyWith(
                      prefixIcon: const Icon(Icons.mail),
                      hintText:
                          isEnglish ? 'Taip Email Anda' : 'Enter Your Email',
                      label: const Text('Email')),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: _isHidden,
                  textAlign: TextAlign.center,
                  onChanged: (value) {},
                  decoration: kTextFieldDecoration.copyWith(
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },

                        /// This is Magical Function
                        child: Icon(
                          !_isHidden
                              ?

                              /// CHeck Show & Hide.
                              Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      hintText: isEnglish
                          ? 'Taip Kata Laluan Anda'
                          : 'Enter your password',
                      label: Text(isEnglish ? 'Kata Laluan' : 'Password')),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              !_loading
                  ? RoundedButton(
                      title: isEnglish ? 'Log Masuk' : 'Log In',
                      colour: Colors.teal.shade700,
                      onPressed: () async {
                        AuthController.instance.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            isEnglish);
                        setState(() => _loading = true);
                      })
                  : LoadingAnimationWidget.newtonCradle(
                      color: Colors.black, size: 70),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 14,
              ),
              Center(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isEnglish ? "Baru?  " : "New?  ",
                    style: const TextStyle(fontSize: 19, color: Colors.black),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(RegistrationScreen(
                        isEnglish: isEnglish,
                      ));
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
                            offset: const Offset(
                                0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                        isEnglish ? "Daftar Dahulu" : "Register",
                        style: const TextStyle(
                            fontSize: 19, color: Colors.blueAccent),
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
                      text: isEnglish
                          ? 'Lupa Kata Laluan ?'
                          : 'Forgot Password ?',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                            text: isEnglish ? ' Tekan Sini?' : ' Tap Here?',
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
      ),
    );
  }
}
