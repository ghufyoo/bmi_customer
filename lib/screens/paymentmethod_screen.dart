import 'package:bmi_order/controller/auth_controller.dart';
import 'package:bmi_order/screens/receipt_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controller/cart_controller.dart';
import '../controller/firestore_controller.dart';
import '../model/order_model.dart';

final _firestore = FirebaseFirestore.instance;
final auth = Get.put(AuthController());
//final User user = auth.auth.currentUser!;
DateTime now = DateTime.now();
dynamic currentTime = DateFormat.jm().format(DateTime.now());
dynamic currentDate = DateFormat.yMd().format(DateTime.now());
String datetime = DateFormat('dd-MM-yyyy – HH:mm').format(now);
num id = 255;
var store = _firestore.collection('newOrder');
//String ticketId = user.uid;
late bool exist;

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({
    Key? key,
    required this.ticketNumber,
    required this.userName,
    required this.userEmail,
    required this.userPhonenumber,
    required this.uniqueTicketNumber,

    /*required this.m*/
  }) : super(key: key);
  // final Map<String, num> m;
  final String userName;
  final String userEmail;
  final String userPhonenumber;
  final num ticketNumber;
  final String uniqueTicketNumber;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool _loading = false;
  List<Map<String, num>> menuToppingPrice = [];
  Map<dynamic, dynamic> theSnapShot = {};
  List<Map<String, String>> menuToppingName = [];
  String? _token;
  Stream<String>? _tokenStream;
  int notificationCount = 0;

  void setToken(String? token) {
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                "BFIQRP4_twQWdebyljX-7yWrApT65YxohCu7B6I2oN_3WCRiTvy-fnZ-CH1Z6mOF0rtC7uNY12eSMpZ86SWf6oU")
        .then(setToken);

    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream!.listen(setToken);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddToCartVM());
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
                child: Text('Cara Pembayaran',
                    style: TextStyle(fontSize: 35, color: Colors.black))),
            const Center(
                child: Text('Payment Method',
                    style: TextStyle(fontSize: 25, color: Colors.black))),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Get.snackbar('Sila Bayar Di Kaunter', 'Senangpay Unavailable');
              },
              child: Container(
                width: screenSize.width / 1.5,
                height: screenSize.height / 3,
                child: const Center(
                    child: Text(
                  'Pay With SenangPay',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                )),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            !_loading
                ? GetBuilder<AddToCartVM>(
                    init: AddToCartVM(),
                    builder: (value) => InkWell(
                      onTap: () async {
                        for (int name = 0;
                            name < controller.lst.length;
                            name++) {
                          for (int topping = 0;
                              topping < value.lst[name].menuTopping.length;
                              topping++) {
                            if (value.lst[name].menuName.isEmpty) {
                              print(value.lst[name].menuTopping.keys);
                              theSnapShot.addAll({
                                name.toString(): {
                                  'name': value.lst[name].menuName,
                                  'quantity': value.lst[name].menuQuantity,
                                  'totalPrice': value.lst[name].menuPrice,
                                  'toppingName': [name.toString()],
                                  'toppingPrice': [name],
                                  'iceLevel': value.lst[name].iceLevel,
                                  'sugarLevel': value.lst[name].sugarLevel,
                                  'spicyLevel': value.lst[name].spicyLevel,
                                  'isDrink': value.lst[name].isDrink
                                },
                              });
                            } else {
                              theSnapShot.addAll({
                                name.toString(): {
                                  'name': value.lst[name].menuName,
                                  'quantity': value.lst[name].menuQuantity,
                                  'totalPrice': value.lst[name].menuPrice,
                                  'toppingName':
                                      value.lst[name].menuTopping.keys,
                                  'toppingPrice':
                                      value.lst[name].menuTopping.values,
                                  'iceLevel': value.lst[name].iceLevel,
                                  'sugarLevel': value.lst[name].sugarLevel,
                                  'spicyLevel': value.lst[name].spicyLevel,
                                  'isDrink': value.lst[name].isDrink
                                },
                              });
                            }
                          }
                        }

                        try {
                          controller.toToppingName();
                          controller.toToppingPrice();

                          await _firestore
                              .collection('OrderNumber')
                              .doc('TicketNumber')
                              .update({'id': widget.ticketNumber});
                          final placeOrder = Orders(
                              userEmail: widget.userEmail,
                              userName: widget.userName,
                              userPhoneNumber: widget.userPhonenumber,
                              timestamp: Timestamp.now(),
                              currentTime: currentTime,
                              currentDate: currentDate,
                              receiptId: widget.ticketNumber,
                              receiptUniqueId: widget.uniqueTicketNumber,
                              buzzerNumber: 1,
                              totalDrinks: value.tryTotalDrinks(),
                              totalFoods: value.tryTotalMamu(),
                              totalPrice: value.tryTotal(),
                              order: theSnapShot,
                              isDone: false,
                              isPickup: false,
                              isPaid: false,
                              fcmToken: _token);

                          FirestoreController.instance.placeOrder(
                              placeOrder, widget.uniqueTicketNumber);
                          Get.to(ReceiptScreen(
                            receiptUniqueId: widget.uniqueTicketNumber,
                          ));
                          print(controller.toTopping(controller.toToppingName(),
                              controller.toToppingPrice()));
                        } catch (e) {
                          Get.snackbar('$e', 'message');
                          print('error $e');
                        }
                        setState(() => _loading = true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        width: screenSize.width / 1.5,
                        height: screenSize.height / 3,
                        child: const Center(
                            child: Text(
                          'Bayar Di Kaunter',
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          image: const DecorationImage(
                              image: AssetImage('images/BayarDiKaunter.png'),
                              fit: BoxFit.cover),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                  )
                // ? InkWell(
                //     onTap: () async {
                //       try {
                //         controller.toToppingName();
                //         controller.toToppingPrice();

                //         await _firestore
                //             .collection('OrderNumber')
                //             .doc('TicketNumber')
                //             .update({'id': widget.ticketNumber});
                //         final placeOrder = Orders(
                //             userEmail: widget.userEmail,
                //             userName: widget.userName,
                //             userPhoneNumber: widget.userPhonenumber,
                //             timestamp: Timestamp.now(),
                //             currentTime: currentTime,
                //             currentDate: currentDate,
                //             receiptId: widget.ticketNumber,
                //             receiptUniqueId: widget.uniqueTicketNumber,
                //             buzzerNumber: 1,
                //             totalDrinks: controller.tryTotalDrinks(),
                //             totalFoods: controller.tryTotalMamu(),
                //             totalPrice: controller.tryTotal(),
                //             menuTopping: controller.toTopping(
                //                 controller.toToppingName(),
                //                 controller.toToppingPrice()),
                //             menuToppingName: controller.toToppingName(),
                //             menuToppingPrice: controller.toToppingPrice(),
                //             menuName: controller.toName(),
                //             menuPrice: controller.toPrice(),
                //             menuQuantity: controller.toQuantity(),
                //             iceLevel: controller.toiceLevel(),
                //             sugarLevel: controller.tosugarLevel(),
                //             spicyLevel: controller.tospicyLevel(),
                //             isDone: false,
                //             isPickup: false,
                //             isPaid: false,
                //             isDrink: controller.toisDrink());

                //         FirestoreController.instance
                //             .placeOrder(placeOrder, widget.uniqueTicketNumber);
                //         Get.to(ReceiptScreen(
                //           receiptId: widget.uniqueTicketNumber,
                //         ));
                //         print(controller.toTopping(controller.toToppingName(),
                //             controller.toToppingPrice()));
                //       } catch (e) {
                //         Get.snackbar('$e', 'message');
                //         print('error $e');
                //       }

                //     },
                //     child: Container(
                //       width: screenSize.width / 1.5,
                //       height: screenSize.height / 1.7,
                //       child: const Center(child: Text('')),
                //       decoration: BoxDecoration(
                //         color: Colors.teal,
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.grey.withOpacity(0.5),
                //             spreadRadius: 3,
                //             blurRadius: 7,
                //             offset: const Offset(
                //                 0, 3), // changes position of shadow
                //           ),
                //         ],
                //         image: const DecorationImage(
                //             image: AssetImage('images/BayarDiKaunter.png'),
                //             fit: BoxFit.cover),
                //         borderRadius:
                //             const BorderRadius.all(Radius.circular(20.0)),
                //       ),
                //     ),
                //   )
                : LoadingAnimationWidget.newtonCradle(
                    color: Colors.white, size: 90),
          ],
        ),
      ),
    );
  }
}
