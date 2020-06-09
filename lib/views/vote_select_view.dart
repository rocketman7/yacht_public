import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/vote_select_view_model.dart';

class VoteSelect extends StatefulWidget {
  @override
  _VoteSelectState createState() => _VoteSelectState();
}

class _VoteSelectState extends State<VoteSelect> {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VoteSelectViewModel>.reactive(
      viewModelBuilder: () => VoteSelectViewModel(),
      builder: (context, model, child) => MaterialApp(
          // Code:

          ),
    );
  }
}
