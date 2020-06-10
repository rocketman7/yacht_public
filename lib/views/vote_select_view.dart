import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/vote_select_view_model.dart';
import 'package:yachtOne/views/constants/size.dart';

class VoteSelectView extends StatefulWidget {
  @override
  _VoteSelectViewState createState() => _VoteSelectViewState();
}

class _VoteSelectViewState extends State<VoteSelectView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VoteSelectViewModel>.reactive(
      viewModelBuilder: () => VoteSelectViewModel(),
      builder: (context, model, child) => MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            elevation: 50.0,
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
          ),
          backgroundColor: Color(0XFF051417),

          body: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  // color: Colors.grey[900],
                  height: user_top_bar,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: gap_xs,
                          right: gap_xs,
                        ),
                        child: Icon(Icons.face),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 200,
                        ),
                        child: Text(
                          'rocketman',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '24 Combo',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: gap_l,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '5 Votes for Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: gap_l,
                ),
                Container(
                  height: 350,
                  width: 350 / 1.618,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  height: gap_l,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: gap_xs, right: gap_xs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Votes Seleceted',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'GO VOTE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: gap_l,
                ),
                Container(
                  height: 150,
                  width: 150 / 1.618,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
          // Code:
        ),
      ),
    );
  }
}
