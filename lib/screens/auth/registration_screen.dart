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
  const RegistrationScreen({Key? key, this.isEnglish}) : super(key: key);
  final bool? isEnglish;
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var emailController = TextEditingController();
  var nicknameController = TextEditingController();
  var phonenumberController = TextEditingController();
  var passwordController = TextEditingController();
  var cpasswordController = TextEditingController();
  bool _loading = false;
  bool isPasswordLong = false;
  bool _isHidden = true;
  bool _isHidden2 = true;
  bool _passwordNotSame = true;
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
                "images/GLIPPY.png",
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
        body: SingleChildScrollView(
          child: Padding(
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
                Center(
                    child: Text(
                  widget.isEnglish!
                      ? 'Sila Isi Maklumat Berikut Untuk Daftar Masuk'
                      : 'Please Enter Your Details To Register',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                      prefixIcon: const Icon(Icons.mail),
                      hintText: widget.isEnglish!
                          ? 'Taip Email Anda'
                          : 'Enter your email',
                      label: const Text('Email')),
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
                      prefixIcon: const Icon(Icons.person),
                      hintText: widget.isEnglish!
                          ? 'Taip Nama Panggilan Anda'
                          : 'Enter your Nick Name',
                      label: Text(widget.isEnglish! ? 'Nama' : 'Name')),
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
                      prefixIcon: const Icon(Icons.phone),
                      hintText: widget.isEnglish!
                          ? 'Taip Nombor Telefon Anda'
                          : 'Enter your phone number',
                      label: Text(widget.isEnglish!
                          ? 'Nombor Telefon'
                          : 'Phone Number')),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: _isHidden,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
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
                      hintText: widget.isEnglish!
                          ? 'Taip Kata Laluan Anda'
                          : 'Enter your New password',
                      label: Text(widget.isEnglish!
                          ? 'Kata Laluan Baharu'
                          : 'New Password')),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: cpasswordController,
                  obscureText: _isHidden2,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    if (value != passwordController.text) {
                      setState(() {
                        _passwordNotSame = false;
                      });
                    } else {
                      setState(() {
                        _passwordNotSame = true;
                      });
                    }
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            _isHidden2 = !_isHidden2;
                          });
                        },

                        /// This is Magical Function
                        child: Icon(
                          !_isHidden2
                              ?

                              /// CHeck Show & Hide.
                              Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      hintText: widget.isEnglish!
                          ? 'Taip Kata Laluan Baharu Anda'
                          : 'Enter your New password',
                      label: _passwordNotSame
                          ? Text(widget.isEnglish!
                              ? 'Pastikan Kata Laluan Baharu Anda'
                              : 'Confirm New Password')
                          : Text(
                              widget.isEnglish!
                                  ? 'KATA LALUAN TIDAK SAMA'
                                  : 'PASSWORD NOT SAME',
                              style: const TextStyle(color: Colors.red),
                            )),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                !_loading
                    ? RoundedButton(
                        title: widget.isEnglish! ? 'Daftar' : 'Register',
                        colour: Colors.blue,
                        onPressed: () async {
                          if (cpasswordController.text !=
                              passwordController.text) {
                            Get.snackbar(
                                widget.isEnglish!
                                    ? 'Kata laluan Anda Tidak Sama'
                                    : 'Please Make sure your pasword is same',
                                '',
                                colorText: Colors.red);
                          } else if (passwordController.text.length >= 6) {
                            final validUsername = await FirestoreController
                                .instance
                                .usernameCheck(nicknameController.text);
                            final validUserphonenumber =
                                await FirestoreController.instance
                                    .userphonenumberCheck(
                                        phonenumberController.text);
                            if (phonenumberController.text == '' ||
                                nicknameController.text == '') {
                              Get.snackbar(
                                  widget.isEnglish!
                                      ? 'Sila isi maklumat berikut'
                                      : 'Please enter your details',
                                  '');
                            } else if (!validUsername) {
                              Get.snackbar(
                                  widget.isEnglish!
                                      ? 'Nama Panggilan anda sudah digunakan'
                                      : 'The nickname has already been taken',
                                  widget.isEnglish!
                                      ? 'Sila gunakan nama pangilan lain'
                                      : 'Please reenter new nickname');
                            } else if (!validUserphonenumber) {
                              Get.snackbar(
                                  widget.isEnglish!
                                      ? 'Nombor telefon anda sudah digunakan'
                                      : 'The Phonenumber has already been taken',
                                  widget.isEnglish!
                                      ? 'Sila guna nombor telefon baharu'
                                      : 'Please reenter new phonenumber');
                            } else {
                              AuthController.instance.register(
                                emailController.text.trim(),
                                nicknameController.text.trim(),
                                phonenumberController.text.trim(),
                                passwordController.text.trim(),
                              );
                              setState(() => _loading = true);
                            }
                          } else {
                            Get.snackbar(
                                widget.isEnglish!
                                    ? 'Kata laluan baharu mesti melebihi 6 huruf'
                                    : 'New Pasword Must Be More Than 6 Character',
                                '',
                                colorText: Colors.red);
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
                    Text(
                      widget.isEnglish! ? 'Ada akaun?  ' : "Got an account?  ",
                      style: const TextStyle(fontSize: 19, color: Colors.black),
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
                              offset: const Offset(
                                  0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Text(
                          widget.isEnglish! ? 'Log Masuk' : "Login",
                          style: const TextStyle(
                              fontSize: 19, color: Colors.blueAccent),
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
