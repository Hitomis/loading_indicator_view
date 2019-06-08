import 'package:flutter/widgets.dart';

///
/// author：Vans Z
/// date： 2019-06-01
///

mixin InfiniteProgressMixin {
  Animation<double> _animation;
  AnimationController controller;

  double get animationValue => _animation.value;

  void startEngine(TickerProvider vsync, Duration duration) {
    controller = AnimationController(vsync: vsync, duration: duration);
    _animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    _animation = Tween<double>(begin: 0, end: 90).animate(_animation)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  Size measureSize();

  void closeEngine() {
    controller?.dispose();
  }
}
