import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_indicator_view/src/infinite_progress.dart';

///
/// author: Vans Z
/// date: 2019-05-31
///

class BallGridPulseIndicator extends StatefulWidget {
  BallGridPulseIndicator({
    this.minRadius: 3.6,
    this.maxRadius: 7.2,
    this.minAlpha: 51,
    this.maxAlpha: 255,
    this.spacing: 3,
    this.ballColor: Colors.white,
    this.duration: const Duration(milliseconds: 400),
  });

  final double minRadius;
  final double maxRadius;
  final double minAlpha;
  final double maxAlpha;
  final double spacing;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallGridPulseIndicatorState();
}

class _BallGridPulseIndicatorState extends State<BallGridPulseIndicator>
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
  Size measureSize() {
    var size = widget.maxRadius * 2 * 3 + widget.spacing * 2;
    return Size(size, size);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            size: measureSize(),
            painter: _BallGridPulseIndicatorPainter(
                animationValue: animationValue,
                minRadius: widget.minRadius,
                maxRadius: widget.maxRadius,
                minAlpha: widget.minAlpha,
                maxAlpha: widget.maxAlpha,
                spacing: widget.spacing,
                ballColor: widget.ballColor),
          );
        });
  }
}

double _progress = .0;
double _lastExtent = .0;

class _BallGridPulseIndicatorPainter extends CustomPainter {
  _BallGridPulseIndicatorPainter({
    this.animationValue,
    this.minRadius,
    this.maxRadius,
    this.minAlpha,
    this.maxAlpha,
    this.spacing,
    this.ballColor,
  })  : radiusList = <double>[
          minRadius + (maxRadius - minRadius) * 0.9,
          minRadius + (maxRadius - minRadius) * 0.8,
          minRadius + (maxRadius - minRadius) * 0.7,
          minRadius + (maxRadius - minRadius) * 0.6,
          minRadius + (maxRadius - minRadius) * 0.5,
          minRadius + (maxRadius - minRadius) * 0.4,
          minRadius + (maxRadius - minRadius) * 0.3,
          minRadius + (maxRadius - minRadius) * 0.2,
          minRadius + (maxRadius - minRadius) * 0.1,
        ],
        alphaList = <double>[
          minAlpha + (maxAlpha - minAlpha) * 0.9,
          minAlpha + (maxAlpha - minAlpha) * 0.8,
          minAlpha + (maxAlpha - minAlpha) * 0.7,
          minAlpha + (maxAlpha - minAlpha) * 0.6,
          minAlpha + (maxAlpha - minAlpha) * 0.5,
          minAlpha + (maxAlpha - minAlpha) * 0.4,
          minAlpha + (maxAlpha - minAlpha) * 0.3,
          minAlpha + (maxAlpha - minAlpha) * 0.2,
          minAlpha + (maxAlpha - minAlpha) * 0.1,
        ];
  final double animationValue;
  final double minRadius;
  final double maxRadius;
  final double minAlpha;
  final double maxAlpha;
  final double spacing;
  final Color ballColor;
  final List<double> radiusList;
  final List<double> alphaList;

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

    var diffRadius = maxRadius - minRadius;
    var diffAlpha = maxAlpha - minAlpha;
    for (int i = 0; i < radiusList.length; i++) {
      canvas.save();
      int row = i ~/ 3;
      int column = i % 3;

      var dx = maxRadius + 2 * column * maxRadius + column * spacing;
      var dy = (2 * row + 1) * maxRadius + row * spacing;
      var offset = Offset(dx, dy);

      var offsetAlpha = asin((alphaList[i] - minAlpha) / diffAlpha);
      var beatAlpha =
          sin(_progress * pi / 180 + offsetAlpha).abs() * diffAlpha + minAlpha;
      paint.color = Color.fromARGB(
          beatAlpha.round(), ballColor.red, ballColor.green, ballColor.blue);

      var offsetExtent = asin((radiusList[i] - minRadius) / diffRadius);
      var scaleRadius =
          sin(_progress * pi / 180 + offsetExtent).abs() * diffRadius +
              minRadius;
      canvas.drawCircle(offset, scaleRadius, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
