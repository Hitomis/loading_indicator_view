import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-01
///

class BallScaleMultipleIndicator extends StatefulWidget {
  BallScaleMultipleIndicator({
    this.radius: 20,
    this.ballColor: Colors.white,
    this.duration: const Duration(milliseconds: 1000),
  });

  final double radius;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallScaleMultipleIndicatorState();
}

class _BallScaleMultipleIndicatorState extends State<BallScaleMultipleIndicator>
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
          painter: _BallScaleMultipleIndicatorPainter(
            animationValue: _animation.value,
            radius: widget.radius,
            ballColor: widget.ballColor,
            duration: widget.duration,
          ),
        );
      },
    );
  }
}

class _BallScaleMultipleIndicatorPainter extends CustomPainter {
  _BallScaleMultipleIndicatorPainter({
    this.animationValue,
    this.radius,
    this.ballColor,
    this.duration,
  }) : offsetList = <double>[radius, radius * .7, radius * .4];

  final double animationValue;
  final double radius;
  final Color ballColor;
  final Duration duration;
  final List<double> offsetList;

  @override
  void paint(Canvas canvas, Size size) {
    var percent = animationValue / radius;
    var paint = Paint()
      ..isAntiAlias = true
      ..color = Color.fromARGB((255 * (1 - percent)).toInt(), ballColor.red,
          ballColor.green, ballColor.blue)
      ..style = PaintingStyle.fill;

    var center = Offset(radius, radius);

    for (var i = 0; i < offsetList.length; i++) {
      canvas.save();
      canvas.drawCircle(center, offsetList[i] * percent, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
