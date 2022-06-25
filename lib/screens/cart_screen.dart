import 'package:auto_size_text/auto_size_text.dart';
import 'package:bmi_order/controller/cart_controller.dart';
import 'package:bmi_order/model/menu_model.dart';
import 'package:bmi_order/screens/menu_screen.dart';
import 'package:bmi_order/screens/paymentmethod_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_browser_detect/web_browser_detect.dart';
import '../controller/auth_controller.dart';

num id = 1;
num uniqueId = 1;
final _firestore = FirebaseFirestore.instance;

class CartScreen extends StatefulWidget {
  static const String id = 'cart_screen';

  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Menu menu;
  double overallPrice = 0.0;
  num totalPrice = 0;
  String userName = '';
  String userEmail = '';
  String userPhonenumber = '';
  bool isButtonDisabled = false;
  bool _loading = false;

  final controller = Get.put(AddToCartVM());
  fetchDoc() async {
    // enter here the path , from where you want to fetch the doc
    DocumentSnapshot pathData = await FirebaseFirestore.instance
        .collection('UserInformation')
        .doc(AuthController.instance.auth.currentUser!.email)
        .get();

    if (pathData.exists) {
      Map<String, dynamic>? fetchDoc = pathData.data() as Map<String, dynamic>?;

      //Now use fetchDoc?['KEY_names'], to access the data from firestore, to perform operations , for eg
      userName = fetchDoc?['nickname'];
      userEmail = fetchDoc?['email'];
      userPhonenumber = fetchDoc?['phonenumber'];

      // setState(() {});  // use only if needed
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> testTop = [];
    var screenSize = MediaQuery.of(context).size;
    // ever(controller.harga, (value) => print("$value is updated"));
    overallPrice = controller.tryTotal();
    fetchDoc();
    setState(() {});
    final browser = Browser.detectOrNull();
    return Scaffold(
        backgroundColor: Colors.teal[900],
        appBar: AppBar(
          title: const Text('CENDOL BMI CART'),
          backgroundColor: Colors.transparent,
          leading: Align(
            alignment: FractionalOffset.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: IconButton(
                  onPressed: () {
                    Get.to(const MenuScreen());
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  )), //Your widget here,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: GetBuilder<AddToCartVM>(
                  // specify type as Controller
                  init: AddToCartVM(), // intialize with the Controller
                  builder: (value) => Scaffold(
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: value.lst.isNotEmpty
                            ? Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    color: Colors.teal[900],
                                    height: screenSize.height / 0.5,
                                    width: screenSize.width,
                                    child: ListView.builder(
                                      itemCount: value.lst.length,
                                      itemBuilder: (context, index) {
                                        testTop.add(value
                                            .lst[index].menuTopping.keys
                                            .toString());
                                        return Column(
                                          children: [
                                            Container(
                                              width: screenSize.width * 0.99,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(17),
                                                color: Colors.grey[200],
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 3,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        screenSize.width * 0.98,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        value.lst[index]
                                                                    .menuQuantity >
                                                                1
                                                            ? IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .remove_circle,
                                                                  color: isButtonDisabled
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                                onPressed:
                                                                    isButtonDisabled
                                                                        ? null
                                                                        : () {
                                                                            setState(() {
                                                                              value.quanMinus(index);
                                                                              if (value.lst[index].menuQuantity == 0) {
                                                                                value.del(index);
                                                                              }
                                                                            });
                                                                          },
                                                              )
                                                            : IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    value.del(
                                                                        index);
                                                                  });
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .delete_sweep_outlined,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                        Center(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5),
                                                            child: Text(
                                                                '${value.lst[index].menuQuantity}',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.add_circle,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              value.lst[index]
                                                                  .menuQuantity++;
                                                              if (value
                                                                      .lst[
                                                                          index]
                                                                      .menuQuantity >
                                                                  1) {
                                                                isButtonDisabled =
                                                                    false;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: screenSize
                                                                      .width /
                                                                  2,
                                                              child:
                                                                  AutoSizeText(
                                                                value.lst[index]
                                                                    .menuName,
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .black),
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                            value
                                                                    .lst[index]
                                                                    .menuTopping
                                                                    .isNotEmpty
                                                                ? SizedBox(
                                                                    width: screenSize
                                                                            .width /
                                                                        3,
                                                                    child: ListView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: value
                                                                          .lst[
                                                                              index]
                                                                          .menuTopping
                                                                          .keys
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              indexx) {
                                                                        return SizedBox(
                                                                          width:
                                                                              screenSize.width / 2,
                                                                          child:
                                                                              AutoSizeText(
                                                                            '~${value.lst[index].menuTopping.keys.elementAt(indexx)}',
                                                                            style: const TextStyle(
                                                                                fontFamily: 'Roboto',
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 14,
                                                                                color: Colors.black),
                                                                            maxLines:
                                                                                2,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                // ? SizedBox(
                                                                //     width:
                                                                //         screenSize.width /
                                                                //             2,
                                                                //     child: AutoSizeText(
                                                                //       '${value.lst[index].fluttertopping.keys.toString().trim()}',
                                                                //       style: TextStyle(
                                                                //           fontFamily:
                                                                //               'Roboto',
                                                                //           fontWeight:
                                                                //               FontWeight
                                                                //                   .bold,
                                                                //           fontSize: 15,
                                                                //           color: Colors
                                                                //               .white),
                                                                //       maxLines: 7,
                                                                //     ),
                                                                //   )
                                                                : const Text(
                                                                    'Tiada Topping'),
                                                            Container(
                                                              width: screenSize
                                                                      .width /
                                                                  3,
                                                              height: 2,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            value.lst[index]
                                                                        .sugarLevel !=
                                                                    'Normal'
                                                                ? SizedBox(
                                                                    width: screenSize
                                                                            .width /
                                                                        2,
                                                                    child:
                                                                        AutoSizeText(
                                                                      'Level Gula : ${value.lst[index].sugarLevel}',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                      maxFontSize:
                                                                          14,
                                                                      maxLines:
                                                                          2,
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                            value.lst[index]
                                                                        .iceLevel !=
                                                                    'Normal'
                                                                ? SizedBox(
                                                                    width: screenSize
                                                                            .width /
                                                                        2,
                                                                    child:
                                                                        AutoSizeText(
                                                                      'Level Ais : ${value.lst[index].iceLevel}',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                      maxFontSize:
                                                                          14,
                                                                      maxLines:
                                                                          2,
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                            value.lst[index]
                                                                        .spicyLevel !=
                                                                    'Normal'
                                                                ? SizedBox(
                                                                    width: screenSize
                                                                            .width /
                                                                        2,
                                                                    child:
                                                                        AutoSizeText(
                                                                      'Level Pedas : ${value.lst[index].spicyLevel}',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                      maxFontSize:
                                                                          14,
                                                                      maxLines:
                                                                          2,
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SizedBox(
                                                              width: screenSize
                                                                      .width /
                                                                  6,
                                                              // padding:
                                                              //     EdgeInsets.only(
                                                              //         bottom: 13),
                                                              child:
                                                                  AutoSizeText(
                                                                'RM${totalPrice = value.lst[index].menuPrice * value.lst[index].menuQuantity} ',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black),
                                                                maxFontSize: 20,
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  //Text(value.total())
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 5,
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const Center(
                                child: Text('Order First'),
                              ),
                      ),
                    ),
                  ),
                ),
              ),

              //Obx(() => Text('Obx: ${t.total()}')),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
            padding: const EdgeInsets.only(top: 100),
            width: 200,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.white,
              label: Text(
                'PAY RM$overallPrice',
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              icon: const Icon(
                Icons.payment,
                color: Colors.black,
              ),
              onPressed: () async {
                if (controller.lst.isNotEmpty) {
                  // print(browser!.browserAgent);
                  // if (browser.browserAgent.toString() ==
                  //     'BrowserAgent.Chrome') {
                  //   Get.defaultDialog(
                  //       title:
                  //           'Please Allow Notification To Get Notification When Food is ready ',
                  //       middleText: 'IOS Not Supported');
                  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

                  //   NotificationSettings settings =
                  //       await messaging.requestPermission(
                  //     alert: true,
                  //     announcement: false,
                  //     badge: true,
                  //     carPlay: false,
                  //     criticalAlert: false,
                  //     provisional: false,
                  //     sound: true,
                  //   );
                  // }

                  await Future.delayed(const Duration(milliseconds: 300));
                  String fid = FirebaseFirestore.instance
                      .collection('newOrder')
                      .doc()
                      .id;
                  await _firestore
                      .collection('OrderNumber')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    for (var element in querySnapshot.docs) {
                      while (id <= element['id']) {
                        id = id + 1;
                      }
                    }
                  });

                  Get.to(PaymentMethodScreen(
                    ticketNumber: id,
                    uniqueTicketNumber: fid,
                    userName: userName,
                    userEmail: userEmail,
                    userPhonenumber: userPhonenumber,
                  ));
                } else {}
                setState(() => _loading = true);
              },
            )));
  }
}
