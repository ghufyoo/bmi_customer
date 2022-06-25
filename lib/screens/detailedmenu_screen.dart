// ignore_for_file: constant_identifier_names

import 'package:bmi_order/components/constants.dart';
import 'package:bmi_order/screens/menu_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controller/cart_controller.dart';
import 'package:get/get.dart';

import '../controller/firestore_controller.dart';
import 'cart_screen.dart';

// ignore: must_be_immutable
class DetailedmenuScreen extends StatefulWidget {
  static const String id = 'detailedmenu_screen';
  final String chosenMenu;

  final String imgUrl;
  num price;
  final bool isDrink;
  final num switches;
  DetailedmenuScreen(
      {Key? key,
      required this.chosenMenu,
      required this.imgUrl,
      required this.price,
      required this.isDrink,
      required this.switches})
      : super(key: key);

  @override
  _DetailedmenuScreenState createState() => _DetailedmenuScreenState();
}

enum Makansini { MinumSini, Bungkus, none }
enum drinkSize { Small, Medium, Bucket, none }
enum ramenType { Normal, Cheese, Carbonara, none }
enum iceLevel { Less, Extra, NoIce, Normal }
enum sugarLevel { Less, Extra, NoSugar, Normal }
Makansini? _type = Makansini.none;
drinkSize? _size = drinkSize.none;
ramenType? _types = ramenType.none;

late String kMakanSini = 'Makan Sini';
late String kMinumSini = 'Minum Sini';

late String chosenSize = '';
late String completeDish = 'null';
late String choseniceLevel = '';
late String chosensugarLevel = '';
late String chosenspicyLevel = '';
bool isBungkus = false;
bool isBucket = false;

