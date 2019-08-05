import 'dart:math';

import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-07
///

class BallRotateIndicator extends StatefulWidget {
  BallRotateIndicator({
    this.minBallRadius: 2,
    this.maxBallRadius: 4,
    this.spacing: 7,
    this.color: Colors.white,
    this.duration: const Duration(milliseconds: 500),
  });

  final double minBallRadius;
  final double maxBallRadius;
  final double spacing;
  final Color color;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallRotateIndicatorState();
}

class _BallRotateIndicatorState extends State<BallRotateIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _radius;
  Animation<double> _rotate;

  @override
  void initState() {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _radius = Tween<double>(begin: widget.minBallRadius, end: widget.maxBallRadius).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    _rotate = Tween<double>(begin: 0, end: 180).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
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

  Size measureSize() {
    var width = widget.maxBallRadius * 2 * 3 + widget.spacing * 2;
    var height = widget.maxBallRadius * 2;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
          size: measureSize(),
          painter: _BallRotateIndicatorPainter(
            angle: _rotate.value,
            radius: _radius.value,
            maxBallRadius: widget.maxBallRadius,
            minBallRadius: widget.minBallRadius,
            spacing: widget.spacing,
            color: widget.color,
          ),
        ),
      );
}

double _progress = .0;
double _lastExtent = .0;

class _BallRotateIndicatorPainter extends CustomPainter {
  _BallRotateIndicatorPainter({
    this.angle,
    this.radius,
    this.minBallRadius,
    this.maxBallRadius,
    this.spacing,
    this.color,
  });

  final double angle;
  final double radius;
  final double minBallRadius;
  final double maxBallRadius;
  final double spacing;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    _progress += (_lastExtent - angle).abs();
    _lastExtent = angle;
    if (_progress >= double.maxFinite) {
      _progress = .0;
      _lastExtent = .0;
    }

    canvas.translate(size.width * .5, size.height * .5);
    canvas.rotate((_progress) * pi / 180);

    var preScale = minBallRadius / maxBallRadius;
    var scale = preScale + (radius - minBallRadius) / maxBallRadius;
    canvas.scale(scale);

    for (var i = 0; i < 3; i++) {
      var dx = (2 * i - 2) * maxBallRadius + (i - 1) * spacing;
      canvas.drawCircle(Offset(dx, 0), maxBallRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
