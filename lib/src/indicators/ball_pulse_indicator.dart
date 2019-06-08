import 'package:flutter/material.dart';
import 'dart:math';

import 'package:loading_indicator_view/src/infinite_progress.dart';

///
/// author：Vans Z
/// date： 2019-05-27
///
class BallPulseIndicator extends StatefulWidget {
  BallPulseIndicator({
    this.minRadius: 2.4,
    this.maxRadius: 7.2,
    this.spacing: 3,
    this.ballColor: Colors.white,
    this.duration: const Duration(milliseconds: 400),
  });

  final double minRadius;
  final double maxRadius;
  final double spacing;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallPulseIndicatorState();
}

class _BallPulseIndicatorState extends State<BallPulseIndicator>
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
    var width = widget.maxRadius * 2 * 3 + widget.spacing * 2;
    var height = widget.maxRadius * 2;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: measureSize(),
          painter: _BallPulseIndicatorPainter(
            animationValue: animationValue,
            minRadius: widget.minRadius,
            maxRadius: widget.maxRadius,
            spacing: widget.spacing,
            ballColor: widget.ballColor,
          ),
        );
      },
    );
  }
}

double _progress = .0;
double _lastExtent = .0;

class _BallPulseIndicatorPainter extends CustomPainter {
  _BallPulseIndicatorPainter({
    this.animationValue,
    this.minRadius,
    this.maxRadius,
    this.spacing,
    this.ballColor,
  }) : radiusList = <double>[
          minRadius + (maxRadius - minRadius) * 0.9,
          minRadius + (maxRadius - minRadius) * 0.6,
          minRadius + (maxRadius - minRadius) * 0.3,
        ];

  final double animationValue;
  final double minRadius;
  final double maxRadius;
  final double spacing;
  final Color ballColor;
  final List<double> radiusList;

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
    for (int i = 0; i < radiusList.length; i++) {
      var dx = maxRadius + 2 * i * maxRadius + i * spacing;
      var offset = Offset(dx, maxRadius);

      var offsetExtent = asin((radiusList[i] - minRadius) / diffRadius);
      var scaleRadius =
          sin(_progress * pi / 180 + offsetExtent).abs() * diffRadius +
              minRadius;
      canvas.drawCircle(offset, scaleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
