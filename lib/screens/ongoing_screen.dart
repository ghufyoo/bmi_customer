import 'package:bmi_order/helper/const.dart';
import 'package:bmi_order/screens/menu_screen.dart';
import 'package:bmi_order/screens/past_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import 'profile_screen.dart';

class OngoingScreen extends StatefulWidget {
  const OngoingScreen({Key? key}) : super(key: key);

  @override
  _OngoingScreenState createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: const Text(
          'Ongoing Order ',
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
                Navigator.pop(context);
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
      body: const OngoingStream(),
    );
  }
}

class OngoingStream extends StatelessWidget {
  const OngoingStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseFirestore
          .collection('newOrder')
          .where('userEmail',
              isEqualTo: AuthController().auth.currentUser?.email.toString())
          .where('isDone', isEqualTo: false)
          .where('isPaid', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final orderss = snapshot.data?.docs;
        // final order = snapshot.data?.docs;
        List<OngoingUI> ticketKitchen = [];
        for (var ticket in orderss!) {
          final customerEmail = ticket.get('userEmail');
          final customerName = ticket.get('userName');
          final customerPhonenumber = ticket.get('userPhoneNumber');
          final receiptTime = ticket.get('currentTime');
          final receiptDate = ticket.get('currentDate');
          final receiptId = ticket.get('receiptId');
          final receiptUniqueId = ticket.get('ticketId');
          final buzzerNumber = ticket.get('buzzerNumber');
          final menuName = List.from(ticket.get('menuName'));
          final menuPrice = List.from(ticket.get('menuPrice'));
          final menuTopping = List.from(ticket.get('menuTopping'));
          final menuQuantity = List.from(ticket.get('menuQuantity'));
          final totalPrice = ticket.get('totalPrice');
          final totalFoods = ticket.get('totalFoods');
          final totalDrinks = ticket.get('totalDrinks');
          final isDone = ticket.get('isDone');
          final isPickup = ticket.get('isPickup');
          final isPaid = ticket.get('isPaid');

          final messageBubble = OngoingUI(
            orderLength: orderss.length,
            customerEmail: customerEmail,
            customerName: customerName,
            customerPhonenumber: customerPhonenumber,
            receiptTime: receiptTime,
            receiptDate: receiptDate,
            receiptId: receiptId,
            receiptUniqueId: receiptUniqueId,
            buzzerNumber: buzzerNumber,
            menuTopping: menuTopping,
            menuName: menuName,
            menuPrice: menuPrice,
            menuQuantity: menuQuantity,
            totalDrinks: totalDrinks,
            totalFoods: totalFoods,
            totalPrice: totalPrice,
            isPaid: isPaid,
            isPickup: isPickup,
            isDone: isDone,
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

// ignore: must_be_immutable
class OngoingUI extends StatefulWidget {
  OngoingUI(
      {Key? key,
      required this.orderLength,
      required this.customerEmail,
      required this.customerName,
      required this.customerPhonenumber,
      required this.receiptTime,
      required this.receiptDate,
      required this.receiptUniqueId,
      required this.receiptId,
      required this.buzzerNumber,
      required this.menuTopping,
      required this.menuName,
      required this.menuPrice,
      required this.menuQuantity,
      required this.totalDrinks,
      required this.totalFoods,
      required this.totalPrice,
      required this.isPaid,
      required this.isPickup,
      required this.isDone})
      : super(key: key);

  final int orderLength;
  final String customerEmail;
  final String customerName;
  final String customerPhonenumber;
  final String receiptTime;
  final String receiptDate;
  final num receiptId;
  final num receiptUniqueId;
  final num buzzerNumber;
  final List<dynamic> menuTopping;
  final List<dynamic> menuName;
  final List<dynamic> menuPrice;
  final List<dynamic> menuQuantity;
  final num totalDrinks;
  final num totalFoods;
  final num totalPrice;
  // final List<dynamic> price;
  // final List<dynamic> quantity;
  // final List<dynamic> dishName;
  // final List<dynamic> dishTopping;

  bool isPaid;
  bool isPickup;
  bool isDone;

  @override
  _OngoingUIState createState() => _OngoingUIState();
}

class _OngoingUIState extends State<OngoingUI> {
  format() {
    if (widget.menuTopping.contains('{}')) {}
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: Colors.grey[200],
            ),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Order No: ${widget.receiptId}',
                    style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                Center(
                  child: Text(
                    'Buzzer Number: ${widget.buzzerNumber}',
                    style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black),
                  ),
                ),
                const Text(
                    'Sedang Disediakan Sila Tunggu Hingga Buzzer Anda Berbunyi'),
                Center(
                  child: Text(
                    'Dipesan pada Pukul ${widget.receiptTime} Pada Hari Ini',
                    style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenSize.width / 2,
                      child: const Text(
                        'Menu',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Quantity',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        'RM',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.95,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.menuName.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                        width: screenSize.width / 2,
                                        child: Text('${index + 1}~' +
                                            widget.menuName[index])),
                                    widget.menuTopping[index] != "{}"
                                        ? SizedBox(
                                            width: screenSize.width / 2,
                                            child: Text(
                                              widget.menuTopping[index]
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                            ),
                                          )
                                       
                                        : const Text('Tiada Topping'),
                                  ],
                                ),
                                const Spacer(),
                                Text('${widget.menuQuantity[index]}'),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text('${widget.menuPrice[index]}'),
                                ),
                              ],
                            );
                          }),
                    ),
                    Container(
                      height: 2,
                      width: screenSize.width * 0.95,
                      color: Colors.black,
                    ),
                    Center(
                      child: Text(
                        'Jumlah RM${widget.totalPrice}',
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
