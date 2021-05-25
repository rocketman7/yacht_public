import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MypageTermofuse extends StatelessWidget {
  Future<String> _termsOfUseFuture() async {
    return await rootBundle.loadString('assets/documents/termsOfUse.txt');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String _termsOfUse = snapshot.data.toString();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '이용약관',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              elevation: 1,
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '이용약관',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              elevation: 1,
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Container(),
            ),
          );
        }
      },
      future: _termsOfUseFuture(),
    );
  }
}
