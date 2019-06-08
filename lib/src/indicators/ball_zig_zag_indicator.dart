import 'dart:math';

import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-06
///

class BallZigZagIndicator extends StatefulWidget {
  BallZigZagIndicator({
    this.width: 40,
    this.height: 40,
    this.ballRadius: 4.8,
    this.color: Colors.white,
    this.duration: const Duration(milliseconds: 1000),
  });

  final double width;
  final double height;
  final double ballRadius;
  final Color color;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallZigZagIndicatorState();
}

class _BallZigZagIndicatorState extends State<BallZigZagIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _horizontal;
  Animation<double> _rightWaistX;
  Animation<double> _rightWaistY;
  Animation<double> _leftWaistX;
  Animation<double> _leftWaistY;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    var waistLength = sqrt(pow(widget.width * .5 - widget.ballRadius, 2) +
        pow(widget.height * .5 - widget.ballRadius, 2));
    var horizontalLength = widget.width - 2 * widget.ballRadius;
    var triangleLength = horizontalLength + 2 * waistLength;
    var horEndInterval = horizontalLength / triangleLength;
    var rightEndInterval = waistLength / triangleLength + horEndInterval;
    var leftEndInterval = waistLength / triangleLength + rightEndInterval;

    var begin = widget.ballRadius;
    var end = widget.width - widget.ballRadius;

    _horizontal = Tween<double>(begin: begin, end: end).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0, horEndInterval)));

    begin = widget.width - widget.ballRadius;
    end = widget.width * .5;
    _rightWaistX = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(horEndInterval, rightEndInterval)));
    begin = widget.ballRadius;
    end = widget.height * .5;
    _rightWaistY = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(horEndInterval, rightEndInterval)));

    begin = widget.width * .5;
    end = widget.ballRadius;
    _leftWaistX = Tween<double>(begin: begin, end: end).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(rightEndInterval, leftEndInterval)));
    begin = widget.height * .5;
    end = widget.ballRadius;
    _leftWaistY = Tween<double>(begin: begin, end: end).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(rightEndInterval, leftEndInterval)));

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
      builder: (context, child) => CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _BallZigZagIndicatorPainter(
              horizontal: _horizontal.value,
              rightWaistX: _rightWaistX.value,
              rightWaistY: _rightWaistY.value,
              leftWaistX: _leftWaistX.value,
              leftWaistY: _leftWaistY.value,
              ballRadius: widget.ballRadius,
              color: widget.color,
            ),
          ),
    );
  }
}

class _BallZigZagIndicatorPainter extends CustomPainter {
  _BallZigZagIndicatorPainter({
    this.horizontal,
    this.rightWaistX,
    this.rightWaistY,
    this.leftWaistX,
    this.leftWaistY,
    this.ballRadius,
    this.color,
  });

  final double horizontal;
  final double rightWaistX;
  final double rightWaistY;
  final double leftWaistX;
  final double leftWaistY;
  final double ballRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.save();
    if (horizontal < size.width - ballRadius) {
      canvas.drawCircle(Offset(horizontal, ballRadius), ballRadius, paint);
    } else if (rightWaistX > size.width * .5 &&
        rightWaistY < size.height * .5) {
      canvas.drawCircle(Offset(rightWaistX, rightWaistY), ballRadius, paint);
    } else if (leftWaistX > ballRadius && leftWaistY > ballRadius) {
      canvas.drawCircle(Offset(leftWaistX, leftWaistY), ballRadius, paint);
    }
    canvas.restore();

    canvas.save();
    canvas.translate(0, size.height);
    canvas.transform(Matrix4.rotationX(pi).storage);
    canvas.translate(size.width, 0);
    canvas.transform(Matrix4.rotationY(pi).storage);
    if (horizontal < size.width - ballRadius) {
      canvas.drawCircle(Offset(horizontal, ballRadius), ballRadius, paint);
    } else if (rightWaistX > size.width * .5 &&
        rightWaistY < size.height * .5) {
      canvas.drawCircle(Offset(rightWaistX, rightWaistY), ballRadius, paint);
    } else if (leftWaistX > ballRadius && leftWaistY > ballRadius) {
      canvas.drawCircle(Offset(leftWaistX, leftWaistY), ballRadius, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
