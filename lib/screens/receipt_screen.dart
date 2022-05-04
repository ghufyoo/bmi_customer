import 'package:bmi_order/helper/const.dart';
import 'package:bmi_order/screens/cart_screen.dart';
import 'package:bmi_order/screens/ongoing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bmi_order/screens/menu_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/auth_controller.dart';
import '../components/roundedbutton.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

num recId = 0;

class ReceiptScreen extends StatefulWidget {
  static const String id = 'receipt_screen';
  const ReceiptScreen({Key? key, required this.receiptId}) : super(key: key);
  final num receiptId;
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(AddToCartVM());
    setState(() {
      html.window.onBeforeUnload.listen((event) async {
        firebaseFirestore
            .collection('newOrder')
            .where('userEmail',
                isEqualTo:
                    AuthController().auth.currentUser?.email.toString()) //
            .where('receiptId', isEqualTo: widget.receiptId)
            .get()
            .then((value) {
          for (var element in value.docs) {
            firebaseFirestore
                .collection('newOrder')
                .doc(element.id)
                .delete()
                .then((value) {
              Get.snackbar(
                  'Order Failed', 'You have failed to make the Payment');
              Get.offAll(const MenuScreen());
            });
          }
        });
      });
    });
    return Scaffold(
        backgroundColor: Colors.teal[900],
        body: ReceiptStream(
          receiptId: widget.receiptId,
        ));
  }
}

class ReceiptStream extends StatelessWidget {
  const ReceiptStream({Key? key, required this.receiptId}) : super(key: key);
  final num receiptId;
  @override
  Widget build(BuildContext context) {
    recId = receiptId;
    var today = DateTime.now();
    today = DateTime(today.year, today.month, today.day, today.hour,
        today.minute, today.second);
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseFirestore
          .collection('newOrder')
          .where('userEmail', isEqualTo: auth.currentUser!.email.toString())
          .where('ticketId', isEqualTo: receiptId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: [
              Center(
                child: LoadingAnimationWidget.newtonCradle(
                    color: Colors.white, size: 70),
              ),
            ],
          );
        }
        final orderss = snapshot.data?.docs;
        // final order = snapshot.data?.docs;
        List<ReceiptUI> ticketKitchen = [];
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
          final menuToppingName = List.from(ticket.get('menuToppingName'));
          final menuToppingPrice = List.from(ticket.get('menuToppingPrice'));
          final menuQuantity = List.from(ticket.get('menuQuantity'));
          final totalPrice = ticket.get('totalPrice');
          final totalFoods = ticket.get('totalFoods');
          final totalDrinks = ticket.get('totalDrinks');
          final isDone = ticket.get('isDone');
          final isPickup = ticket.get('isPickup');
          final isPaid = ticket.get('isPaid');

          final messageBubble = ReceiptUI(
            orderLength: orderss.length,
            customerEmail: customerEmail,
            customerName: customerName,
            customerPhonenumber: customerPhonenumber,
            receiptTime: receiptTime,
            receiptDate: receiptDate,
            buzzerNumber: buzzerNumber,
            receiptId: receiptId,
            receiptUniqueId: receiptUniqueId,
            menuToppingName: menuToppingName,
            menuToppingPrice: menuToppingPrice,
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
        return Center(
          child: ListView(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            children: ticketKitchen,
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ReceiptUI extends StatefulWidget {
  ReceiptUI(
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
      required this.menuToppingName,
      required this.menuToppingPrice,
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
  final List<dynamic> menuToppingName;
  final List<dynamic> menuToppingPrice;
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
  _ReceiptUIState createState() => _ReceiptUIState();
}

class _ReceiptUIState extends State<ReceiptUI> {
  final bool _loading = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(children: [
      widget.isPaid
          ? InkWell(
              onTap: () {
                Get.offAll(() => const OngoingScreen());
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Colors.teal.shade900,
                      border: Border.all(width: 5.0, color: Colors.white)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('images/web-logo.png'),
                      const Center(
                        child: Text('Cendol BMI E-Receipt',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Center(
                        child: Text(
                          'Nama: ' + widget.customerName,
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Nombor Telefon: ' + widget.customerPhonenumber,
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Nombor Order: #' + widget.receiptId.toString(),
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Buzzer Number: ' + widget.buzzerNumber.toString(),
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: screenSize.width / 2,
                            child: const Text(
                              'Menu',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Quantity',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'RM',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenSize.width * 0.95,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.menuName.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                              width: screenSize.width / 2,
                                              child: Text(
                                                '${index + 1}~' +
                                                    widget.menuName[index],
                                                style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              )),
                                          widget.menuToppingName[index] != ''
                                              ? SizedBox(
                                                  width: screenSize.width / 3,
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: widget
                                                          .menuToppingName
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return SizedBox(
                                                          width:
                                                              screenSize.width /
                                                                  2,
                                                          child: Text(
                                                            widget.menuToppingName[
                                                                        index]
                                                                    .toString() +
                                                                '(${widget.menuToppingPrice[index]})',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: const TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        );
                                                      }),
                                                )
                                              : const Text('Tiada Topping'),
                                        ],
                                      ),
                                      Text(
                                        '${widget.menuQuantity[index]}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          '${widget.menuPrice[index]}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      )
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
                                  color: Colors.white),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Kalau Sedap Bagitahu Kawan, Tidak Sedap Bagitahu Kami',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            width: screenSize.width / 2,
                            height: 2,
                            color: Colors.white,
                          ),
                          const Center(
                            child: Text(
                              'Terima Kasih',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Receipt Ini Boleh Dijumpai dalam Past Order',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          ),
                          Center(
                            child: Text(
                              '#' + widget.receiptUniqueId.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Tekan Untuk Kembali',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            )
          : Center(
              child: Column(
                children: [
                  Center(
                    child: Image.asset('images/web-logo.png'),
                  ),
                  LoadingAnimationWidget.newtonCradle(
                      color: Colors.white, size: 90),
                  const Center(
                    child: Text(
                      'Sila Bayar Di Kaunter',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Tunjukkan Nombor Ini',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.receiptId.toString(),
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 70,
                          color: Colors.white),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Pada Cashier',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Untuk Selsaikan Order',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Center(
                    child: Text(
                      'Jumlah Yang Perlu DiBayar',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      'RM${widget.totalPrice}',
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 55,
                          color: Colors.white),
                    ),
                  ),
                  !_loading
                      ? RoundedButton(
                          title: 'Cancel Transaction ',
                          colour: const Color.fromRGBO(244, 67, 54, 1),
                          onPressed: () async {
                            await firebaseFirestore
                                .collection('newOrder')
                                .where('userEmail',
                                    isEqualTo: AuthController()
                                        .auth
                                        .currentUser
                                        ?.email
                                        .toString())
                                .where('ticketId', isEqualTo: recId)
                                .get()
                                .then((value) {
                              for (var element in value.docs) {
                                firebaseFirestore
                                    .collection('newOrder')
                                    .doc(element.id)
                                    .delete()
                                    .then((value) {
                                  Get.snackbar('Order Failed',
                                      'You have failed to make the Payment');
                                  Get.to(const CartScreen());
                                });
                              }
                            });
                          })
                      : LoadingAnimationWidget.newtonCradle(
                          color: Colors.white, size: 90),
                ],
              ),
            ),
      const SizedBox(
        height: 15,
      )
    ]);
  }
}
