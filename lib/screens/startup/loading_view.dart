import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:rive/rive.dart';
import 'package:yachtOne/widgets/like_button.dart';

import 'package:yachtOne/widgets/loading_container.dart';

class LoadingView extends StatelessWidget {
  RiveAnimationController _idleController = SimpleAnimation('idle', autoplay: true);

  // RxBool isLiked = false.obs;
  RxString state = "idle".obs;
  RxBool _isPlaying = false.obs;
  // Rx<SMIBool> isLiked = Rx<SMIBool>(false);
  // SMIBool isLiked = false;
  // final controller = StateMachineController.fromArtboard(
  //   artboard,
  //   'bumpy',
  //   onStateChange: _onStateChange,
  // );
  RxBool likeThis = true.obs;
  SMIBool? isLiked;
  @override
  Widget build(BuildContext context) {
    void _onRiveInit(Artboard artboard) {
      final controller = StateMachineController.fromArtboard(artboard, 'likeButton');
      artboard.addController(controller!);
      isLiked = controller.findInput<bool>('isLiked') as SMIBool;
      isLiked?.change(likeThis.value);
    }

    void _pressLike() => isLiked?.change(likeThis.value);

    return Scaffold(
      body: Container(
        // height: 20,
        color: yachtViolet,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Image.asset(
                  'assets/logos/white_splash.png',
                  color: white,
                  // height: 20,
                ),
              ),
              // SizedBox(
              //   height: 50,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     likeThis(!likeThis.value);
              //     _pressLike();
              //     print(likeThis.value);
              //   },
              //   child: SizedBox(
              //       height: 50,
              //       child: RiveAnimation.asset(
              //         'assets/buttons/like.riv',
              //         onInit: _onRiveInit,
              //         // animations: ['play', 'idle'],
              //         // controllers: [
              //         //   _playController,
              //         //   // _idleController,
              //         // ],
              //         stateMachines: ['likeButton'],
              //         // animations: ['idle', 'like'],
              //       )),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     likeThis(!likeThis.value);
              //     likeThis.refresh();
              //   },
              //   child: Obx(
              //     () => LikeButton(
              //       size: 80.0,
              //       isLiked: likeThis.value,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 50,
              //   child: RiveAnimation.asset(
              //     'assets/buttons/like.riv',
              //     animations: ['like'],
              //     controllers: [_idleController, _playController],
              //     // onInit: _controller.,
              //   ),
              // ),,
              // LoadingContainer(
              //   height: 200,
              //   width: 200,
              //   radius: 10,
              // ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     "PLAY",
              //     style: TextStyle(fontSize: 20),
              //   ),
              // ),
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     // ElevatedButton(
              //     //   child: const Text('Simple Animation'),
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute<void>(
              //     //         builder: (context) => const SimpleAnimation(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //     // const SizedBox(
              //     //   height: 10,
              //     // ),
              //     // ElevatedButton(
              //     //   child: const Text('Play/Pause Animation'),
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute<void>(
              //     //         builder: (context) => const PlayPauseAnimation(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //     // const SizedBox(
              //     //   height: 10,
              //     // ),
              //     // ElevatedButton(
              //     //   child: const Text('Play One-Shot Animation'),
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute<void>(
              //     //         builder: (context) => const PlayOneShotAnimation(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //     // const SizedBox(
              //     //   height: 10,
              //     // ),
              //     // ElevatedButton(
              //     //   child: const Text('Button State Machine'),
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute<void>(
              //     //         builder: (context) => const ExampleStateMachine(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //     // const SizedBox(
              //     //   height: 10,
              //     // ),
              //     // ElevatedButton(
              //     //   child: const Text('Skills Machine'),
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute<void>(
              //     //         builder: (context) => const StateMachineSkills(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //     // const SizedBox(
              //     //   height: 10,
              //     // ),
              //     // ElevatedButton(
              //     //   child: const Text('Little Machine'),
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute<void>(
              //     //         builder: (context) => const LittleMachine(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //     // const SizedBox(
              //     //   height: 10,
              //     // ),
              //     // ElevatedButton(
              //     //   child: const Text('Liquid Download'),
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute<void>(
              //     //         builder: (context) => const LiquidDownload(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //     // const SizedBox(
              //     //   height: 10,
              //     // ),
              //     // ElevatedButton(
              //     //   child: const Text('Custom Controller - Speed'),
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute<void>(
              //     //         builder: (context) => const SpeedyAnimation(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //     // const SizedBox(
              //     //   height: 10,
              //     // ),
              //     // ElevatedButton(
              //     //   child: const Text('Simple State Machine'),
              //     //   onPressed: () {
              //     //     Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute<void>(
              //     //         builder: (context) => const SimpleStateMachine(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpeedyAnimation extends StatelessWidget {
  const SpeedyAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Controller'),
      ),
      body: Center(
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/vehicles.riv',
          fit: BoxFit.cover,
          animations: const ['idle'],
          controllers: [SpeedController('curves', speedMultiplier: 1)],
        ),
      ),
    );
  }
}

class SpeedController extends SimpleAnimation {
  final double speedMultiplier;

  SpeedController(
    String animationName, {
    double mix = 1,
    this.speedMultiplier = 1,
  }) : super(animationName, mix: mix);

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (instance == null || !instance!.keepGoing) {
      isActive = false;
    }
    instance!
      ..animation.apply(instance!.time, coreContext: artboard, mix: mix)
      ..advance(elapsedSeconds * speedMultiplier);
  }
}

class PlayOneShotAnimation extends StatefulWidget {
  const PlayOneShotAnimation({Key? key}) : super(key: key);

  @override
  _PlayOneShotAnimationState createState() => _PlayOneShotAnimationState();
}

class _PlayOneShotAnimationState extends State<PlayOneShotAnimation> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Is the animation currently playing?
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      'bounce',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One-Shot Example'),
      ),
      body: Center(
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/vehicles.riv',
          animations: const ['idle', 'curves'],
          controllers: [_controller],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // disable the button while playing the animation
        onPressed: () => _isPlaying ? null : _controller.isActive = true,
        tooltip: 'Bounce',
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}

class PlayPauseAnimation extends StatefulWidget {
  const PlayPauseAnimation({Key? key}) : super(key: key);

  @override
  _PlayPauseAnimationState createState() => _PlayPauseAnimationState();
}

class _PlayPauseAnimationState extends State<PlayPauseAnimation> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Toggles between play and pause animation states
  void _togglePlay() => setState(() => _controller.isActive = !_controller.isActive);

  /// Tracks if the animation is playing by whether controller is running
  bool get isPlaying => _controller.isActive;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('idle');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Example'),
      ),
      body: Center(child: SimpleStateMachine()),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        tooltip: isPlaying ? 'Pause' : 'Play',
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class SimpleStateMachine extends StatefulWidget {
  const SimpleStateMachine({Key? key}) : super(key: key);

  @override
  _SimpleStateMachineState createState() => _SimpleStateMachineState();
}

class _SimpleStateMachineState extends State<SimpleStateMachine> {
  SMITrigger? _bump;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'bumpy');
    artboard.addController(controller!);
    _bump = controller.findInput<bool>('bump') as SMITrigger;
  }

  void _hitBump() => _bump?.fire();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Animation'),
      ),
      body: Center(
        child: GestureDetector(
          child: RiveAnimation.network(
            'https://cdn.rive.app/animations/vehicles.riv',
            fit: BoxFit.cover,
            onInit: _onRiveInit,
          ),
          onTap: _hitBump,
        ),
      ),
    );
  }
}
