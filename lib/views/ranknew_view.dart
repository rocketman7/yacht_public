import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../view_models/ranknew_view_model.dart';

// 15개씩 로딩하는 애 연습. 현재는 rank_view 가 진퉁

const String LoadingIndicatorTitle = '^';

class CreationAwareListItem extends StatefulWidget {
  final Function itemCreated;
  final Widget child;
  const CreationAwareListItem({
    Key key,
    this.itemCreated,
    this.child,
  }) : super(key: key);

  @override
  _CreationAwareListItemState createState() => _CreationAwareListItemState();
}

class _CreationAwareListItemState extends State<CreationAwareListItem> {
  @override
  void initState() {
    super.initState();
    if (widget.itemCreated != null) {
      widget.itemCreated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class ListItem extends StatelessWidget {
  final String title;
  const ListItem({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              color: Colors.grey[400],
            ),
          ],
          borderRadius: BorderRadius.circular(5)),
      child: title == LoadingIndicatorTitle
          ? CircularProgressIndicator()
          : Text(title),
      alignment: Alignment.center,
    );
  }
}

class RanknewView extends StatelessWidget {
  const RanknewView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RanknewViewModel>(
        create: (context) => RanknewViewModel(),
        child: Consumer<RanknewViewModel>(
          builder: (context, model, child) => ListView.builder(
            itemCount: model.items.length,
            itemBuilder: (context, index) => CreationAwareListItem(
              itemCreated: () {
                SchedulerBinding.instance.addPostFrameCallback(
                    (duration) => model.handleItemCreated(index));
              },
              child: ListItem(
                title: model.items[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
