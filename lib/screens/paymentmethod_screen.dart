import 'package:bmi_order/controller/auth_controller.dart';
import 'package:bmi_order/controller/firestore_controller.dart';
import 'package:bmi_order/model/order_model.dart';
import 'package:bmi_order/screens/receipt_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controller/cart_controller.dart';



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
  final num uniqueTicketNumber;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final bool _loading = false;
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
            // InkWell(
            //   onTap: () {
            //     //print(controller.get(i));
            //     print(controller.toMapTopping());
            //   },
            //   child: Container(
            //     width: screenSize.width / 1.5,
            //     height: screenSize.height / 3,
            //     child: Center(child: Text('Pay With SenangPay')),
            //     decoration: BoxDecoration(
            //       color: Colors.blue,
            //       borderRadius: BorderRadius.all(Radius.circular(20.0)),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            !_loading
                ? InkWell(
                    onTap: () async {
                      try {
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
                            totalDrinks: controller.tryTotalDrinks(),
                            totalFoods: controller.tryTotalMamu(),
                            totalPrice: controller.tryTotal(),
                            menuToppingName: controller.toToppingName(),
                            menuToppingPrice: controller.toToppingPrice(),
                            menuName: controller.toName(),
                            menuPrice: controller.toPrice(),
                            menuQuantity: controller.toQuantity(),
                            iceLevel: controller.toiceLevel(),
                            sugarLevel: controller.tosugarLevel(),
                            spicyLevel: controller.tospicyLevel(),
                            isDone: false,
                            isPickup: false,
                            isPaid: false,
                            isDrink: controller.toisDrink());
                    
                        FirestoreController.instance
                            .placeOrder(placeOrder, widget.uniqueTicketNumber);
                        Get.to(ReceiptScreen(
                          receiptId: widget.uniqueTicketNumber,
                        ));
                      } catch (e) {
                        Get.snackbar('$e', 'message');
                      }

                      // store.add({
                      //   'ticket_id': ticketId,
                      //   'user_email': auth.auth.currentUser!.email,
                      //   'receipt_id': widget.ticketNumber,
                      //   'name': controller.toName(),
                      //   'topping': controller.toTopping(),
                      //   'price': controller.toPrice(),
                      //   'quantity': controller.toQuantity(),
                      //   'totalPrice': controller.tryTotal(),
                      //   'totalDrinks': controller.tryTotalDrinks(),
                      //   'totalFoods': controller.tryTotalMamu(),
                      //   'datetime': datetime,
                      //   'currenttime': currentTime,
                      //   'deviceToken': token,
                      //   'isPaid': false,
                      //   'isDone': false,
                      // });
                    },
                    child: Container(
                      width: screenSize.width / 1.5,
                      height: screenSize.height / 1.7,
                      child: const Center(child: Text('')),
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
                  )
                : LoadingAnimationWidget.newtonCradle(
                    color: Colors.white, size: 90),
          ],
        ),
      ),
    );
  }
}
