import 'package:bmi_order/controller/auth_controller.dart';
import 'package:bmi_order/screens/cart_screen.dart';

import 'package:bmi_order/screens/ongoing_screen.dart';
import 'package:bmi_order/screens/past_screen.dart';
import 'package:bmi_order/screens/profile_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../helper/const.dart';
import 'detailedmenu_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'cart_screen.dart';
import 'package:bmi_order/components/constants.dart';
import 'package:bmi_order/controller/cart_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

FirebaseMessaging messaging = FirebaseMessaging.instance;

class MenuScreen extends StatefulWidget {
  static const String id = 'menu_screen';

  const MenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var qwerty = FirebaseMessaging.instance.getToken();
    String offDay = DateFormat('EEEE').format(now);
    setState(() {
      html.window.onBeforeUnload.listen((event) async {});
    });

    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: const Text(
          'Cendol BMI Pekan Nilai',
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(const CartScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GetBuilder<AddToCartVM>(
                // specify type as Controller
                init: AddToCartVM(), // intialize with the Controller
                builder: (value) => CartCounter(
                  count: value.lst.length.toString(),
                ),
              ),
            ),
          ),
        ],
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
      body: now.hour > 7 && now.hour < 18 && offDay != 'Wednesday'
          ? const MenuStream()
          : Center(
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
                      offset: const Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: const Text(
                  'Maaf Kedai Tutup,\n Kami Buka Setiap Hari, \nDari 10am - 6pm\nKecuali  Hari Rabu',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50, color: Colors.teal),
                ),
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class MenuWidget extends StatelessWidget {
  MenuWidget({
    Key? key,
    required this.imgUrl,
    required this.name,
    required this.price,
    required this.desc,
    required this.onPressed,
    required this.isBadge,
    this.badgeColor = Colors.green,
    this.badgeTag = '',
  }) : super(key: key);
  final String imgUrl;
  final String name;
  final String price;
  final String desc;
  final VoidCallback onPressed;
  final bool isBadge;

  Color badgeColor;
  String badgeTag;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    badgeColor = Colors.green;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Container(
              height: screenSize.height / 5,
              width: screenSize.width / 2,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(imgUrl)),
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenSize.width / 2.5,
                  child: AutoSizeText(
                    name,
                    style: kMenuNameStyle,
                    maxLines: 2,
                  ),
                ),
                Text(
                  'RM' + price,
                  style: kMenuPriceStyle,
                ),
                SizedBox(
                  width: screenSize.width / 2.5,
                  child: AutoSizeText(
                    desc,
                    style: kMenuDescStyle,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isBadge
                        ? Badge(
                            toAnimate: false,
                            shape: BadgeShape.square,
                            badgeColor: badgeColor,
                            borderRadius: BorderRadius.circular(8),
                            badgeContent: Text(badgeTag,
                                style: const TextStyle(color: Colors.white)),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class MenuStream extends StatelessWidget {
  const MenuStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseFirestore
          .collection('Menu')
          .orderBy(
            FieldPath.documentId,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.newtonCradle(
                color: Colors.white, size: 65),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Column(
            children: [
              Center(
                child: LoadingAnimationWidget.newtonCradle(
                    color: Colors.white, size: 65),
              ),
              const Text('Check Your Internet Connection')
            ],
          );
        }
        final orderss = snapshot.data?.docs;
        // final order = snapshot.data?.docs;
        List<MenuUI> ticketKitchen = [];
        for (var ticket in orderss!) {
          final name = ticket.get('name');
          final price = ticket.get('price');
          final switches = ticket.get('switches');
          final desc = ticket.get('desc');
          final tag = ticket.get('tag');
          final imgUrl = ticket.get('imgUrl');
          final inStock = ticket.get('inStock');
          final isDrink = ticket.get('isDrink');
          final isBadge = ticket.get('isBadge');

          final messageBubble = MenuUI(
            name: name,
            desc: desc,
            price: price,
            switches: switches,
            tag: tag,
            imgUrl: imgUrl,
            inStock: inStock,
            isDrink: isDrink,
            isBadge: isBadge,
          );

          ticketKitchen.add(messageBubble);
        }
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: ticketKitchen,
        );
      },
    );
  }
}

class MenuUI extends StatefulWidget {
  const MenuUI(
      {Key? key,
      required this.name,
      required this.price,
      required this.switches,
      required this.desc,
      required this.tag,
      required this.imgUrl,
      required this.inStock,
      required this.isDrink,
      required this.isBadge})
      : super(key: key);

  final String name;
  final num price;
  final num switches;
  final String desc;
  final String tag;
  final String imgUrl;
  final bool inStock;
  final bool isDrink;
  final bool isBadge;
  @override
  _MenuUIState createState() => _MenuUIState();
}

class _MenuUIState extends State<MenuUI> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuWidget(
          imgUrl: widget.imgUrl,
          name: widget.name,
          price: widget.price.toString(),
          desc: widget.desc,
          onPressed: widget.inStock == true
              ? () {
                  //audioHandler.play();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedmenuScreen(
                        chosenMenu: widget.name,
                        imgUrl: widget.imgUrl,
                        price: widget.price,
                        isDrink: widget.isDrink,
                        switches: widget.switches,
                      ),
                    ),
                  );
                }
              : () {
                  Get.snackbar(
                    "About food",
                    "User food",
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: const Text(
                      "Menu Out Of Stock",
                      style: TextStyle(color: Colors.black),
                    ),
                    messageText: const Text(
                      'Sorry Please come again later',
                      style: TextStyle(color: Colors.green),
                    ),
                  );
                },
          isBadge: widget.isBadge,
          badgeTag: widget.tag,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
