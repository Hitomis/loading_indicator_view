import 'dart:math';

import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-05
///

class BallClipRotatePulseIndicator extends StatefulWidget {
  BallClipRotatePulseIndicator({
    this.startAngle: -5,
    this.minRadius: 10,
    this.maxRadius: 20,
    this.solidCircleRadius: 10,
    this.color: Colors.white,
    this.duration: const Duration(milliseconds: 400),
  });

  final double startAngle;
  final double minRadius;
  final double maxRadius;
  final double solidCircleRadius;
  final Color color;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallClipRotatePulseIndicatorState();
}

class _BallClipRotatePulseIndicatorState
    extends State<BallClipRotatePulseIndicator>
    with SingleTickerProviderStateMixin {
  Animation<double> _radius;
  Animation<double> _rotate;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _radius =
        Tween<double>(begin: widget.minRadius, end: widget.maxRadius).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 1, curve: Curves.fastOutSlowIn),
      ),
    );
    _rotate = Tween<double>(
      begin: 0,
      end: 180,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 1, curve: Curves.fastOutSlowIn),
      ),
    );
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
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
    return Size(widget.maxRadius * 2, widget.maxRadius * 2);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: _measureSize(),
          painter: _BallClipRotatePulseIndicatorPainter(
            angle: _rotate.value,
            radius: _radius.value,
            minRadius: widget.minRadius,
            maxRadius: widget.maxRadius,
            solidCircleRadius: widget.solidCircleRadius,
            startAngle: widget.startAngle,
            color: widget.color,
          ),
        );
      },
    );
  }
}

double _progress = .0;
double _lastExtent = .0;

class _BallClipRotatePulseIndicatorPainter extends CustomPainter {
  _BallClipRotatePulseIndicatorPainter({
    this.angle,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.solidCircleRadius,
    this.startAngle,
    this.color,
  }) : startAngles = <double>[225, 45];

  final double angle;
  final double radius;
  final double minRadius;
  final double maxRadius;
  final double solidCircleRadius;
  final double startAngle;
  final List<double> startAngles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    _progress += (_lastExtent - angle).abs();
    _lastExtent = angle;
    if (_progress >= double.maxFinite) {
      _progress = .0;
      _lastExtent = .0;
    }

    var halfWidth = size.width * .5;
    var halfHeight = size.height * .5;

    canvas.translate(halfWidth, halfHeight);
    canvas.rotate((_progress + startAngle) * pi / 180);
    var preScale = minRadius / maxRadius;
    var scale = preScale + (radius - minRadius) / maxRadius;
    canvas.scale(scale);

    paint.style = PaintingStyle.stroke;
    for (var i = 0; i < startAngles.length; i++) {
      Rect rect =
          Rect.fromLTWH(-halfWidth, -halfHeight, size.width, size.height);
      canvas.drawArc(
          rect, startAngles[i] * pi / 180, 90 * pi / 180, false, paint);
    }

    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0, 0), solidCircleRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
