import 'dart:math';

import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-06
///

class CubeTransitionIndicator extends StatefulWidget {
  CubeTransitionIndicator({
    this.size: 36,
    this.minCubeSize: 4,
    this.maxCubeSize: 8,
    this.cubeColor: Colors.white,
    this.duration: const Duration(milliseconds: 1600),
  });

  final double size;
  final double minCubeSize;
  final double maxCubeSize;
  final Color cubeColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _CubeTransitionIndicatorState();
}

class _CubeTransitionIndicatorState extends State<CubeTransitionIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> transX;
  Animation<double> transReverseX;
  Animation<double> transY;
  Animation<double> transReverseY;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    var end = widget.size - widget.maxCubeSize;
    transX = Tween<double>(begin: 0, end: end).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0, 0.25)));
    transY = Tween<double>(begin: 0, end: end).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.25, 0.5)));
    transReverseX = Tween<double>(begin: 0, end: end).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.5, 0.75)));
    transReverseY = Tween<double>(begin: 0, end: end).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.75, 1)));

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
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _CubeTransitionIndicatorPainter(
              transX: transX.value,
              transReverseX: transReverseX.value,
              transY: transY.value,
              transReverseY: transReverseY.value,
              minCubeSize: widget.minCubeSize,
              maxCubeSize: widget.maxCubeSize,
              color: widget.cubeColor,
            ),
          );
        },
      );
}

class _CubeTransitionIndicatorPainter extends CustomPainter {
  _CubeTransitionIndicatorPainter({
    this.transX,
    this.transReverseX,
    this.transY,
    this.transReverseY,
    this.minCubeSize,
    this.maxCubeSize,
    this.color,
  });

  final double transX;
  final double transReverseX;
  final double transY;
  final double transReverseY;
  final double minCubeSize;
  final double maxCubeSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    var end = size.width - maxCubeSize;
    drawLTCube(end, canvas, paint);
    drawRBCube(end, canvas, paint);
  }

  void drawRBCube(double end, Canvas canvas, Paint paint) {
    var percent, scale, dx, dy;
    final radian = pi / 180;
    final left = -maxCubeSize * .5;
    final top = -maxCubeSize * .5;

    canvas.save();

    if (transX < end) {
      percent = transX / end;
      scale = 1 - (1 - minCubeSize / maxCubeSize) * percent;
      dx = end + maxCubeSize * .5 - transX;
      dy = end + maxCubeSize * .5;
    } else if (transY < end) {
      percent = transY / end;
      scale = (1 - minCubeSize / maxCubeSize) * percent + 0.5;
      dx = maxCubeSize * .5;
      dy = end + maxCubeSize * .5 - transY;
    } else if (transReverseX < end) {
      percent = transReverseX / end;
      scale = 1 - (1 - minCubeSize / maxCubeSize) * percent;
      dx = transReverseX + maxCubeSize * .5;
      dy = maxCubeSize * .5;
    } else if (transReverseY < end) {
      percent = transReverseY / end;
      scale = (1 - minCubeSize / maxCubeSize) * percent + 0.5;
      dx = end + maxCubeSize * .5;
      dy = transReverseY + maxCubeSize * .5;
    }

    canvas.translate(dx, dy);
    canvas.rotate(-90 * percent * radian);
    canvas.scale(scale);
    canvas.drawRect(Rect.fromLTWH(left, top, maxCubeSize, maxCubeSize), paint);

    canvas.restore();
  }

  void drawLTCube(double end, Canvas canvas, Paint paint) {
    var percent, scale, dx, dy;
    final radian = pi / 180;
    final left = -maxCubeSize * .5;
    final top = -maxCubeSize * .5;

    canvas.save();

    if (transX < end) {
      percent = transX / end;
      scale = 1 - (1 - minCubeSize / maxCubeSize) * percent;
      dx = transX + maxCubeSize * .5;
      dy = maxCubeSize * .5;
    } else if (transY < end) {
      percent = transY / end;
      scale = (1 - minCubeSize / maxCubeSize) * percent + 0.5;
      dx = end + maxCubeSize * .5;
      dy = transY + maxCubeSize * .5;
    } else if (transReverseX < end) {
      percent = transReverseX / end;
      scale = 1 - (1 - minCubeSize / maxCubeSize) * percent;
      dx = end + maxCubeSize * .5 - transReverseX;
      dy = end + maxCubeSize * .5;
    } else if (transReverseY < end) {
      percent = transReverseY / end;
      scale = (1 - minCubeSize / maxCubeSize) * percent + 0.5;
      dx = maxCubeSize * .5;
      dy = end + maxCubeSize * .5 - transReverseY;
    }

    canvas.translate(dx, dy);
    canvas.rotate(-90 * percent * radian);
    canvas.scale(scale);
    canvas.drawRect(Rect.fromLTWH(left, top, maxCubeSize, maxCubeSize), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
