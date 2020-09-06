import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/views/constants/size.dart';

import '../../locator.dart';
import '../home_view.dart';
import '../vote_comment_view.dart';
import '../vote_select_view.dart';

class GgookBottomNaviBar extends StatefulWidget {
  @override
  _GgookBottomNaviBarState createState() => _GgookBottomNaviBarState();
}

class _GgookBottomNaviBarState extends State<GgookBottomNaviBar> {
  // List<String> _viewList;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<String> _viewList = [
    'loggedIn',
    'voteSelect',
    'voteComment',
  ];
  @override
  void initState() {
    // TODO: implement initState
    // int _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final NavigationService _navigationService = locator<NavigationService>();
    GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
          textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(
                color: Colors.white,
              ))),
      child: BottomNavigationBar(
        key: navBarGlobalKey,
        type: BottomNavigationBarType.shifting,
        onTap: (index) => {
          print(index),

          setState(() {
            _selectedIndex = index;
            print(_selectedIndex);
          }),
          // _navigationService.navigateTo(_viewList[index]),
        },
        currentIndex: _selectedIndex ?? 0,
        selectedItemColor: Color(0xFF1EC8CF),
        unselectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Vote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Comment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'My Page',
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
}

Theme bottomNavigationBar(context) {}
