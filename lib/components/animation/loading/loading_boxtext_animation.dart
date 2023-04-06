import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoaderBoxtext extends StatefulWidget {
  const LoaderBoxtext({Key? key}) : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<LoaderBoxtext>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, widget) {
          return Center(
            child: Transform.rotate(
              angle: _controller.status == AnimationStatus.forward
                  ? (math.pi * 2) * _controller.value
                  : -(math.pi * 2) * _controller.value,
              child: Container(
                height: 30.0,
                width: 30.0,
                child: CustomPaint(
                  painter: LoaderCanvas(radius: _animation.value),
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class LoaderCanvas extends CustomPainter {
  double radius;
  LoaderCanvas({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint arc = Paint()
      ..color = kcDarkTextColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Paint circle = Paint()
      ..color = kcLightGreyColor
      ..style = PaintingStyle.fill;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, size.width / 2.75, circle);
    canvas.drawArc(
        Rect.fromCenter(
            center: center,
            width: size.width * radius,
            height: size.height * radius),
        math.pi / 4,
        math.pi / 2,
        false,
        arc);
    canvas.drawArc(
        Rect.fromCenter(
            center: center,
            width: size.width * radius,
            height: size.height * radius),
        -math.pi / 4,
        -math.pi / 2,
        false,
        arc);
  }

  @override
  bool shouldRepaint(LoaderCanvas oldDelegate) {
    return true;
  }
}
