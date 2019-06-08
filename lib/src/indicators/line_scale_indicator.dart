import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_indicator_view/src/infinite_progress.dart';

///
/// author: Vans Z
/// date: 2019-06-01
///

class LineScaleIndicator extends StatefulWidget {
  LineScaleIndicator({
    this.maxLength: 38,
    this.minLength: 12,
    this.spacing: 3.5,
    this.lineWidth: 4,
    this.lineNum: 5,
    this.lineColor: Colors.white,
    this.duration: const Duration(milliseconds: 400),
  });

  final double maxLength;
  final double minLength;
  final double lineWidth;
  final double spacing;
  final int lineNum;
  final Color lineColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _LineScaleIndicatorState();
}

class _LineScaleIndicatorState extends State<LineScaleIndicator>
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
          painter: _LineScaleIndicatorPainter(
            animationValue: animationValue,
            minLength: widget.minLength,
            maxLength: widget.maxLength,
            spacing: widget.spacing,
            lineNum: widget.lineNum,
            lineWidth: widget.lineWidth,
            lineColor: widget.lineColor,
          ),
        );
      },
    );
  }

  @override
  Size measureSize() {
    var width = widget.lineNum * widget.lineWidth +
        (widget.lineNum - 1) * widget.spacing;
    return Size(width, widget.maxLength);
  }
}

double _progress = .0;
double _lastExtent = .0;

class _LineScaleIndicatorPainter extends CustomPainter {
  _LineScaleIndicatorPainter({
    this.animationValue,
    this.minLength,
    this.maxLength,
    this.lineWidth,
    this.spacing,
    this.lineNum,
    this.lineColor,
  }) {
    offsetLength = <double>[];
    var diffLength = maxLength - minLength;
    for (int i = 0; i < lineNum; i++) {
      offsetLength.add(minLength + diffLength * 2 * i / 10.0);
    }
  }

  final double animationValue;
  final double minLength;
  final double maxLength;
  final double lineWidth;
  final double spacing;
  final int lineNum;
  final Color lineColor;

  List<double> offsetLength;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = lineColor
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    _progress += (_lastExtent - animationValue).abs();
    _lastExtent = animationValue;
    if (_progress >= double.maxFinite) {
      _progress = .0;
      _lastExtent = .0;
    }

    var diffLength = maxLength - minLength;
    for (int i = 0; i < lineNum; i++) {
      var offsetExtent = asin((offsetLength[i] - minLength) / diffLength);
      var scaleLength =
          sin(_progress * pi / 180 + offsetExtent).abs() * diffLength +
              minLength;
      var left = (lineWidth + spacing) * i;
      var top = (maxLength - scaleLength) * .5;
      Rect rect = Rect.fromLTWH(left, top, lineWidth, scaleLength);
      RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(4.0));
      canvas.drawRRect(rRect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
