import 'package:get/get.dart';
import 'package:bmi_order/model/menu_model.dart';

// class CartController extends GetxController {
//  List<Menu> lst = <Menu>[];
//
//   void addProduct(String name, num price) {
//     if (_products.containsKey(menu)) {
//       _products[menu] += 1;
//     } else {
//       _products[menu] = 1;
//     }

//     Get.snackbar("Food added", "you have added the ${menu.name} to the cart",
//         snackPosition: SnackPosition.TOP, duration: Duration(seconds: 2));
//   }

//   void removeProduct(Menu menu) {
//     if (_products.containsKey(menu) && _products[menu] == 1) {
//       _products.removeWhere((key, value) => key == menu);
//     } else {
//       _products[menu] -= 1;
//     }
//   }

//   get menu => _products;
// }

class AddToCartVM extends GetxController {
  List<Menu> lst = [];
  num totalCartPrice = 0;

  add(
      String image,
      String name,
      Map<String, num> topping,
      int quantity,
      double price,
      int totalDrinks,
      int totalMamu,
      String iceLevel,
      String sugarLevel,
      String spicyLevel,
      bool isDrink) {
    lst.add(Menu(
        menuImage: image,
        menuName: name,
        menuTopping: topping,
        menuQuantity: quantity,
        menuPrice: price,
        totalDrinks: totalDrinks,
        totalMamu: totalMamu,
        iceLevel: iceLevel,
        sugarLevel: sugarLevel,
        spicyLevel: spicyLevel,
        isDrink: isDrink));

    update();
  }

  del(int index) {
    lst.removeAt(index);
    update();
  }

  List<String> toppingTest(int index) {
    List<String> t = [];
    t.add('-' + lst[index].menuTopping.keys.elementAt(index));
    return t;
  }

  double tryTotal() {
    double harga = 0;
    int quantity = 0;
    double total = 0;
    for (var i = 0; i < lst.length; i++) {
      harga = lst[i].menuPrice;
      quantity = lst[i].menuQuantity;
      total = total + harga * quantity;
    }

    return total;
  }

  int tryTotalDrinks() {
    int quantity = 0;
    int total = 0;
    int totalD = 0;
    for (var i = 0; i < lst.length; i++) {
      totalD = lst[i].totalDrinks;
      quantity = lst[i].menuQuantity;
      total = total + totalD * quantity;
    }

    return total;
  }

  int tryTotalMamu() {
    int quantity = 0;
    int total = 0;
    int totalM = 0;
    for (var i = 0; i < lst.length; i++) {
      totalM = lst[i].totalMamu;
      quantity = lst[i].menuQuantity;
      if (totalM == 0) {
        total = 0;
      } else {
        total = total + totalM * quantity;
      }
    }

    return total;
  }

  quanMinus(int index) {
    lst[index].menuQuantity--;
    update();
  }

  lenght() {
    return lst.length;
  }

  quantity(int index) {
    return lst[index].menuQuantity;
  }

  toFire() {}

  toName() {
    List<String> arr = [];
    for (var item in lst) {
      arr.add(item.menuName);
    }
    return arr;
  }

  toisDrink() {
    List<bool> arr = [];
    for (var item in lst) {
      arr.add(item.isDrink);
    }
    return arr;
  }

  toiceLevel() {
    List<String> arr = [];
    for (var item in lst) {
      arr.add(item.iceLevel);
    }
    return arr;
  }

  tosugarLevel() {
    List<String> arr = [];
    for (var item in lst) {
      arr.add(item.sugarLevel);
    }
    return arr;
  }

  tospicyLevel() {
    List<String> arr = [];
    for (var item in lst) {
      arr.add(item.spicyLevel);
    }
    return arr;
  }

  toTopping() {
    List<Map<String, num>> arr = [];

    // lst.map((e) => e.menuTopping.forEach((key, value) {
    //       arr.add(key);
    //     }));
    for (var item in lst) {
      // arr.add(item.menuTopping.keys.toString().removeAllWhitespace);
      arr.add(item.menuTopping);
    }
    return arr;
  }

  toToppingName() {
    List<String> arr = [];

    for (var item in lst) {
      for (int i = 0; i < item.menuTopping.length; i++) {
        arr.add(item.menuTopping.keys.elementAt(i));
      }
    }
    return arr;
  }

  toToppingPrice() {
    List<num> arr = [];

    for (var item in lst) {
      for (int i = 0; i < item.menuTopping.length; i++) {
        arr.add(item.menuTopping.values.elementAt(i));
      }
    }
    return arr;
  }

  toPrice() {
    List<double> arr = [];
    for (var item in lst) {
      arr.add(item.menuPrice);
    }
    return arr;
  }

  toQuantity() {
    List<num> arr = [];
    for (var item in lst) {
      arr.add(item.menuQuantity);
    }
    return arr;
  }
}
