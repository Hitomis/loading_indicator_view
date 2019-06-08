import 'dart:math';

import 'package:flutter/material.dart';

import '../infinite_progress.dart';

///
/// author: Vans Z
/// date: 2019-06-02
///

class BallSpinFadeLoaderIndicator extends StatefulWidget {
  BallSpinFadeLoaderIndicator({
    this.radius = 24,
    this.minBallRadius: 1.6,
    this.maxBallRadius: 5,
    this.minBallAlpha: 77,
    this.maxBallAlpha: 255,
    this.ballColor: Colors.white,
    this.duration: const Duration(milliseconds: 500),
  });

  final double radius;
  final double minBallRadius;
  final double maxBallRadius;
  final double minBallAlpha;
  final double maxBallAlpha;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallSpinFadeLoaderIndicatorState();
}

class _BallSpinFadeLoaderIndicatorState
    extends State<BallSpinFadeLoaderIndicator>
    with SingleTickerProviderStateMixin, InfiniteProgressMixin {
  @override
  void initState() {
    startEngine(this, widget.duration);
    super.initState();
  }

  @override
  void dispose() {
    closeEngine();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: _measureSize(),
          painter: _BallSpinFadeLoaderIndicatorPainter(
              animationValue: animationValue,
              minRadius: widget.minBallRadius,
              maxRadius: widget.maxBallRadius,
              minAlpha: widget.minBallAlpha,
              maxAlpha: widget.maxBallAlpha,
              ballColor: widget.ballColor),
        );
      },
    );
  }

  Size _measureSize() {
    return Size(2 * widget.radius, 2 * widget.radius);
  }

  @override
  Size measureSize() {
    return Size(2 * widget.radius, 2 * widget.radius);
  }
}

double _progress = .0;
double _lastExtent = .0;

class _BallSpinFadeLoaderIndicatorPainter extends CustomPainter {
  _BallSpinFadeLoaderIndicatorPainter({
    this.animationValue,
    this.minRadius,
    this.maxRadius,
    this.minAlpha,
    this.maxAlpha,
    this.ballColor,
  });

  final double animationValue;
  final double minRadius;
  final double maxRadius;
  final double minAlpha;
  final double maxAlpha;
  final Color ballColor;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    _progress += (_lastExtent - animationValue).abs();
    _lastExtent = animationValue;
    if (_progress >= double.maxFinite) {
      _progress = .0;
      _lastExtent = .0;
    }

    var diffAlpha = maxAlpha - minAlpha;
    var diffRadius = maxRadius - minRadius;
    for (int i = 0; i < 8; i++) {
      canvas.save();

      var newProgress = _progress - i * 22.5;
      var beatAlpha = sin(newProgress * pi / 180).abs() * diffAlpha + minAlpha;
      paint.color = Color.fromARGB(
          beatAlpha.round(), ballColor.red, ballColor.green, ballColor.blue);
      var scaleRadius =
          sin(newProgress * pi / 180).abs() * diffRadius + minRadius;
      var point = _circleAt(size.width * .5, size.height * .5,
          size.width * .5 - maxRadius, i * pi / 4);
      canvas.drawCircle(point, scaleRadius, paint);

      canvas.restore();
    }
  }

  Offset _circleAt(double width, double height, double radius, double angle) {
    var x = width + radius * (cos(angle));
    var y = height + radius * (sin(angle));
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
