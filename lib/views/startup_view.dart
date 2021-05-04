import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/managers/dialog_manager.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/views/home_view.dart';
import 'package:yachtOne/views/login_view.dart';
import 'package:yachtOne/views/mypage_main_view.dart';
import 'package:yachtOne/views/rank_view.dart';
import 'package:yachtOne/views/stock_list_view.dart';
import 'package:yachtOne/views/track_record_view.dart';
import 'package:yachtOne/views/vote_comment_view.dart';
import 'package:yachtOne/views/vote_select_view.dart';
import 'package:yachtOne/views/widgets/navigation_bars_widget.dart';
import '../locator.dart';
import '../view_models/startup_view_model.dart';
import '../views/loading_view.dart';
import 'intro_view.dart';
import 'vote_select_v2_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartUpView extends StatefulWidget {
  final int startIdx;
  const StartUpView(this.startIdx);

  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView>
    with SingleTickerProviderStateMixin {
  NavigationService _navigationService = locator<NavigationService>();
  MixpanelService _mixpanelService = locator<MixpanelService>();

  final GlobalKey navBarGlobalKey = GlobalKey<NavigatorState>();
  int _startIdx;

  int _selectedIndex;
  TabController _tabController;
  bool isDisposed = false;
  List<Widget> _viewList;
  List<String> _bottomViewNameList;

  // HomeView에서 버튼으로 navigate할 수 있도록 callback function을 만든다.
  void goToTab(int idxFromOtherPages) {
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

  String _authStatus = 'Unknown';
  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        // Show a custom explainer dialog before the system dialog
        // if (await showCustomTrackingDialog(context)) {
        //   // Wait for dialog popping animation
        //   await Future.delayed(const Duration(milliseconds: 200));
        // Request system's tracking authorization dialog
        final TrackingStatus status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        setState(() => _authStatus = '$status');
        // }
      }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
    _startIdx = widget.startIdx ?? 0;
    _selectedIndex = _startIdx;
    // TODO: implement initState
    super.initState();

    _viewList = <Widget>[
      // HomeView(goToTab),
      // DialogManager(child: VoteSelectV2View()),
      VoteSelectV2View(),
      VoteCommentView(),
      RankView(),
      StockListView(),
      TrackRecordView(),
    ];

    _bottomViewNameList = [
      "Home View",
      "Community View",
      "Rank View",
      "Stock List View",
      "Track Record View"
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
      // onModelReady: (model) => model.stream,
      // ViewModel이 세팅되면 아래 함수 call
      // onModelReady: (model) => model.handleStartUpLogic(),
      // onModelReady 콜 하고 아래 빌드. handleStartUpLogi이 Future함수 이므로 처리될 동안 LoadingView 빌드
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        // print(widget.startIdx);

        // print(_selectedIndex);
        return model.isBusy
            ? IntroView()
            : Scaffold(
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
                    _mixpanelService.mixpanel.track(_bottomViewNameList[index]),

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
                  // iconSize: 25,
                  unselectedFontSize: 0,
                  items: [
                    // BottomNavigationBarItem(
                    //   icon: GestureDetector(
                    //     child: SvgPicture.asset('assets/icons/home.svg',
                    //         color: Color(0xFFAAAAAA)),
                    //   ),
                    //   activeIcon: SvgPicture.asset('assets/icons/home.svg',
                    //       color: Color(0xFF1EC8CF)),
                    //   label: '',
                    // ),
                    // BottomNavigationBarItem(
                    //   icon: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 18.h,
                    //       horizontal: 36.w,
                    //     ),
                    //     // height: double.infinity,
                    //     color: Colors.white.withOpacity(0),
                    //     child: SvgPicture.asset(
                    //       'assets/icons/bottom_home.svg',
                    //       color: Color(0xFFAAAAAA),
                    //     ),
                    //   ),
                    //   activeIcon: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 18.h,
                    //       horizontal: 36.w,
                    //     ),
                    //     // height: double.infinity,
                    //     color: Colors.white.withOpacity(0),
                    //     child: SvgPicture.asset('assets/icons/bottom_home.svg',
                    //         color: Colors.black),
                    //   ),
                    //   label: '',
                    // ),
                    // BottomNavigationBarItem(
                    //   icon: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 18.h,
                    //       horizontal: 36.w,
                    //     ),
                    //     color: Colors.white.withOpacity(0),
                    //     child: SvgPicture.asset('assets/icons/bottom_chat.svg',
                    //         color: Color(0xFFAAAAAA)),
                    //   ),
                    //   activeIcon: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 18.h,
                    //       horizontal: 36.w,
                    //     ),
                    //     color: Colors.white.withOpacity(0),
                    //     child: SvgPicture.asset('assets/icons/bottom_chat.svg',
                    //         color: Colors.black),
                    //   ),
                    //   label: '',
                    // ),
                    // BottomNavigationBarItem(
                    //   icon: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 18.h,
                    //       horizontal: 36.w,
                    //     ),
                    //     color: Colors.white.withOpacity(0),
                    //     child: SvgPicture.asset(
                    //       'assets/icons/bottom_rank2.svg',
                    //       color: Color(0xFFAAAAAA),
                    //       // height: 40,
                    //     ),
                    //     // child: Image(
                    //     //   image: AssetImage('assets/icons/bottom_rank2.png'),
                    //     //   color: Color(0xFFAAAAAA),
                    //     // ),
                    //   ),
                    //   activeIcon: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 18.h,
                    //       horizontal: 36.w,
                    //     ),
                    //     color: Colors.white.withOpacity(0),
                    //     child: SvgPicture.asset('assets/icons/bottom_rank2.svg',
                    //         color: Colors.black),
                    //     // child: Image(
                    //     //   image: AssetImage('assets/icons/bottom_rank2.png'),
                    //     // ),
                    //   ),
                    //   label: '',
                    // ),
                    // BottomNavigationBarItem(
                    //   icon: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 18.h,
                    //       horizontal: 36.w,
                    //     ),
                    //     color: Colors.white.withOpacity(0),
                    //     child: SvgPicture.asset(
                    //         'assets/icons/bottom_track_record.svg',
                    //         color: Color(0xFFAAAAAA)),
                    //   ),
                    //   activeIcon: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 18.h,
                    //       horizontal: 36.w,
                    //     ),
                    //     color: Colors.white.withOpacity(0),
                    //     child: SvgPicture.asset(
                    //         'assets/icons/bottom_track_record.svg',
                    //         color: Colors.black),
                    //   ),
                    //   label: '',
                    // ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        // height: double.infinity,
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset(
                          'assets/icons/bottom_home.svg',
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                      activeIcon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        // height: double.infinity,
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset('assets/icons/bottom_home.svg',
                            color: Colors.black),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset('assets/icons/bottom_chat.svg',
                            color: Color(0xFFAAAAAA)),
                      ),
                      activeIcon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset('assets/icons/bottom_chat.svg',
                            color: Colors.black),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset(
                          'assets/icons/bottom_rank2.svg',
                          color: Color(0xFFAAAAAA),
                          // height: 40,
                        ),
                        // child: Image(
                        //   image: AssetImage('assets/icons/bottom_rank2.png'),
                        //   color: Color(0xFFAAAAAA),
                        // ),
                      ),
                      activeIcon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset('assets/icons/bottom_rank2.svg',
                            color: Colors.black),
                        // child: Image(
                        //   image: AssetImage('assets/icons/bottom_rank2.png'),
                        // ),
                      ),
                      label: '',
                    ),

                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset(
                          'assets/icons/bottom_finder.svg',
                          color: Color(0xFFAAAAAA),
                          // height: 22.h,
                        ),
                      ),
                      activeIcon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset(
                          'assets/icons/bottom_finder.svg',
                          color: Colors.black,
                          // height: 22.h,
                        ),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset(
                            'assets/icons/bottom_track_record.svg',
                            color: Color(0xFFAAAAAA)),
                      ),
                      activeIcon: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        color: Colors.white.withOpacity(0),
                        child: SvgPicture.asset(
                          'assets/icons/bottom_track_record.svg',
                          color: Colors.black,
                        ),
                      ),
                      label: '',
                    ),
                  ],
                ),
              );
        // model.stream;
      },
    );
  }
}
