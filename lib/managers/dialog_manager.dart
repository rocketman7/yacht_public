import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../locator.dart';
import '../models/dialog_model.dart';
import '../services/dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);
  @override
  _DialogManagerState createState() => _DialogManagerState();
}

// UI가 없는 stateful 위젯
class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListner(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    (request.cancelTitle == null)
        // cancel 버튼이 없을 때
        ? Alert(
            context: context,
            title: request.title,
            desc: request.description,
            closeFunction: () =>
                _dialogService.dialogComplete(DialogResponse(confirmed: false)),
            buttons: [
                DialogButton(
                  child: Text(request.buttonTitle),
                  onPressed: () {
                    _dialogService
                        .dialogComplete(DialogResponse(confirmed: true));
                    Navigator.of(context).pop();
                  },
                ),
              ]).show()
        : // cancle 버튼이 있을 때
        Alert(
            context: context,
            title: request.title,
            desc: request.description,
            closeFunction: () =>
                _dialogService.dialogComplete(DialogResponse(confirmed: false)),
            buttons: [
                DialogButton(
                  child: Text(request.cancelTitle),
                  onPressed: () {
                    _dialogService
                        .dialogComplete(DialogResponse(confirmed: false));
                    Navigator.of(context).pop();
                  },
                ),
                DialogButton(
                  child: Text(request.buttonTitle),
                  onPressed: () {
                    _dialogService
                        .dialogComplete(DialogResponse(confirmed: true));
                    Navigator.of(context).pop();
                  },
                ),
              ]).show();
  }
}
