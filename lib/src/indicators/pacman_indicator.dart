import 'dart:math';

import 'package:flutter/material.dart';

///
/// author: Vans Z
/// date: 2019-06-04
///

class PacmanIndicator extends StatefulWidget {
  PacmanIndicator({
    this.radius: 16,
    this.beanRadius: 4,
    this.color: Colors.white,
    this.duration: const Duration(milliseconds: 325),
  });

  final double radius;
  final double beanRadius;
  final Color color;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _PacmanIndicatorState();
}

class _PacmanIndicatorState extends State<PacmanIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> pacman;
  Animation<double> bean;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    pacman = Tween<double>(begin: 0, end: 90)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    bean = Tween<double>(begin: 0, end: widget.radius * .5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
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
    var width = (widget.radius + widget.beanRadius) * 2;
    var height = widget.radius * 2;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
              size: _measureSize(),
              painter: _PacmanIndicatorPainter(
                pacmanAngle: pacman.value,
                beanTransX: bean.value,
                radius: widget.radius,
                beanRadius: widget.beanRadius,
                color: widget.color,
              ),
            ));
  }
}

double _progress = .0;
double _lastExtent = .0;

class _PacmanIndicatorPainter extends CustomPainter {
  _PacmanIndicatorPainter({
    this.pacmanAngle,
    this.beanTransX,
    this.radius,
    this.beanRadius,
    this.color,
  });

  final double pacmanAngle;
  final double beanTransX;
  final double radius;
  final double beanRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    var width = radius * 2;
    var height = radius * 2;
    var radian = pi / 180;
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawArc(rect, (0 + pacmanAngle * .5) * radian,
        (360 - pacmanAngle) * radian, true, paint);

    _progress += (_lastExtent - beanTransX).abs();
    _lastExtent = beanTransX;
    if (_progress >= radius) {
      _progress = .0;
      _lastExtent = .0;
    }

    var beanAlpha = 255 - (122.5 * _progress / radius);
    paint.color =
        Color.fromARGB(beanAlpha.round(), color.red, color.green, color.blue);

    var cx = width + beanRadius;
    var cy = size.height * .5;
    canvas.drawCircle(Offset(cx - _progress, cy), beanRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
