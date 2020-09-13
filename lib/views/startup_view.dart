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
  final int startIdx;
  const StartUpView(this.startIdx);

  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView>
    with SingleTickerProviderStateMixin {
  NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey navBarGlobalKey = GlobalKey<NavigatorState>();
  int _startIdx;

  int _selectedIndex;
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
    _startIdx = widget.startIdx ?? 0;
    _selectedIndex = _startIdx;
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
      initialIndex: _startIdx ?? 0,
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
        // print(widget.startIdx);

        // print(_selectedIndex);
        return Scaffold(
          body: model.isBusy
              ? LoadingView()
              : TabBarView(
                  // key:
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: _viewList,
                  // dragStartBehavior: DragStartBehavior.down,
                ),

          // _viewList[_selectedIndex],
          bottomNavigationBar: SizedBox(
            // height: 70,
            child: BottomNavigationBar(
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
              selectedItemColor: Color(0xFF1EC8CF),
              unselectedItemColor: Color(0xFFAAAAAA),
              selectedFontSize: 0,
              unselectedFontSize: 0,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/home.svg',
                      color: Color(0xFFAAAAAA)),
                  activeIcon: SvgPicture.asset('assets/icons/home.svg',
                      color: Color(0xFF1EC8CF)),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/vote.svg',
                      color: Color(0xFFAAAAAA)),
                  activeIcon: SvgPicture.asset('assets/icons/vote.svg',
                      color: Color(0xFF1EC8CF)),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/comment.svg',
                      color: Color(0xFFAAAAAA)),
                  activeIcon: SvgPicture.asset('assets/icons/comment.svg',
                      color: Color(0xFF1EC8CF)),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/rank.svg',
                      color: Color(0xFFAAAAAA)),
                  activeIcon: SvgPicture.asset('assets/icons/rank.svg',
                      color: Color(0xFF1EC8CF)),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/mypage.svg',
                      color: Color(0xFFAAAAAA)),
                  activeIcon: SvgPicture.asset('assets/icons/mypage.svg',
                      color: Color(0xFF1EC8CF)),
                  label: '',
                ),
              ],
            ),
          ),
        );
        // model.stream;
      },
    );
  }
}
