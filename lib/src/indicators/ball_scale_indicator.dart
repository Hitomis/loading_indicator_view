import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-01
///

class BallScaleIndicator extends StatefulWidget {
  BallScaleIndicator({
    this.radius: 20,
    this.ballColor: Colors.white,
    this.duration: const Duration(milliseconds: 1000),
  });

  final double radius;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallScaleIndicatorState();
}

class _BallScaleIndicatorState extends State<BallScaleIndicator>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _animation = Tween<double>(begin: 0, end: widget.radius).animate(_animation)
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
    var size = 2 * widget.radius;
    return Size(size, size);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: _measureSize(),
          painter: _BallScaleIndicatorPainter(
            animationValue: _animation.value,
            radius: widget.radius,
            ballColor: widget.ballColor,
          ),
        );
      },
    );
  }
}

class _BallScaleIndicatorPainter extends CustomPainter {
  _BallScaleIndicatorPainter({
    this.animationValue,
    this.radius,
    this.ballColor,
  });

  final double animationValue;
  final double radius;
  final Color ballColor;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..color = Color.fromARGB((255 * (1 - animationValue / radius)).toInt(),
          ballColor.red, ballColor.green, ballColor.blue)
      ..style = PaintingStyle.fill;

    var center = Offset(radius, radius);
    canvas.drawCircle(center, animationValue, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
