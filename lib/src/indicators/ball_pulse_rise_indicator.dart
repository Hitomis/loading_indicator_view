import 'dart:math';

import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-07
///

class BallPulseRiseIndicator extends StatefulWidget {
  BallPulseRiseIndicator({
    this.ballRadius: 4.8,
    this.horizontalSpacing: 12,
    this.verticalSpacing: 24,
    this.color: Colors.white,
    this.duration: const Duration(milliseconds: 1250),
  });

  final double ballRadius;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Color color;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallPulseRiseIndicatorState();
}

class _BallPulseRiseIndicatorState extends State<BallPulseRiseIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _rotateX;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _rotateX = Tween<double>(begin: 0, end: 360)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
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
          painter: _BallPulseRiseIndicatorPainter(
            rotateX: _rotateX.value,
            ballRadius: widget.ballRadius,
            horizontalSpacing: widget.horizontalSpacing,
            verticalSpacing: widget.verticalSpacing,
            color: widget.color,
          ),
        );
      },
    );
  }

  Size _measureSize() {
    var width = widget.ballRadius * 2 * 3 + widget.horizontalSpacing * 2;
    var height = widget.ballRadius * 2 * 2 + widget.verticalSpacing;
    return Size(width, height);
  }
}

class _BallPulseRiseIndicatorPainter extends CustomPainter {
  _BallPulseRiseIndicatorPainter({
    this.rotateX,
    this.ballRadius,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.color,
  });

  final double rotateX;
  final double ballRadius;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    var matrix = Matrix4.rotationX(rotateX * pi / 180);
    canvas.translate(0, size.height * .5);
    canvas.transform(matrix.storage);

    var dx, dy;

    dx = (size.width - 2 * ballRadius - horizontalSpacing) * .5;
    dy = (-verticalSpacing - ballRadius) * .5;
    canvas.drawCircle(Offset(dx, dy), ballRadius, paint);

    dx = size.width - dx;
    canvas.drawCircle(Offset(dx, dy), ballRadius, paint);

    dx = ballRadius;
    dy = verticalSpacing * .5 + ballRadius;
    canvas.drawCircle(Offset(dx, dy), ballRadius, paint);

    dx = 3 * ballRadius + horizontalSpacing;
    canvas.drawCircle(Offset(dx, dy), ballRadius, paint);

    dx = 5 * ballRadius + 2 * horizontalSpacing;
    canvas.drawCircle(Offset(dx, dy), ballRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
