import 'dart:math';

import 'package:flutter/material.dart';

import '../infinite_progress.dart';

///
/// author: Vans Z
/// date: 2019-06-02
///

class LineSpinFadeLoaderIndicator extends StatefulWidget {
  LineSpinFadeLoaderIndicator({
    this.radius = 18,
    this.minLineWidth: 2.4,
    this.maxLineWidth: 4.8,
    this.minLineHeight: 4.8,
    this.maxLineHeight: 9.6,
    this.minBallAlpha: 77,
    this.maxBallAlpha: 255,
    this.ballColor: Colors.white,
    this.duration: const Duration(milliseconds: 500),
  });

  final double radius;
  final double minLineWidth;
  final double maxLineWidth;
  final double minLineHeight;
  final double maxLineHeight;
  final double minBallAlpha;
  final double maxBallAlpha;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _LineSpinFadeLoaderIndicatorState();
}

class _LineSpinFadeLoaderIndicatorState
    extends State<LineSpinFadeLoaderIndicator>
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
          size: measureSize(),
          painter: _LineSpinFadeLoaderIndicatorPainter(
              animationValue: animationValue,
              minLineWidth: widget.minLineWidth,
              maxLineWidth: widget.maxLineWidth,
              minLineHeight: widget.minLineHeight,
              maxLineHeight: widget.maxLineHeight,
              minAlpha: widget.minBallAlpha,
              maxAlpha: widget.maxBallAlpha,
              ballColor: widget.ballColor),
        );
      },
    );
  }

  @override
  Size measureSize() {
    return Size(2 * widget.radius, 2 * widget.radius);
  }
}

double _progress = .0;
double _lastExtent = .0;

class _LineSpinFadeLoaderIndicatorPainter extends CustomPainter {
  _LineSpinFadeLoaderIndicatorPainter({
    this.animationValue,
    this.minLineWidth,
    this.maxLineWidth,
    this.minLineHeight,
    this.maxLineHeight,
    this.minAlpha,
    this.maxAlpha,
    this.ballColor,
  });

  final double animationValue;
  final double minLineWidth;
  final double maxLineWidth;
  final double minLineHeight;
  final double maxLineHeight;
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
    var diffWidth = maxLineWidth - minLineWidth;
    var diffHeight = maxLineHeight - minLineHeight;
    for (int i = 0; i < 8; i++) {
      canvas.save();

      var newProgress = _progress - i * 22.5;
      var beatAlpha = sin(newProgress * pi / 180).abs() * diffAlpha + minAlpha;
      paint.color = Color.fromARGB(
          beatAlpha.round(), ballColor.red, ballColor.green, ballColor.blue);
      var scaleWidth =
          sin(newProgress * pi / 180).abs() * diffWidth + minLineWidth;
      var scaleHeight =
          sin(newProgress * pi / 180).abs() * diffHeight + minLineHeight;
      var point = _circleAt(size.width * .5, size.height * .5,
          size.width * .5 - maxLineWidth, i * pi / 4);

      canvas.translate(point.dx, point.dy);
      canvas.rotate((90 + (i * 45)) * pi / 180);
      Rect rect = Rect.fromLTWH(
          -scaleWidth * .5, -scaleHeight * .5, scaleWidth, scaleHeight);
      RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(4.0));
      canvas.drawRRect(rRect, paint);

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
