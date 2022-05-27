import 'package:bmi_order/helper/const.dart';
import 'package:bmi_order/screens/cart_screen.dart';
import 'package:bmi_order/screens/ongoing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/auth_controller.dart';
import '../components/roundedbutton.dart';
// ignore: avoid_web_libraries_in_flutter

String recId = '';

class ReceiptScreen extends StatefulWidget {
  static const String id = 'receipt_screen';
  const ReceiptScreen({Key? key, required this.receiptUniqueId})
      : super(key: key);
  final String receiptUniqueId;
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

late ScrollController _scrollController;

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal[900],
        body: ReceiptStream(
          receiptId: widget.receiptUniqueId,
        ));
  }

  dialog() {
    Get.defaultDialog(title: 'allow');
  }
}

class ReceiptStream extends StatelessWidget {
  const ReceiptStream({Key? key, required this.receiptId}) : super(key: key);
  final String receiptId;
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
          final order = ticket.get('order');
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
            receiptId: receiptId,
            receiptUniqueId: receiptUniqueId,
            buzzerNumber: buzzerNumber,
            order: order,
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
      required this.order,
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
  final String receiptUniqueId;
  final num buzzerNumber;
  final Map<String, dynamic> order;
  final num totalDrinks;
  final num totalFoods;
  final num totalPrice;

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
                        child: Text(
                          'Tekan Untuk Kembali',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ),
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
                                itemCount: widget.order.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      <String, dynamic>{};

                                  for (dynamic type in widget.order.keys) {
                                    data[type.toString()] = widget.order[type];
                                  }

                                  List<dynamic> l =
                                      data[index.toString()]['toppingName'];
                                  print('index' +
                                      index.toString() +
                                      '------' +
                                      l.toString());
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
                                                    data[index.toString()]
                                                        ['name'],
                                                style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              )),
                                          SizedBox(
                                            width: screenSize.width / 3,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: l.length,
                                                itemBuilder: (context, indexx) {
                                                  return SizedBox(
                                                    width: screenSize.width / 2,
                                                    child: Text(
                                                      data[index.toString()][
                                                                      'toppingName']
                                                                  [indexx]
                                                              .toString() +
                                                          '(${data[index.toString()]['toppingPrice'][indexx].toString()})',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        data[index.toString()]['quantity']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          data[index.toString()]['totalPrice']
                                              .toString(),
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
                          const SizedBox(
                            height: 15,
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
                              textAlign: TextAlign.center,
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
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.teal.shade900,
                    border: Border.all(width: 5.0, color: Colors.white)),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'images/web-logo.png',
                        width: 200,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("images/decoimgfluttertest.png")),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      width: screenSize.width * 0.95,
                      height: screenSize.height / 2.5,
                      child: Column(
                        children: [
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
                                      color: Colors.black),
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'Quantity',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
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
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: screenSize.width * 0.9,
                            height: screenSize.height / 3.02,
                            child: Scrollbar(
                              thickness: 10,
                              isAlwaysShown: true,
                              controller: _scrollController,
                              child: ListView.builder(
                                  itemCount: widget.order.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        <String, dynamic>{};

                                    for (dynamic type in widget.order.keys) {
                                      data[type.toString()] =
                                          widget.order[type];
                                    }

                                    List<dynamic> l =
                                        data[index.toString()]['toppingName'];
                                    print('index' +
                                        index.toString() +
                                        '------' +
                                        l.toString());
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
                                                      data[index.toString()]
                                                          ['name'],
                                                  style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                )),
                                            SizedBox(
                                              width: screenSize.width / 3,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: l.length,
                                                  itemBuilder:
                                                      (context, indexx) {
                                                    return SizedBox(
                                                      width:
                                                          screenSize.width / 2,
                                                      child: Text(
                                                        data[index.toString()][
                                                                        'toppingName']
                                                                    [indexx]
                                                                .toString() +
                                                            '(${data[index.toString()]['toppingPrice'][indexx].toString()})',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          data[index.toString()]['quantity']
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            data[index.toString()]['totalPrice']
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    LoadingAnimationWidget.newtonCradle(
                        color: Colors.white, size: 90),
                    Center(
                      child: Text(
                        'Jumlah RM${widget.totalPrice} ',
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                            color: Colors.blue),
                      ),
                    ),
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
                        '#' + widget.receiptId.toString(),
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
                    const Center(
                      child: Text(
                        'Tidak perlu beratur terus pergi ke kaunter dan selsaikan pembayaran',
                        textAlign: TextAlign.center,
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
            ),
      const SizedBox(
        height: 15,
      )
    ]);
  }
}
