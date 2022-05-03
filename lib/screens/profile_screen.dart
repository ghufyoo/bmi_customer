import 'package:bmi_order/screens/past_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/constants.dart';
import '../components/roundedbutton.dart';
import '../controller/auth_controller.dart';
import '../controller/firestore_controller.dart';
import 'menu_screen.dart';
import 'ongoing_screen.dart';

// ignore: camel_case_types
class Profile_Screen extends StatefulWidget {
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

// ignore: camel_case_types
class _Profile_ScreenState extends State<Profile_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: const Text(
          'Cendol BMI Pekan Nilai',
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 50.0,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.teal,
                ),
                child: Text(
                    'Hi ${AuthController.instance.auth.currentUser?.email.toString()}'),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Get.to(const MenuScreen());
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Get.to(const Profile_Screen());
              },
            ),
            ListTile(
              title: const Text('Ongoing Order'),
              onTap: () {
                Get.to(const OngoingScreen());
              },
            ),
            ListTile(
              title: const Text('Past Order'),
              onTap: () {
                Get.to(const PastScreen());
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                AuthController.instance.logOut();
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return const SingleChildScrollView(
          child: ProfileStream(),
        );
      }),
    );
  }
}

var phoneNumber = TextEditingController();

class ProfileStream extends StatelessWidget {
  const ProfileStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirestoreController.instance.readUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final data = snapshot.data;

        var userEmail = TextEditingController(text: "${data?["email"]}");
        var userNickname = TextEditingController(text: "${data?["nickname"]}");

        return Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text('Email'),
              TextField(
                readOnly: true,
                controller: userEmail,
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                onChanged: (value) {},
                decoration: kTextFieldDecoration.copyWith(hintText: ''),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Nickname'),
              TextField(
                readOnly: true,
                controller: userNickname,
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                onChanged: (value) {},
                decoration: kTextFieldDecoration.copyWith(hintText: ''),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Phone Number'),
              TextField(
                controller: phoneNumber,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                onChanged: (value) {},
                decoration: kTextFieldDecoration.copyWith(
                    hintText: '${data?["phonenumber"]}'),
              ),
              const SizedBox(
                height: 10,
              ),
              RoundedButton(
                  title: 'Update Your Phone Number',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    if (phoneNumber.text == '') {
                      Get.snackbar('Please enter new number', '');
                    } else {
                      await FirebaseFirestore.instance
                          .collection('UserInformation')
                          .doc(AuthController.instance.auth.currentUser!.email)
                          .update({'phonenumber': phoneNumber.text.trim()});
                      Get.snackbar(
                          "Successful", 'New Number : ${phoneNumber.text}');
                    }
                  }),
            ],
          ),
        );
      },
    );
  }
}
