import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yachtOne/models/dialog_model.dart';

class DialogService {
  GlobalKey<NavigatorState> _dialogNavigationKey = GlobalKey<NavigatorState>();
  Function(DialogRequest) _showDialogListner;
  // Completer는 퓨쳐를 생산하고 완성하는 방법. 컴플리터를 만들어 이것의 퓨쳐를 리턴하고
  // 준비가 되면 .complete를 불러서 원하는 밸류를 리턴한다.
  // 콜하는 코드는 일반적인 퓨쳐처럼 컴플릿을 콜할때까지 기다림.
  // 이는 다이얼로그로 인터액션하듯이 유저 인풋이 끝날 때까지 기다린다는 의미이다.
  Completer<DialogResponse> _dialogCompleter;

  // 콜백 함수를 레지스터한다. 일반적으로 다이얼로그를 보여주는 함수
  void registerDialogListner(Function(DialogRequest) showDialogListner) {
    _showDialogListner = showDialogListner;
  }

  // 다이얼로그 리스너를 콜하고 다이얼로그 컴플릿을 기다릴 퓨쳐를 리턴한다
  Future<DialogResponse> showDialog({
    String title,
    String description,
    String buttonTitle = 'OK',
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListner(DialogRequest(
      title: title,
      description: description,
      buttonTitle: buttonTitle,
    ));
    return _dialogCompleter.future;
  }

  // 다이얼로그 컴플리터를 완성하여 퓨쳐의 실행 콜을 다시 시작하게 한다.
  void dialogComplete(DialogResponse response) {
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }
}
