class Menu {
  final String menuName;
  final Map<String, num> menuTopping;
  final String menuImage;
  int menuQuantity;
  double menuPrice;
  int totalDrinks;
  int totalMamu;
  final String iceLevel;
  final String sugarLevel;
  final String spicyLevel;
  final bool isDrink;
  Menu(
      {required this.menuImage,
      required this.menuName,
      required this.menuTopping,
      required this.menuQuantity,
      required this.menuPrice,
      required this.totalDrinks,
      required this.totalMamu,
      required this.iceLevel,
      required this.sugarLevel,
      required this.spicyLevel,
      required this.isDrink});

  Map<String, dynamic> toJson() => {
        'menuName': menuName,
        'menuTopping': menuTopping,
        'menuQuantity': menuQuantity,
        'menuPrice': menuPrice,
        'menuImage': menuImage,
        'totalDrinks': totalDrinks,
        'totalMamu': totalMamu,
        'iceLevel': iceLevel,
        'sugarLevel': sugarLevel,
        'spicyLevel': spicyLevel,
        'isDrink': isDrink
      };
}
