import 'package:flutter/material.dart';

class ButtonAnimation extends StatefulWidget {
  final String textBefore;
  final String textAfter;
  final Icon iconBefore;
  final Icon iconAfter;
  const ButtonAnimation(
      {Key? key,
      required this.textBefore,
      required this.textAfter,
      required this.iconBefore,
      required this.iconAfter})
      : super(key: key);

  @override
  State<ButtonAnimation> createState() => _ButtonAnimationState();
}

class _ButtonAnimationState extends State<ButtonAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  double _containerPaddingLeft = 20.0;
  late double _animationValue;
  double _translateX = 0;
  double _translateY = 0;
  double _rotate = 0;
  double _scale = 1;

  late bool show;
  bool sent = false;
  Color _color = Colors.lightBlue;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300));
    show = true;
    _animationController.addListener(() {
      setState(() {
        show = false;
        _animationValue = _animationController.value;
        if (_animationValue >= 0.2 && _animationValue < 0.4) {
          _containerPaddingLeft = 100.0;
          _color = Colors.green;
        } else if (_animationValue >= 0.4 && _animationValue <= 0.5) {
          _translateX = 80.0;
          _rotate = -20.0;
          _scale = 0.1;
        } else if (_animationValue >= 0.5 && _animationValue <= 0.8) {
          _translateY = -20.0;
        } else if (_animationValue >= 0.81) {
          _containerPaddingLeft = 20.0;
          sent = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(100.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                _animationController.forward();
              },
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: [
                    BoxShadow(
                      color: _color,
                      blurRadius: 21,
                      spreadRadius: -15,
                      offset: const Offset(
                        0.0,
                        20.0,
                      ),
                    )
                  ],
                ),
                padding: EdgeInsets.only(
                    left: _containerPaddingLeft,
                    right: 20.0,
                    top: 10.0,
                    bottom: 10.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    (!sent)
                        ? AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn,
                            transform: Matrix4.translationValues(
                                _translateX, _translateY, 0)
                              ..rotateZ(_rotate)
                              ..scale(_scale),
                            child: Icon(widget.iconBefore.icon),
                          )
                        : Container(),
                    AnimatedSize(
                      vsync: this,
                      duration: const Duration(milliseconds: 600),
                      child: show ? const SizedBox(width: 10.0) : Container(),
                    ),
                    AnimatedSize(
                      vsync: this,
                      duration: const Duration(milliseconds: 200),
                      child: show ? Text(widget.textBefore) : Container(),
                    ),
                    AnimatedSize(
                      vsync: this,
                      duration: const Duration(milliseconds: 200),
                      child: sent ? Icon(widget.iconAfter.icon) : Container(),
                    ),
                    AnimatedSize(
                      vsync: this,
                      alignment: Alignment.topLeft,
                      duration: const Duration(milliseconds: 600),
                      child: sent ? SizedBox(width: 10.0) : Container(),
                    ),
                    AnimatedSize(
                      vsync: this,
                      duration: const Duration(milliseconds: 200),
                      child: sent ? Text(widget.textAfter) : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
