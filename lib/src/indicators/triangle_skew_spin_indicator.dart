import 'dart:math';

import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-08
///

class TriangleSkewSpinIndicator extends StatefulWidget {
  TriangleSkewSpinIndicator({
    this.width: 42,
    this.height: 28,
    this.color: Colors.white,
    this.duration: const Duration(milliseconds: 1250),
  });

  final double width;
  final double height;
  final Color color;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _TriangleSkewSpinIndicatorState();
}

class _TriangleSkewSpinIndicatorState extends State<TriangleSkewSpinIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _rotateX, _rotateY;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _rotateY = Tween<double>(begin: 0, end: 180)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0, 0.5)));
    _rotateX = Tween<double>(begin: 0, end: 180)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.5, 1)));
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.reset();
        _controller.forward();
        _count++;
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

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
              size: Size(widget.width, widget.height),
              painter: _TriangleSkewSpinIndicatorPainter(
                rotateX: _rotateX.value,
                rotateY: _rotateY.value,
                color: widget.color,
              ),
            ),
      );
}

var _count = 0;

class _TriangleSkewSpinIndicatorPainter extends CustomPainter {
  _TriangleSkewSpinIndicatorPainter({
    this.rotateX,
    this.rotateY,
    this.color,
  });

  final double rotateX;
  final double rotateY;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    final radian = pi / 180;
    var matrix;
    if (rotateY < 180) {
      matrix = Matrix4.rotationY(rotateY * radian);
    } else if (rotateX < 180) {
      matrix = Matrix4.rotationX(rotateX * radian);
    }

    final halfWidth = size.width * .5;
    final halfHeight = size.height * .5;

    var path;
    if (_count % 2 == 0) {
      path = Path()
        ..moveTo(0, halfHeight)
        ..lineTo(halfWidth, -halfHeight)
        ..lineTo(-halfWidth, -halfHeight)
        ..close();
    } else {
      path = Path()
        ..moveTo(0, -halfHeight)
        ..lineTo(halfWidth, halfHeight)
        ..lineTo(-halfWidth, halfHeight)
        ..close();
    }
    canvas.translate(halfWidth, halfHeight);
    canvas.transform(matrix.storage);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
