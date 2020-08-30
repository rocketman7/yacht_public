import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/navigation_service.dart';

import '../../locator.dart';
import '../loading_view.dart';

class TermsOfUseView extends StatelessWidget {
  Future<String> _termsOfUseFuture() async {
    return await rootBundle.loadString('assets/documents/termsOfUse.txt');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String _termsOfUse = snapshot.data;
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      '꾸욱 이용약관',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black26,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 14.0, right: 14.0, bottom: 12.0),
                        child: Container(
                          child: SingleChildScrollView(
                            child: Text(_termsOfUse),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        /*_navigationService.navigateWithArgTo(
                            'mypage', 'm2UUvxsAwfdLFP4RB8q4SgkaNgr2');*/
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        height: 10.0,
                        child: Text('돌아가기'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return LoadingView();
        }
      },
      future: _termsOfUseFuture(),
    );
  }
}
