import 'package:bmi_order/controller/auth_controller.dart';
import 'package:bmi_order/model/order_model.dart';
import 'package:bmi_order/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreController extends GetxController {
  static FirestoreController instance =
      Get.find(); // declare FirestoreController as Getcontroller
  FirebaseFirestore firebaseFirestore =
      FirebaseFirestore.instance; // initialize firebase firestore
// VERIFY EMAIL

// CREATE USER
  Future createUser(Users user) async {
    final docUser = firebaseFirestore
        .collection('UserInformation')
        .doc(AuthController.instance.auth.currentUser?.email);

    final json = user.toJson();

    await docUser.set(json);
  }

// GET USER NICKNAME

  Future getUserNickname(String email) async {
    String nickname = '';
    await firebaseFirestore
        .collection('UserInformation')
        .doc(email)
        .get()
        .then((value) {
      nickname = value.data()?['nickname'];
      Get.snackbar("Selamat Datang $nickname Ke Cendol BMI", '');
    });
  }

// CHECK USERNAME
  Future<bool> usernameCheck(String username) async {
    final result = await firebaseFirestore
        .collection('UserInformation')
        .where('nickname', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

// CHECK PHONENUMBER
  Future<bool> userphonenumberCheck(String phonenumber) async {
    final result = await firebaseFirestore
        .collection('UserInformation')
        .where('phonenumber', isEqualTo: phonenumber)
        .get();
    return result.docs.isEmpty;
  }

// GET TOPPING
  Stream topping(num choice) => FirebaseFirestore.instance
        .collection('Topping')
        .where('switch', isEqualTo: choice)
        .snapshots();
  

// PLACE ORDER
  Future placeOrder(Orders orders, num uniqueId) async {
    final order =
        firebaseFirestore.collection('newOrder').doc(uniqueId.toString());

    final json = orders.toJson();

    await order.set(json);
  }

  Stream<DocumentSnapshot> readUser() => firebaseFirestore
      .collection('UserInformation')
      .doc(AuthController.instance.auth.currentUser?.email)
      .snapshots(); //Firestore Query to fetch data from user

  //SELECT TOPPING
//  Stream<DocumentSnapshot> toppingSelection(String queryString)  {
//     // Dropdowndata function for HighRisk Area
//     FirebaseFirestore.instance
//         .collection('Topping')
//         .where('state', isEqualTo: queryString)
//         .orderBy('datetime', descending: false)
//         .snapshots(); //Firestore Query to fetch data
//   }
}
