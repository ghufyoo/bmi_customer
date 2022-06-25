import 'package:bmi_order/controller/auth_controller.dart';
import 'package:bmi_order/screens/cart_screen.dart';
import 'package:bmi_order/screens/ongoing_screen.dart';
import 'package:bmi_order/screens/past_screen.dart';
import 'package:bmi_order/screens/profile_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
  static const routeName = "/firebase-push";
  static const String id = 'menu_screen';

  const MenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  DateTime now = DateTime.now();
  String? _token;
  Stream<String>? _tokenStream;
  int notificationCount = 0;

  void setToken(String? token) {
    print('FCM TokenToken: $token');
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    //getPermission();
    messageListener(context);
    //FirebaseMessaging.instance
    //    .getToken(
    //         vapidKey:
    //           "BFIQRP4_twQWdebyljX-7yWrApT65YxohCu7B6I2oN_3WCRiTvy-fnZ-CH1Z6mOF0rtC7uNY12eSMpZ86SWf6oU")
    //   .then(setToken);

    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream!.listen(setToken);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var qwerty = FirebaseMessaging.instance.getToken();
    var screenSize = MediaQuery.of(context).size;
    String offDay = DateFormat('EEEE').format(now);
    setState(() {
      html.window.onBeforeUnload.listen((event) async {});
    });
    _launchUrl(String url) async {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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
          toolbarHeight: MediaQuery.of(context).size.height / 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(MediaQuery.of(context).size.width / 8),
              // bottom: Radius.elliptical(
              //     MediaQuery.of(context).size.width / 2, 50.0),
            ),
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
        body: StreamBuilder<DocumentSnapshot>(
            stream: firebaseFirestore
                .collection('CendolPekanNilai')
                .doc('1985')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.newtonCradle(
                      color: Colors.black, size: 70),
                );
              } else if (!snapshot.hasData) {
                Center(
                  child: LoadingAnimationWidget.newtonCradle(
                      color: Colors.black, size: 70),
                );
              }
              final isOpen = snapshot.data!;

              return isOpen['isOpen']
                  ? Container(child: const MenuStream())
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Center(
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
                              child: const Text(
                                'Maaf Kedai Tutup,\n Kami Buka Setiap Hari, \nDari 10am - 6pm\nKecuali  Hari Rabu',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 40, color: Colors.teal),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            'Cawangan Cendol BMI',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () => _launchUrl(
                                "https://goo.gl/maps/Wq4NCmdMQJALY58Q8"),
                            child: Center(
                              child: Container(
                                  width: screenSize.width * 0.7,
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
                                  child: const Text(
                                    'BMI Mesamall Nilai',
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () => _launchUrl(
                                "https://goo.gl/maps/M9n6YcjEs6RY9GV26"),
                            child: Center(
                              child: Container(
                                  width: screenSize.width * 0.7,
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
                                  child: const Text(
                                    'BMI Southville City Bangi',
                                    style: TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () => _launchUrl(
                                "https://goo.gl/maps/7Z5dhSkonJM6VdQQ9"),
                            child: Center(
                              child: Container(
                                  width: screenSize.width * 0.7,
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
                                  child: const Text(
                                    'BMI Kipmall Kota Warisan',
                                    style: TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () => _launchUrl(
                                "https://goo.gl/maps/CmXrTTvADxXzbUey9"),
                            child: Center(
                              child: Container(
                                  width: screenSize.width * 0.7,
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
                                  child: const Text(
                                    'BMI BMC Mall Cheras',
                                    style: TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () => _launchUrl(
                                "https://goo.gl/maps/rNYSsbQErWC452ZB9"),
                            child: Center(
                              child: Container(
                                  width: screenSize.width * 0.7,
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
                                  child: const Text(
                                    'BMI Bukit Bintang',
                                    style: TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    );
            }));
  }

  Future<void> getPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus.toString() ==
        'AuthorizationStatus.denied') {
      print('heyyyy');
    }

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void messageListener(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.body}');
        showDialog(
            context: context,
            builder: ((BuildContext context) {
              return DynamicDialog(
                  title: message.notification!.title,
                  body: message.notification!.body);
            }));
      }
    });
  }
}

//push notification dialog for foreground
class DynamicDialog extends StatefulWidget {
  final title;
  final body;
  const DynamicDialog({this.title, this.body});
  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: <Widget>[
        OutlinedButton.icon(
            label: const Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close))
      ],
      content: Text(widget.body),
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
                    fit: BoxFit.fill, image: AssetImage(imgUrl)),
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
