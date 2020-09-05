import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/views/home_view.dart';
import 'package:yachtOne/views/login_view.dart';
import 'package:yachtOne/views/mypage_view.dart';
import 'package:yachtOne/views/rank_view.dart';
import 'package:yachtOne/views/vote_comment_view.dart';
import 'package:yachtOne/views/vote_select_view.dart';
import 'package:yachtOne/views/widgets/navigation_bars_widget.dart';
import '../locator.dart';
import '../view_models/startup_view_model.dart';
import '../views/loading_view.dart';

class StartUpView extends StatefulWidget {
  StartUpView({Key key}) : super(key: key);
  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView>
    with SingleTickerProviderStateMixin {
  NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey navBarGlobalKey = GlobalKey<NavigatorState>();

  int _selectedIndex = 0;
  TabController _tabController;
  bool isDisposed = false;
  List<Widget> _viewList;

  // HomeView에서 버튼으로 navigate할 수 있도록 callback function을 만든다.
  void goToTab(int idxFromOtherPages) {
    print("THIS VOID CALLED");
    setState(() {
      _selectedIndex = idxFromOtherPages;
      _tabController.index = _selectedIndex;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewList = <Widget>[
      HomeView(goToTab),
      VoteSelectView(),
      VoteCommentView(),
      RankView(),
      MypageView(),
    ];
    print("viewLIST DONE");

    _tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
    if (!isDisposed) {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    }

    print("init");
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didC");
  }

  @override
  Widget build(BuildContext context) {
    // HomeView에서 다른 페이지로 간 뒤에 backbutton으로 다시 홈에 오면 stream trigger가 안됨.
    print("StartuUpView");
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) => model.stream,
      // ViewModel이 세팅되면 아래 함수 call
      // onModelReady: (model) => model.handleStartUpLogic(),
      // onModelReady 콜 하고 아래 빌드. handleStartUpLogi이 Future함수 이므로 처리될 동안 LoadingView 빌드
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        print(_selectedIndex);
        return Scaffold(
          body: TabBarView(
            // key:
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: _viewList,
            // dragStartBehavior: DragStartBehavior.down,
          ),

          // _viewList[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            key: navBarGlobalKey,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => {
              print(index),

              setState(() {
                _selectedIndex = index;
                _tabController.index = index;
                // _viewList.insert(index, _viewList[index]);
                // _viewList.removeAt(index);
                print(_viewList.toString());
              }),
              // _navigationService.navigateTo(_viewList[index]),
            },
            currentIndex: _selectedIndex ?? 0,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
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
        // model.stream;
      },
    );
  }
}
