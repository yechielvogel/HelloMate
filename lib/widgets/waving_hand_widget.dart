import 'dart:math';
import 'package:flutter/material.dart';

final GlobalKey<WavingHandIconState> wavingHandIconKey =
    GlobalKey<WavingHandIconState>();

class WavingHandIcon extends StatefulWidget {
  final String iconImagePath;
  final GlobalKey<WavingHandIconState> wavingHandIconKey;

  WavingHandIcon({required this.iconImagePath, required this.wavingHandIconKey})
      : super(key: wavingHandIconKey);

  @override
  WavingHandIconState createState() => WavingHandIconState();
}

class WavingHandIconState extends State<WavingHandIcon>
    with SingleTickerProviderStateMixin<WavingHandIcon> {
  late AnimationController _controller;
  // this ignored might cause trouble will find out
  // ignore: unused_field
  double _rotationValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _rotationValue = _controller.value * 1 * pi;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> startWavingAnimation() async {
    if (mounted) {
      _controller.reset();
      _controller.forward();
    }
  }

  Future<void> waveHandOnDemand() async {
    if (mounted) {
      startWavingAnimation();
    }
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startWavingAnimation,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (mounted) {
            return Transform.rotate(
              angle: sin(_controller.value * pi * 3) * pi / 7,
              child: Image.asset(
                widget.iconImagePath,
                width: 40,
                height: 40,
                color: isDarkMode(context) ? Colors.white : Colors.black,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
