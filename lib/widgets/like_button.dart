import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:rive/rive.dart';

class LikeButton extends StatefulWidget {
  LikeButton({
    Key? key,
    required this.size,
    required this.isLiked,
  }) : super(key: key);
  final double size;
  final bool isLiked;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  RxBool isButtonTrue = false.obs;
  SMIBool? smiBool;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'likeButton');
    artboard.addController(controller!);
    smiBool = controller.findInput<bool>('isLiked') as SMIBool;
    smiBool?.change(widget.isLiked);
    // print('smibool: ${smiBool!.value}');
  }

  @override
  void initState() {
    super.initState();
    isButtonTrue.listen((value) {
      // print('listening: $value');
      smiBool?.change(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    isButtonTrue(widget.isLiked);
    // print(smiBool!.value);
    return SizedBox(
        height: widget.size,
        width: widget.size,
        child: RiveAnimation.asset(
          'assets/buttons/like.riv',
          onInit: _onRiveInit,
          stateMachines: ['likeButton'],
        ));
  }
}
