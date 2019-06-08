import 'dart:math';

import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-04
///

class SemiCircleSpinIndicator extends StatefulWidget {
  SemiCircleSpinIndicator({
    this.radius: 24,
    this.color: Colors.white,
    this.duration: const Duration(milliseconds: 600),
  });

  final double radius;
  final Color color;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _SemiCircleSpinIndicatorState();
}

class _SemiCircleSpinIndicatorState extends State<SemiCircleSpinIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _animation = Tween<double>(begin: 0, end: 360).animate(_animation)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _controller.forward();
        }
      });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Size _measureSize() {
    return Size(2 * widget.radius, 2 * widget.radius);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: _measureSize(),
          painter: _SemiCircleSpinIndicatorPainter(
            animationValue: _animation.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _SemiCircleSpinIndicatorPainter extends CustomPainter {
  _SemiCircleSpinIndicatorPainter({
    this.animationValue,
    this.color,
  });

  final double animationValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.translate(size.width * .5, size.height * .5);
    canvas.rotate(animationValue * pi / 180);
    Rect rect = Rect.fromLTWH(
        -size.width * .5, -size.height * .5, size.width, size.height);
    canvas.drawArc(rect, -60 * pi / 180, 120 * pi / 180, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
