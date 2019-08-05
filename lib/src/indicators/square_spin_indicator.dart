import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// author: Vans Z
/// date: 2019-06-02
///

class SquareSpinIndicator extends StatefulWidget {
  SquareSpinIndicator({
    this.length = 36,
    this.color = Colors.white,
    this.duration = const Duration(milliseconds: 1250),
  });

  final double length;
  final Color color;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _SquareSpinIndicatorState();
}

class _SquareSpinIndicatorState extends State<SquareSpinIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _rotateX, _rotateY;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _rotateX = Tween<double>(begin: 0, end: 180)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0, 0.5)));
    _rotateY = Tween<double>(begin: 0, end: 180)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.5, 1)));
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.reset();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: _measureSize(),
          painter: _SquareSpinIndicatorPainter(
            rotateX: _rotateX.value,
            rotateY: _rotateY.value,
            color: widget.color,
          ),
        );
      },
    );
  }

  Size _measureSize() => Size(widget.length, widget.length);
}

class _SquareSpinIndicatorPainter extends CustomPainter {
  _SquareSpinIndicatorPainter({
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

    final halfLength = size.width * .5;
    var rect = Rect.fromLTWH(-halfLength, -halfLength, size.width, size.height);

    final radian = pi / 180;
    var matrix;
    if (rotateX < 180) {
      matrix = Matrix4.rotationX(rotateX * radian);
    } else if (rotateY < 180) {
      matrix = Matrix4.rotationY(rotateY * radian);
    }

    canvas.translate(halfLength, halfLength);
    canvas.transform(matrix.storage);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