class _DetailedmenuScreenState extends State<DetailedmenuScreen> {
  late String chosenType = widget.isDrink ? kMinumSini : kMakanSini;
  bool isDrink = false;
  List<bool> name = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  Map<String, num> cart = {};
  int quantity = 1;
  int totalDrinks = 0;
  int totalMamu = 0;
  num fixedPrice = 0;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double totalPrice = widget.price + icePrice as double;
    fixedPrice = widget.price;
    return Scaffold(
      backgroundColor: Colors.teal[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    isBungkus = false;
                    _type = Makansini.none;
                    _size = drinkSize.none;
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (widget.switches == 1) ...[
              CENDOL(context, screenSize)
            ] else if (widget.switches == 2) ...[
              ABC(context, screenSize),
            ] else if (widget.switches == 3) ...[
              Sirap(context, screenSize)
            ] else if (widget.switches == 4) ...[
              LemonTea(context, screenSize)
            ] else if (widget.switches == 5) ...[
              MamuGoreng(context, screenSize)
            ] else if (widget.switches == 6) ...[
              MamuRojak(context, screenSize)
            ] else if (widget.switches == 7) ...[
              Ramen(context, screenSize)
            ] else
              Container(
                decoration: kContainerHeaderStyle,
                width: screenSize.width,
                child: const Center(
                  child: Text(
                    'Quantity ?',
                    style: kMenuOptionDetailStyle,
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: kContainerHeaderStyle,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                          } else {
                            null;
                          }
                        });
                      },
                      child: Icon(
                        Icons.remove,
                        color: Colors.teal[900],
                        size: 35,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
                Container(
                  decoration: kContainerHeaderStyle,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                        //  widget.price = widget.price * quantity;
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.teal[900],
                        size: 35,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            GetBuilder<AddToCartVM>(
              init: AddToCartVM(),
              builder: (value) => InkWell(
                onTap: () async {
                  if (widget.switches == 5 ||
                      widget.switches == 6 ||
                      widget.switches == 7) {
                    totalMamu = 1;
                    isDrink = false;
                  } else {
                    totalMamu = 0;
                  }
                  if (widget.switches == 1 ||
                      widget.switches == 2 ||
                      widget.switches == 3 ||
                      widget.switches == 4) {
                    totalDrinks = 1;
                    isDrink = true;
                  } else {
                    totalDrinks = 0;
                  }

                  if (_type == Makansini.none) {
                    Get.snackbar('Sila Pilih', 'Makan Sini Atau Bungkus');
                  } else if (cart.isEmpty) {
                    completeDish =
                        widget.chosenMenu + ' ' + chosenSize + ' ' + chosenType;
                    choseniceLevel =
                        sliderIce(_currentIceSliderValue, chosenSize);
                    chosensugarLevel = sliderSugar(_currentSugarSliderValue);
                    chosenspicyLevel = sliderSpicy(_currentSpicySliderValue);
                    cart['Biasa'] = 0;
                    value.add(
                        widget.imgUrl,
                        completeDish,
                        cart,
                        quantity,
                        totalPrice,
                        totalDrinks,
                        totalMamu,
                        choseniceLevel,
                        chosensugarLevel,
                        chosenspicyLevel,
                        isDrink);
                    // Get.to(() => const DetailedScreen(queryString: 'Cendol'));
                    Get.to(const CartScreen());
                    isBungkus = false;
                    _type = Makansini.none;
                    _size = drinkSize.none;
                    chosenSize = '';
                    choseniceLevel = '';
                    chosensugarLevel = '';
                  } else {
                    completeDish =
                        widget.chosenMenu + ' ' + chosenSize + ' ' + chosenType;
                    choseniceLevel =
                        sliderIce(_currentIceSliderValue, chosenSize);
                    chosensugarLevel = sliderSugar(_currentSugarSliderValue);
                    chosenspicyLevel = sliderSpicy(_currentSpicySliderValue);
                    value.add(
                        widget.imgUrl,
                        completeDish,
                        cart,
                        quantity,
                        totalPrice,
                        totalDrinks,
                        totalMamu,
                        choseniceLevel,
                        chosensugarLevel,
                        chosenspicyLevel,
                        isDrink);
                    // Get.to(() => const DetailedScreen(queryString: 'Cendol'));
                    Get.to(const CartScreen());
                    isBungkus = false;
                    _type = Makansini.none;
                    _size = drinkSize.none;
                    chosenSize = '';
                    choseniceLevel = '';
                    chosensugarLevel = '';
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                      height: screenSize.height * 0.09,
                      width: screenSize.width,
                      decoration: kContainerHeaderStyle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "ADD ",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              fontSize: 18.0,
                            ),
                          ),
                          const Text(
                            ' ~ ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' RM ${(fixedPrice + icePrice) * quantity}',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  num werty = 0;

  Widget streamBuildCheckCendol(bool isBukcet) {
    if (isBukcet == false) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirestoreController.instance.firebaseFirestore
              .collection('Topping')
              .where('switches', isEqualTo: widget.switches)
              .where('bool', isEqualTo: true)
              .where('isBucket', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: LoadingAnimationWidget.newtonCradle(
                    color: Colors.white, size: 85),
              );
            }
            final docs = snapshot.data!.docs;
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final data = docs[i].data();

                  return ListTile(
                    title: Text(
                      data['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      data['desc'],
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    trailing: Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: Checkbox(
                        checkColor: Colors.teal,
                        activeColor: Colors.white,
                        value: name[i],
                        onChanged: (value) {
                          if (value == true) {
                            cart[data['name']] = data['price'];
                            widget.price += data['price'];
                          }

                          setState(() {
                            name[i] = value!;

                            if (cart.containsKey('Tak Nak Isi Cendol') &&
                                cart.containsKey('Extra Isi Cendol')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            } else if (cart.containsKey('Tak Nak Kacang') &&
                                cart.containsKey('Extra Kacang')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            } else if (cart.containsKey('Tak Nak Jagung') &&
                                cart.containsKey('Extra Jagung')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            } else if (cart.containsKey('Tak Nak Jelly') &&
                                cart.containsKey('Extra Jelly')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            } else if (cart.containsKey('Tak Nak Cincau') &&
                                cart.containsKey('Extra Cincau')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            }
                            if (name[i] == false) {
                              cart.removeWhere(
                                  (key, value) => key == data['name']);

                              widget.price -= data['price'];
                            }
                          });
                        },
                      ),
                    ),
                  );
                });
          });
    } else {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirestoreController.instance.firebaseFirestore
              .collection('Topping')
              .where('bool', isEqualTo: true)
              .where('isBucket', isEqualTo: true)
              .where('switches', isEqualTo: widget.switches)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: LoadingAnimationWidget.newtonCradle(
                    color: Colors.white, size: 85),
              );
            }
            final docs = snapshot.data!.docs;
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final data = docs[i].data();

                  return ListTile(
                    title: Text(
                      data['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      data['desc'],
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    trailing: Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: Checkbox(
                        checkColor: Colors.teal,
                        activeColor: Colors.white,
                        value: name[i],
                        onChanged: (value) {
                          if (value == true) {
                            cart[data['name']] = data['price'];
                            widget.price += data['price'];
                          }

                          setState(() {
                            name[i] = value!;

                            if (cart.containsKey('Tak Nak Isi Cendol') &&
                                cart.containsKey('Extra Isi Cendol')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            } else if (cart.containsKey('Tak Nak Kacang') &&
                                cart.containsKey('Extra Kacang')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            } else if (cart.containsKey('Tak Nak Jagung') &&
                                cart.containsKey('Extra Jagung')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            } else if (cart.containsKey('Tak Nak Jelly') &&
                                cart.containsKey('Extra Jelly')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            } else if (cart.containsKey('Tak Nak Cincau') &&
                                cart.containsKey('Extra Cincau')) {
                              Get.snackbar('Masalah Pemilihan',
                                  'Sila Perbetulkan Pilihan topping Anda');
                              Get.to(const MenuScreen());
                            }
                            if (name[i] == false) {
                              cart.removeWhere(
                                  (key, value) => key == data['name']);

                              widget.price -= data['price'];
                            }
                          });
                        },
                      ),
                    ),
                  );
                });
          });
    }
  }

  double _currentSugarSliderValue = 50;
  double _currentIceSliderValue = 50;
  final double _currentSpicySliderValue = 50;
  num icePrice = 0;
  String sliderIce(double value, String size) {
    if (size == 'Small') {
      if (value == 0) {
        return 'Tak Nak Ais Tambah RM 1';
      } else if (value == 25) {
        return 'Kurang Ais Tambah RM 1';
      } else if (value == 75) {
        return 'Extra Ais';
      } else {
        return 'Normal';
      }
    } else if (size == 'Medium') {
      if (value == 0) {
        return 'Tak Nak Ais Tambah RM 2';
      } else if (value == 25) {
        return 'Kurang Ais Tambah RM 2';
      } else if (value == 75) {
        return 'Extra Ais';
      } else {
        return 'Normal';
      }
    } else if (size == 'Bucket') {
      if (value == 0) {
        return 'Tak Nak Ais Tambah RM 3';
      } else if (value == 25) {
        return 'Kurang Ais Tambah RM 3';
      } else if (value == 75) {
        return 'Extra Ais';
      } else {
        return 'Normal';
      }
    } else {
      if (value == 0) {
        return 'Tak Nak Ais';
      } else if (value == 25) {
        return 'Kurang Ais';
      } else if (value == 75) {
        return 'Extra Ais';
      } else {
        return 'Normal';
      }
    }
  }

  String sliderSugar(double value) {
    if (value == 0) {
      return 'Tak Nak Gula';
    } else if (value == 25) {
      return 'Kurang Gula';
    } else if (value == 75) {
      return 'Extra Gula';
    }
    return 'Normal';
  }

  String sliderSpicy(double value) {
    if (value == 0) {
      return 'Tak Nak Pedas';
    } else if (value == 25) {
      return 'Kurang Pedas';
    } else if (value == 75) {
      return 'Extra Pedas';
    }
    return 'Normal';
  }

  num iceSliderPrice(double value, String size) {
    if (size == 'Small') {
      if (value == 0) {
        icePrice = 1;
      } else if (value == 25) {
        icePrice = 1;
      } else if (value == 75) {
        icePrice = 0;
      } else {
        icePrice = 0;
      }
    } else if (size == 'Medium') {
      if (value == 0) {
        icePrice = 2;
      } else if (value == 25) {
        icePrice = 2;
      } else if (value == 75) {
        icePrice = 0;
      } else {
        icePrice = 0;
      }
    } else if (size == 'Bucket') {
      if (value == 0) {
        icePrice = 3;
      } else if (value == 25) {
        icePrice = 3;
      } else if (value == 75) {
        icePrice = 0;
      } else {
        icePrice = 0;
      }
    } else {
      icePrice = 0;
    }

    return icePrice;
  }

  // ignore: non_constant_identifier_names
  Column CENDOL(BuildContext context, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipPath(
          clipper: SinCosineWaveClipper(
              horizontalPosition: HorizontalPosition.RIGHT),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(widget.imgUrl)),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.chosenMenu} $chosenType',
              style: kDetailMenuTextStyleSmall,
            ),
            Text(
              'RM${widget.price + icePrice}',
              style: kDetailMenuTextStyleSmall,
            ),
          ],
        ),
        Container(
            child: const Center(
                child: Text(
              'Nak Minum Sini ke Bungkus ?',
              style: kMenuOptionDetailStyle,
            )),
            padding: const EdgeInsets.all(4),
            decoration: kContainerHeaderStyle),
        Container(
          width: screenSize.width / 2,
          height: 1,
          color: Colors.teal,
        ),
        ListTile(
          title: Text(
            kMinumSini,
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.MinumSini,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = false;
              chosenSize = '';
              chosenType = kMinumSini;

              setState(() {
                _type = value;
                _currentIceSliderValue = 50;
                _currentSugarSliderValue = 50;
                for (int i = 0; i < name.length; i++) {
                  name[i] = false;
                }
                cart.clear();
                widget.price = 4;
                isBucket = false;
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Bungkus',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.Bungkus,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = true;
              chosenType = 'Bungkus';
              chosenSize = 'Small';
              _size = drinkSize.Small;
              setState(() {
                _type = value;

                _currentIceSliderValue = 50;
                _currentSugarSliderValue = 50;
                for (int i = 0; i < name.length; i++) {
                  name[i] = false;
                }
                cart.clear();
                widget.price = 4;
              });
            },
          ),
        ),
        isBungkus
            ? Column(
                children: [
                  Container(
                    child: const Center(
                      child: Text(
                        'Pilih Saiz dulu..',
                        style: kMenuOptionDetailStyle,
                      ),
                    ),
                    decoration: kContainerHeaderStyle,
                  ),
                  ListTile(
                    title: const Text(
                      'Small',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Small,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        widget.price = 4;
                        chosenSize = 'Small';

                        setState(() {
                          _size = value;
                          _currentIceSliderValue = 50;
                          _currentSugarSliderValue = 50;
                          for (int i = 0; i < name.length; i++) {
                            name[i] = false;
                          }
                          cart.clear();
                          widget.price = 4;

                          isBucket = false;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Medium',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Medium,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        chosenSize = 'Medium';

                        setState(() {
                          _size = value;
                          _currentIceSliderValue = 50;
                          _currentSugarSliderValue = 50;
                          for (int i = 0; i < name.length; i++) {
                            name[i] = false;
                          }
                          cart.clear();
                          widget.price = 4;

                          isBucket = false;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Bucket',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Bucket,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        chosenSize = 'Bucket';
                        setState(() {
                          _size = value;
                          _currentIceSliderValue = 50;
                          _currentSugarSliderValue = 50;
                          for (int i = 0; i < name.length; i++) {
                            name[i] = false;
                          }
                          cart.clear();
                          widget.price = 4;

                          isBucket = true;
                        });
                      },
                    ),
                  ),
                ],
              )
            : const SizedBox(
                height: 1,
              ),
        _type != Makansini.none
            ? Container(
                child: const Center(
                  child: Text(
                    'Tambah Topping baru mantap!',
                    style: kMenuOptionDetailStyle,
                  ),
                ),
                decoration: kContainerHeaderStyle,
              )
            : const SizedBox(),
        _type != Makansini.none
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: screenSize.width,
                  child: streamBuildCheckCendol(isBucket),
                ),
              )
            : const SizedBox(),
        _type != Makansini.none
            ? Column(
                children: [
                  Container(
                    child: const Center(
                      child: Text(
                        'Level Ais',
                        style: kMenuOptionDetailStyle,
                      ),
                    ),
                    decoration: kContainerHeaderStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Tak Nak Ais',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Kurang Ais',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Normal',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Extra Ais',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Slider(
                    autofocus: true,
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.teal[700],
                    thumbColor: Colors.white,
                    value: _currentIceSliderValue,
                    max: 75,
                    divisions: 3,
                    label: sliderIce(_currentIceSliderValue, chosenSize),
                    onChanged: (double value) {
                      setState(() {
                        _currentIceSliderValue = value;
                        iceSliderPrice(_currentIceSliderValue, chosenSize);
                      });
                    },
                  ),
                  Container(
                    child: const Center(
                      child: Text(
                        'Level Gula',
                        style: kMenuOptionDetailStyle,
                      ),
                    ),
                    decoration: kContainerHeaderStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Tak Nak Gula',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Kurang Gula',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Normal',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Extra Gula',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Slider(
                    autofocus: true,
                    activeColor: Colors.black,
                    inactiveColor: Colors.teal[700],
                    thumbColor: Colors.white,
                    value: _currentSugarSliderValue,
                    max: 75,
                    divisions: 3,
                    label: sliderSugar(_currentSugarSliderValue),
                    onChanged: (double value) {
                      setState(() {
                        _currentSugarSliderValue = value;
                      });
                    },
                  )
                ],
              )
            : const SizedBox()
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Column ABC(BuildContext context, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipPath(
          clipper: SinCosineWaveClipper(
              horizontalPosition: HorizontalPosition.RIGHT),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(widget.imgUrl)),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.chosenMenu} $chosenType',
              style: kDetailMenuTextStyleSmall,
            ),
            Text(
              'RM${widget.price}',
              style: kDetailMenuTextStyleSmall,
            ),
          ],
        ),
        Container(
            child: const Center(
                child: Text(
              'Nak Minum Sini ke Bungkus ?',
              style: kMenuOptionDetailStyle,
            )),
            padding: const EdgeInsets.all(4),
            decoration: kContainerHeaderStyle),
        Container(
          width: screenSize.width / 2,
          height: 1,
          color: Colors.teal,
        ),
        ListTile(
          title: Text(
            kMinumSini,
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.MinumSini,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = false;
              chosenSize = '';
              chosenType = kMinumSini;

              setState(() {
                _type = value;
                _currentIceSliderValue = 50;
                _currentSugarSliderValue = 50;
                for (int i = 0; i < name.length; i++) {
                  name[i] = false;
                }
                cart.clear();
                widget.price = 4;
                isBucket = false;
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Bungkus',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.Bungkus,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = true;
              chosenType = 'Bungkus';
              chosenSize = 'Small';
              _size = drinkSize.Small;
              setState(() {
                _type = value;
                _currentIceSliderValue = 50;
                _currentSugarSliderValue = 50;
                for (int i = 0; i < name.length; i++) {
                  name[i] = false;
                }
                cart.clear();
                widget.price = 4;
              });
            },
          ),
        ),
        isBungkus
            ? Column(
                children: [
                  Container(
                    child: const Center(
                      child: Text(
                        'Pilih Saiz dulu..',
                        style: kMenuOptionDetailStyle,
                      ),
                    ),
                    decoration: kContainerHeaderStyle,
                  ),
                  ListTile(
                    title: const Text(
                      'Small',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Small,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        widget.price = 4;

                        setState(() {
                          chosenSize = 'Small';
                          isBucket = false;
                          cart.clear();
                          _size = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Medium',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Medium,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        chosenSize = 'Medium';

                        setState(() {
                          isBucket = false;

                          cart.clear();
                          widget.price = 6;
                          _size = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Bucket',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Bucket,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        chosenSize = 'Bucket';
                        setState(() {
                          isBucket = true;
                          cart.clear();
                          widget.price = 14;
                          _size = value;
                        });
                      },
                    ),
                  ),
                ],
              )
            : const SizedBox(
                height: 1,
              ),
        _type != Makansini.none
            ? Container(
                child: const Center(
                  child: Text(
                    'Tambah Topping baru mantap!',
                    style: kMenuOptionDetailStyle,
                  ),
                ),
                decoration: kContainerHeaderStyle,
              )
            : const SizedBox(),
        _type != Makansini.none
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: screenSize.width,
                  child: streamBuildCheckCendol(isBucket),
                ),
              )
            : const SizedBox(),
        // SizedBox(
        //   height: screenSize.height / 2,
        //   width: screenSize.width,
        //   child: ListView(
        //     padding: const EdgeInsets.all(12),
        //     children: [
        //       ...toppingABC.map(buildCheckCendol).toList(),
        //     ],
        //   ),
        // ),
        _type != Makansini.none
            ? Column(
                children: [
                  Container(
                    child: const Center(
                      child: Text(
                        'Level Ais',
                        style: kMenuOptionDetailStyle,
                      ),
                    ),
                    decoration: kContainerHeaderStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Tak Nak Ais',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Kurang Ais',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Normal',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Extra Ais',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Slider(
                    autofocus: true,
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.teal[700],
                    thumbColor: Colors.white,
                    value: _currentIceSliderValue,
                    max: 75,
                    divisions: 3,
                    label: sliderIce(_currentIceSliderValue, chosenSize),
                    onChanged: (double value) {
                      setState(() {
                        _currentIceSliderValue = value;
                        iceSliderPrice(_currentIceSliderValue, chosenSize);
                      });
                    },
                  ),
                  Container(
                    child: const Center(
                      child: Text(
                        'Level Gula',
                        style: kMenuOptionDetailStyle,
                      ),
                    ),
                    decoration: kContainerHeaderStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Tak Nak Gula',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Kurang Gula',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Normal',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        'Extra Gula',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Slider(
                    autofocus: true,
                    activeColor: Colors.pinkAccent,
                    inactiveColor: Colors.teal[700],
                    thumbColor: Colors.white,
                    value: _currentSugarSliderValue,
                    max: 75,
                    divisions: 3,
                    label: sliderSugar(_currentSugarSliderValue),
                    onChanged: (double value) {
                      setState(() {
                        _currentSugarSliderValue = value;
                      });
                    },
                  )
                ],
              )
            : const SizedBox()
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Column Sirap(BuildContext context, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipPath(
          clipper: SinCosineWaveClipper(
              horizontalPosition: HorizontalPosition.RIGHT),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(widget.imgUrl)),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.chosenMenu} $chosenType $chosenSize',
              style: kDetailMenuTextStyleSmall,
            ),
            Text(
              'RM${widget.price}',
              style: kDetailMenuTextStyleSmall,
            ),
          ],
        ),
        Container(
            child: const Center(
                child: Text(
              'Nak Minum Sini ke Bungkus ?',
              style: kMenuOptionDetailStyle,
            )),
            padding: const EdgeInsets.all(4),
            decoration: kContainerHeaderStyle),
        Container(
          width: screenSize.width / 2,
          height: 1,
          color: Colors.teal,
        ),
        ListTile(
          title: Text(
            kMinumSini,
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.MinumSini,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = false;

              chosenType = kMinumSini;
              chosenSize = 'Small';
              _size = drinkSize.Small;
              setState(() {
                for (int i = 0; i < name.length; i++) {
                  name[i] = false;
                }
                cart.clear();
                widget.price = 1;
                _type = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Bungkus',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.Bungkus,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = true;
              chosenType = 'Bungkus';
              chosenSize = 'Small';
              _size = drinkSize.Small;
              setState(() {
                for (int i = 0; i < name.length; i++) {
                  name[i] = false;
                }
                cart.clear();
                widget.price = 1;
                _type = value;
              });
            },
          ),
        ),
        _type != Makansini.none
            ? Column(
                children: [
                  Container(
                    child: const Center(
                      child: Text(
                        'Pilih Saiz dulu..',
                        style: kMenuOptionDetailStyle,
                      ),
                    ),
                    decoration: kContainerHeaderStyle,
                  ),
                  ListTile(
                    title: const Text(
                      'Small',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Small,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        widget.price = 1;

                        setState(() {
                          chosenSize = 'Small';
                          isBucket = false;
                          cart.clear();
                          _size = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Medium',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Medium,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        setState(() {
                          isBucket = false;
                          chosenSize = 'Medium';
                          cart.clear();
                          widget.price = 2;
                          _size = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Bucket',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Bucket,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        chosenSize = 'Bucket';

                        setState(() {
                          isBucket = true;
                          cart.clear();
                          widget.price = 5;
                          _size = value;
                        });
                      },
                    ),
                  ),
                ],
              )
            : const SizedBox(),
        _type != Makansini.none
            ? Container(
                child: const Center(
                  child: Text(
                    'Tambah Topping baru mantap!',
                    style: kMenuOptionDetailStyle,
                  ),
                ),
                decoration: kContainerHeaderStyle,
              )
            : const SizedBox(),
        _type != Makansini.none
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: screenSize.width,
                  child: streamBuildCheckCendol(isBucket),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Column LemonTea(BuildContext context, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipPath(
          clipper: SinCosineWaveClipper(
              horizontalPosition: HorizontalPosition.RIGHT),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(widget.imgUrl)),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.chosenMenu} $chosenType $chosenSize',
              style: kDetailMenuTextStyleSmall,
            ),
            Text(
              'RM${widget.price}',
              style: kDetailMenuTextStyleSmall,
            ),
          ],
        ),
        Container(
            child: const Center(
                child: Text(
              'Nak Minum Sini ke Bungkus ?',
              style: kMenuOptionDetailStyle,
            )),
            padding: const EdgeInsets.all(4),
            decoration: kContainerHeaderStyle),
        Container(
          width: screenSize.width / 2,
          height: 1,
          color: Colors.teal,
        ),
        ListTile(
          title: Text(
            kMinumSini,
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.MinumSini,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = false;

              chosenType = kMinumSini;
              chosenSize = 'Small';
              setState(() {
                chosenSize = 'Small';
                _size = drinkSize.Small;
                _type = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Bungkus',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.Bungkus,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = true;
              chosenType = 'Bungkus';
              chosenSize = 'Small';
              setState(() {
                _type = value;
              });
            },
          ),
        ),
        _type != Makansini.none
            ? Column(
                children: [
                  Container(
                    child: const Center(
                      child: Text(
                        'Pilih Saiz dulu..',
                        style: kMenuOptionDetailStyle,
                      ),
                    ),
                    decoration: kContainerHeaderStyle,
                  ),
                  ListTile(
                    title: const Text(
                      'Small',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Small,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        widget.price = 2;

                        setState(() {
                          chosenSize = 'Small';
                          isBucket = false;
                          cart.clear();
                          _size = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Medium',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Medium,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        setState(() {
                          isBucket = false;
                          chosenSize = 'Medium';
                          cart.clear();
                          widget.price = 4;
                          _size = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Bucket',
                      style: kDetailMenuTextStyle,
                    ),
                    trailing: Radio<drinkSize>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      activeColor: Colors.teal,
                      value: drinkSize.Bucket,
                      groupValue: _size,
                      onChanged: (drinkSize? value) {
                        chosenSize = 'Bucket';
                        setState(() {
                          isBucket = true;
                          cart.clear();
                          widget.price = 9;
                          _size = value;
                        });
                      },
                    ),
                  ),
                ],
              )
            : const SizedBox(),
        _type != Makansini.none
            ? Container(
                child: const Center(
                  child: Text(
                    'Tambah Topping baru mantap!',
                    style: kMenuOptionDetailStyle,
                  ),
                ),
                decoration: kContainerHeaderStyle,
              )
            : const SizedBox(),
        _type != Makansini.none
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: screenSize.width,
                  child: streamBuildCheckCendol(isBucket),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Column MamuGoreng(BuildContext context, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipPath(
          clipper: SinCosineWaveClipper(
              horizontalPosition: HorizontalPosition.RIGHT),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(widget.imgUrl)),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.chosenMenu} $chosenType',
              style: kDetailMenuTextStyleSmall,
            ),
            Text(
              'RM${widget.price}',
              style: kDetailMenuTextStyleSmall,
            ),
          ],
        ),
        Container(
            child: const Center(
                child: Text(
              'Nak Makan Sini ke Bungkus ?',
              style: kMenuOptionDetailStyle,
            )),
            padding: const EdgeInsets.all(4),
            decoration: kContainerHeaderStyle),
        Container(
          width: screenSize.width / 2,
          height: 1,
          color: Colors.teal,
        ),
        ListTile(
          title: const Text(
            'Makan Sini',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.MinumSini,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = false;
              chosenSize = '';
              chosenType = 'Makan Sini';

              setState(() {
                _type = value;
                chosenSize = '';
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Bungkus',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.Bungkus,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = true;
              chosenType = 'Bungkus';
              chosenSize = '';
              setState(() {
                _type = value;
                chosenSize = '';
              });
            },
          ),
        ),
        Container(
          child: const Center(
            child: Text(
              'Tambah Topping baru mantap!',
              style: kMenuOptionDetailStyle,
            ),
          ),
          decoration: kContainerHeaderStyle,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: screenSize.width,
            child: streamBuildCheckCendol(isBucket),
          ),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Column MamuRojak(BuildContext context, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipPath(
          clipper: SinCosineWaveClipper(
              horizontalPosition: HorizontalPosition.RIGHT),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(widget.imgUrl)),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.chosenMenu} $chosenType',
              style: kDetailMenuTextStyleSmall,
            ),
            Text(
              'RM${widget.price}',
              style: kDetailMenuTextStyleSmall,
            ),
          ],
        ),
        Container(
            child: const Center(
                child: Text(
              'Nak Makan Sini ke Bungkus ?',
              style: kMenuOptionDetailStyle,
            )),
            padding: const EdgeInsets.all(4),
            decoration: kContainerHeaderStyle),
        Container(
          width: screenSize.width / 2,
          height: 1,
          color: Colors.teal,
        ),
        ListTile(
          title: const Text(
            'Makan Sini',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.MinumSini,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = false;
              chosenSize = '';
              chosenType = 'Makan Sini';

              setState(() {
                _type = value;
                chosenSize = '';
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Bungkus',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.Bungkus,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = true;
              chosenType = 'Bungkus';
              chosenSize = '';
              setState(() {
                _type = value;
                chosenSize = '';
              });
            },
          ),
        ),
        Container(
          child: const Center(
            child: Text(
              'Tambah Topping baru mantap!',
              style: kMenuOptionDetailStyle,
            ),
          ),
          decoration: kContainerHeaderStyle,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: screenSize.width,
            child: streamBuildCheckCendol(isBucket),
          ),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Column Ramen(BuildContext context, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipPath(
          clipper: SinCosineWaveClipper(
              horizontalPosition: HorizontalPosition.RIGHT),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(widget.imgUrl)),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.chosenMenu} $chosenType',
              style: kDetailMenuTextStyleSmall,
            ),
            Text(
              'RM${widget.price}',
              style: kDetailMenuTextStyleSmall,
            ),
          ],
        ),
        Container(
            child: const Center(
                child: Text(
              'Nak Makan Sini ke Bungkus ?',
              style: kMenuOptionDetailStyle,
            )),
            padding: const EdgeInsets.all(4),
            decoration: kContainerHeaderStyle),
        Container(
          width: screenSize.width / 2,
          height: 1,
          color: Colors.teal,
        ),
        ListTile(
          title: const Text(
            'Makan Sini',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.MinumSini,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = false;
              chosenSize = '';
              chosenType = 'Makan Sini';

              setState(() {
                _type = value;
                chosenSize = '';
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Bungkus',
            style: kDetailMenuTextStyle,
          ),
          trailing: Radio<Makansini>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            activeColor: Colors.teal,
            value: Makansini.Bungkus,
            groupValue: _type,
            onChanged: (Makansini? value) {
              isBungkus = true;
              chosenType = 'Bungkus';
              chosenSize = '';
              setState(() {
                _type = value;
                chosenSize = '';
              });
            },
          ),
        ),
        Column(
          children: [
            Container(
              child: const Center(
                child: Text(
                  'Yang Mana Satu',
                  style: kMenuOptionDetailStyle,
                ),
              ),
              decoration: kContainerHeaderStyle,
            ),
            ListTile(
              title: const Text(
                'Normal',
                style: kDetailMenuTextStyle,
              ),
              trailing: Radio<ramenType>(
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                activeColor: Colors.teal,
                value: ramenType.Normal,
                groupValue: _types,
                onChanged: (ramenType? value) {
                  setState(() {
                    chosenSize = 'Normal';
                    cart.clear();
                    _types = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                'Cheese',
                style: kDetailMenuTextStyle,
              ),
              trailing: Radio<ramenType>(
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                activeColor: Colors.teal,
                value: ramenType.Cheese,
                groupValue: _types,
                onChanged: (ramenType? value) {
                  setState(() {
                    chosenSize = 'Cheese';
                    cart.clear();

                    _types = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                'Carbonara',
                style: kDetailMenuTextStyle,
              ),
              trailing: Radio<ramenType>(
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                activeColor: Colors.teal,
                value: ramenType.Carbonara,
                groupValue: _types,
                onChanged: (ramenType? value) {
                  setState(() {
                    chosenSize = 'Carbonara';

                    cart.clear();

                    _types = value;
                  });
                },
              ),
            ),
          ],
        ),
        Container(
          child: const Center(
            child: Text(
              'Tambah Topping baru mantap!',
              style: kMenuOptionDetailStyle,
            ),
          ),
          decoration: kContainerHeaderStyle,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: screenSize.width,
            child: streamBuildCheckCendol(isBucket),
          ),
        ),
      ],
    );
  }
}
