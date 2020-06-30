import 'package:flutter/material.dart';
import 'package:yachtOne/views/constants/size.dart';

BottomNavigationBar bottomNavigationBar() {
  return BottomNavigationBar(
    onTap: (index) => {},
    currentIndex: 0,
    backgroundColor: Colors.black,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.white,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.monetization_on),
        title: Text('Vote'),
      ),
    ],
  );
}

Widget topBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      Row(
        children: <Widget>[
          Image.asset(
            'assets/images/avatar.png',
            width: 60,
          ),
          SizedBox(
            width: gap_xl,
          ),
          FlatButton(
            onPressed: () => {},
            child: Text(
              // snapshot.data[0].userName,
              'rocketman',
              style: TextStyle(
                fontFamily: 'AdventPro',
                color: Color(0xFFC4FEF3),
                fontSize: 26,
              ),
            ),
          ),
        ],
      ),
      Text(
        // snapshot.data[0].combo.toString() + ' Combo',
        '17 Combo',
        style: TextStyle(
          fontFamily: 'AdventPro',
          color: Color(0xFFC4FEF3),
          fontSize: 22,
        ),
      ),
    ],
  );
}
