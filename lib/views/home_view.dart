import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/view_models/home_view_model.dart';
// import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      // onModelReady: (model) => model.getUser(),
      builder: (context, model, child) => FutureBuilder(
        future: model.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.red,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //이미 snapshot에 data가 있는 상태이기 때문에 아래와 같이 입력하면 Text null에러가 나지 않는다.
                  Text(
                    snapshot.data.email,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      // color: Colors.white,
                      padding: EdgeInsets.all(8),
                      // constraints: BoxConstraints.expand(),
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      // transform: Matrix4.rotationZ(.5),
                      decoration: BoxDecoration(
                        // color: Colors.blueGrey,
                        border: Border.all(
                          color: Colors.white,
                          width: 0.5,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 4.0,
                            spreadRadius: 2.0,
                            offset: Offset(4, 4),
                          )
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.blueGrey,
                          ],
                        ),
                        // shape: BoxShape.circle,
                      ),
                      child: FlatButton(
                        onPressed: () {
                          model.signOut();
                        },
                        child: Text(
                          "Sign Out",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    snapshot.data.userName +
                        '  ' +
                        snapshot.data.combo.toString() +
                        ' Combo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
            // snapshot의 데이터가 fetch될 동안 아래 화면 보여준다.
          } else {
            return Scaffold(
              body: Center(
                child: Container(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
