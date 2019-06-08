import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_indicator_view/src/infinite_progress.dart';

///
/// author：Vans Z
/// date： 2019-05-29
///

class BallPulseSyncIndicator extends StatefulWidget {
  BallPulseSyncIndicator({
    this.radius: 7.2,
    this.extent: 16,
    this.spacing: 3,
    this.ballColor: Colors.white,
    this.duration: const Duration(milliseconds: 400),
  });

  final double radius;
  final double extent;
  final double spacing;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallPulseSyncIndicatorState();
}

class _BallPulseSyncIndicatorState extends State<BallPulseSyncIndicator>
    with TickerProviderStateMixin, InfiniteProgressMixin {

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
  Size measureSize() {
    var width = widget.radius * 2 * 3 + widget.spacing * 2;
    var height = widget.extent + widget.radius * 2;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child){
        return CustomPaint(
          size: measureSize(),
          painter: _BallPulseSyncIndicatorPainter(
            animationValue: animationValue,
            extent: widget.extent,
            radius: widget.radius,
            spacing: widget.spacing,
            ballColor: widget.ballColor,
          ),
        );
      }
    );
  }
}

double _progress = .0;
double _lastExtent = .0;

class _BallPulseSyncIndicatorPainter extends CustomPainter {
  _BallPulseSyncIndicatorPainter({
    this.animationValue,
    this.extent,
    this.radius,
    this.spacing,
    this.ballColor,
  }) : extentList = <double>[extent * 0.9, extent * 0.6, extent * 0.3];

  final double animationValue;
  final double extent;
  final double radius;
  final double spacing;
  final Color ballColor;
  final List<double> extentList;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = ballColor
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    _progress += (_lastExtent - animationValue).abs();
    _lastExtent = animationValue;
    if (_progress >= double.maxFinite) {
      _progress = .0;
      _lastExtent = .0;
    }
    for (int i = 0; i < extentList.length; i++) {
      var dx = radius + 2 * i * radius + i * spacing;
      var offsetExtent = asin(extentList[i] / extent);
      var offsetY = sin(_progress * pi / 180 + offsetExtent).abs() * extent + radius;
      var offset = Offset(dx, offsetY);
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
