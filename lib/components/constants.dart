import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

var kContainerHeaderStyle = BoxDecoration(
    color: Colors.grey[200],
    border: Border.all(
      color: Colors.grey,
      width: 2.0,
    ),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(color: Colors.grey, blurRadius: 2.0, offset: Offset(2.0, 2.0))
    ]);
const kMenuOptionDetailStyle = TextStyle(
  color: Colors.teal,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
);
const kMenuScreenTopStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 12.0,
);

const kMenuDescStyle = TextStyle(
  color: Colors.teal,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
  fontSize: 10.0,
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
const kCartTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
const kQuantityCartTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 14.0,
);
const kMenuPriceStyle = TextStyle(
  color: Colors.teal,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
const kDetailMenuTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
const kDetailMenuTextStyleSmall = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 14.0,
);
const kMenuNameDetailStyle = TextStyle(
  color: Colors.teal,
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
);

const kMenuNameStyle = TextStyle(
  color: Colors.teal,
  fontWeight: FontWeight.bold,
  fontSize: 23.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  label: Text(''),
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.teal, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.teal, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class CartCounter extends StatelessWidget {
  const CartCounter({
    Key? key,
    required this.count,
  }) : super(key: key);
  final String count;
  @override
  Widget build(BuildContext context) {
    return Badge(
      badgeColor: Colors.teal,
      badgeContent: Text(
        count,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      child: const Icon(Icons.shopping_cart_rounded,
          color: Colors.white, size: 35),
    );
    // return Container(
    //     height: 16,
    //     width: 26,
    //     decoration: BoxDecoration(
    //       color: Colors.black,
    //       shape: BoxShape.circle,
    //     ),
    //     child: Center(
    //         child: Text(
    //       count,
    //       style: TextStyle(color: Colors.white, fontSize: 15),
    //     )));
  }
}
