import 'package:flutter/material.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/views/constants/size.dart';

Theme bottomNavigationBar(context) {
  return Theme(
    data: Theme.of(context).copyWith(
        canvasColor: Colors.black,
        textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(
              color: Colors.white,
            ))),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      onTap: (index) => {},
      currentIndex: 0,
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
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: Text('Comment'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: Text('Ranking'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.face),
          title: Text('My Page'),
        ),
      ],
    ),
  );
}

Widget topBar(UserModel currentUserModel) {
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
              currentUserModel.userName,
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
        currentUserModel.combo.toString() + ' Combo',
        style: TextStyle(
          fontFamily: 'AdventPro',
          color: Color(0xFFC4FEF3),
          fontSize: 22,
        ),
      ),
    ],
  );
}
