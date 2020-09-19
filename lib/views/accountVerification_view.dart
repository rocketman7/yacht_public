import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../view_models/accountVerification_view_model.dart';

class AccountVerificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountVerificationViewModel>.reactive(
      viewModelBuilder: () => AccountVerificationViewModel(),
      onModelReady: null,
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  model.accOwnerVerificationRequest();
                },
                child: Text('click해서 데이터 받아오기'),
              ),
              GestureDetector(
                onTap: () {
                  model.accOccupyVerificationRequest();
                },
                child: Text('점유확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
