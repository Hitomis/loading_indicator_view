import 'dart:math';

import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-04
///

class BallClipRotateIndicator extends StatefulWidget {
  BallClipRotateIndicator({
    this.startAngle: -5,
    this.minRadius: 12,
    this.maxRadius: 20,
    this.color: Colors.white,
    this.duration: const Duration(milliseconds: 400),
  });

  final double startAngle;
  final double minRadius;
  final double maxRadius;
  final Color color;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallClipRotateIndicatorState();
}

class _BallClipRotateIndicatorState extends State<BallClipRotateIndicator>
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
      end: 360,
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
    return Size(2 * widget.maxRadius, 2 * widget.maxRadius);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: _measureSize(),
          painter: _BallClipRotateIndicatorPainter(
            angle: _rotate.value,
            radius: _radius.value,
            startAngle: widget.startAngle,
            minRadius: widget.minRadius,
            maxRadius: widget.maxRadius,
            color: widget.color,
          ),
        );
      },
    );
  }
}

double _progress = .0;
double _lastExtent = .0;

class _BallClipRotateIndicatorPainter extends CustomPainter {
  _BallClipRotateIndicatorPainter({
    this.angle,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.startAngle,
    this.color,
  });

  final double angle;
  final double radius;
  final double minRadius;
  final double maxRadius;
  final double startAngle;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = color;

    _progress += (_lastExtent - angle).abs();
    _lastExtent = angle;
    if (_progress >= double.maxFinite) {
      _progress = .0;
      _lastExtent = .0;
    }

    canvas.translate(size.width * .5, size.height * .5);
    canvas.rotate((_progress + startAngle) * pi / 180);
    var preScale = minRadius / maxRadius;
    var scale = preScale + (radius - minRadius) / maxRadius;
    canvas.scale(scale);
    Rect rect = Rect.fromLTWH(
        -size.width * .5, -size.height * .5, size.width, size.height);
    canvas.drawArc(rect, -45 * pi / 180, 270 * pi / 180, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
