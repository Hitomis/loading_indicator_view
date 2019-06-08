import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-03
///

class BallScaleRippleIndicator extends StatefulWidget {
  BallScaleRippleIndicator({
    this.radius: 20,
    this.ballColor: Colors.white,
    this.duration: const Duration(milliseconds: 1000),
  });

  final double radius;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallScaleRippleIndicatorState();
}

class _BallScaleRippleIndicatorState extends State<BallScaleRippleIndicator>
    with SingleTickerProviderStateMixin {
  Animation<double> _radius;
  Animation<double> _alpha;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _radius = Tween<double>(begin: 0, end: widget.radius)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0, 0.6)));
    _alpha = Tween<double>(begin: 255, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.6, 1)));
    _controller.addStatusListener((AnimationStatus status) {
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
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: _measureSize(),
          painter: _BallScaleRippleIndicatorPainter(
            radiusAnimValue: _radius.value,
            alphaAnimValue: _alpha.value,
            totalRadius: widget.radius,
            ballColor: widget.ballColor,
          ),
        );
      },
    );
  }
}

class _BallScaleRippleIndicatorPainter extends CustomPainter {
  _BallScaleRippleIndicatorPainter({
    this.radiusAnimValue,
    this.alphaAnimValue,
    this.totalRadius,
    this.ballColor,
  });

  final double radiusAnimValue;
  final double alphaAnimValue;
  final double totalRadius;
  final Color ballColor;

  @override
  void paint(Canvas canvas, Size size) {
    var percent = radiusAnimValue / totalRadius;
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * percent;

    if (alphaAnimValue >= 255) {
      paint.color = Color.fromARGB((255 * percent).round(), ballColor.red,
          ballColor.green, ballColor.blue);
    } else {
      paint.color = Color.fromARGB(alphaAnimValue.round(), ballColor.red,
          ballColor.green, ballColor.blue);
    }

    var center = Offset(totalRadius, totalRadius);
    canvas.drawCircle(center, radiusAnimValue, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
