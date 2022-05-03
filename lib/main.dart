import 'package:bmi_order/controller/auth_controller.dart';
import 'package:bmi_order/controller/firestore_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/auth/registration_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/detailedmenu_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/receipt_screen.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(AuthController());
    Get.put(FirestoreController());
  });

  runApp(const BmiOrder());
}

class BmiOrder extends StatelessWidget {
  const BmiOrder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      )),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      getPages: [
        GetPage(name: "/", page: () => const LoginScreen()),
        GetPage(
            name: "/registration_screen",
            page: () => const RegistrationScreen()),
        GetPage(name: "/login_screen", page: () => const LoginScreen()),
        GetPage(name: "/menu_screen", page: () => const MenuScreen()),
        GetPage(
            name: "/detailedmenu_screen",
            page: () => DetailedmenuScreen(
                  chosenMenu: '',
                  imgUrl: '',
                  price: 0,
                  isDrink: false,
                  switches: 0,
                )),
        GetPage(name: "/cart_screen", page: () => const CartScreen()),
        GetPage(
            name: "/receipt_screen",
            page: () => const ReceiptScreen(
                  receiptId: 0,
                )),
        // GetPage(name: "/menu_screen",page: ()=>MenuScreen(email: ''),

        // WelcomeScreen.id: (context) => WelcomeScreen(),
        // LoginScreen.id: (context) => LoginScreen(),
        // RegistrationScreen.id: (context) => RegistrationScreen(),
        // MenuScreen.id: (context) => MenuScreen(
        //       email: '',
        //     ),
        // DetailedmenuScreen.id: (context) => DetailedmenuScreen(
        //       chosenMenu: '',
        //       imgUrl: '',
        //       price: 0,
        //       isDrink: false,
        //     ),
        // CartScreen.id: (context) => CartScreen(
        //       entry: ['zero', 'zero', 'zero'],
        //     ),
        // ReceiptScreen.id: (context) => ReceiptScreen()
      ],
    );
  }
}
