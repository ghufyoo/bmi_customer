import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  final String userEmail;
  final String userName;
  final String userPhoneNumber;

  final Timestamp timestamp;
  final String currentTime;
  final String currentDate;
  final num receiptId;
  final num receiptUniqueId;
  final num buzzerNumber;
  final num totalDrinks;
  final num totalFoods;
  final num totalPrice;
  //final List<Map<String, num>> menuTopping;
  final List<String> menuToppingName;
  final List<num> menuToppingPrice;
  final List<String> menuName;
  final List<double> menuPrice;
  final List<num> menuQuantity;
  final List<String> iceLevel;
  final List<String> sugarLevel;
  final List<String> spicyLevel;
  final bool isDone;
  final bool isPickup;
  final bool isPaid;
  final List<bool> isDrink;
  Orders({
    required this.userEmail,
    required this.userName,
    required this.userPhoneNumber,
    required this.timestamp,
    required this.currentTime,
    required this.currentDate,
    required this.receiptId,
    required this.receiptUniqueId,
    required this.buzzerNumber,
    required this.totalDrinks,
    required this.totalFoods,
    required this.totalPrice,
    required this.menuToppingName,
    required this.menuToppingPrice,
    required this.menuName,
    required this.menuPrice,
    required this.menuQuantity,
    required this.iceLevel,
    required this.sugarLevel,
    required this.spicyLevel,
    required this.isDone,
    required this.isPickup,
    required this.isPaid,
    required this.isDrink,
  });
  Map<String, dynamic> toJson() => {
        'userEmail': userEmail,
        'userName': userName,
        'userPhoneNumber': userPhoneNumber,
        'timestamp': timestamp,
        'currentTime': currentTime,
        'currentDate': currentDate,
        'receiptId': receiptId,
        'ticketId': receiptUniqueId,
        'buzzerNumber': buzzerNumber,
        'totalDrinks': totalDrinks,
        'totalFoods': totalFoods,
        'totalPrice': totalPrice,
        'menuToppingName': menuToppingName,
        'menuToppingPrice': menuToppingPrice,
        'menuName': menuName,
        'menuPrice': menuPrice,
        'menuQuantity': menuQuantity,
        'iceLevel': iceLevel,
        'sugarLevel': sugarLevel,
        'spicyLevel': spicyLevel,
        'isDone': isDone,
        'isPickup': isPickup,
        'isPaid': isPaid,
        'isDrink': isDrink,
      };
}
