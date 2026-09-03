import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Renders a simulated thermal-camera overlay on top of the live video feed.
///
/// There is no real thermal sensor connected, so this animates a
/// blue-to-white "heat map" gradient over the video using [BlendMode.hue]
/// to approximate a thermal-camera look for demo purposes.
class ThermalView extends StatefulWidget {
  const ThermalView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final VideoPlayerController controller;

  @override
  State<ThermalView> createState() => _ThermalViewState();
}

class _ThermalViewState extends State<ThermalView> {
  double _time = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _time += 0.05;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ThermalPainter(
            controller: widget.controller,
            time: _time,
          ),
        );
      },
    );
  }
}

class _ThermalPainter extends CustomPainter {
  _ThermalPainter({
    required this.controller,
    required this.time,
  });

  static const List<Color> _thermalStops = [
    Color(0xFF000033), // dark blue
    Color(0xFF000080), // navy blue
    Color(0xFF008000), // green
    Color(0xFFFFFF00), // yellow
    Color(0xFFFFA500), // orange
    Color(0xFFFF0000), // red
    Color(0xFFFFFFFF), // white
  ];

  final VideoPlayerController controller;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    if (!controller.value.isInitialized) {
      return;
    }

    // Slowly drift the gradient to give the overlay a "live scanning" feel.
    final double drift = (time * 0.05) % 1.0;

    final Paint paint = Paint()
      ..blendMode = BlendMode.hue
      ..shader = ui.Gradient.linear(
        Offset(0, size.height * drift - size.height),
        Offset(0, size.height * drift + size.height),
        _thermalStops,
        null,
        TileMode.mirror,
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ThermalPainter oldDelegate) {
    return oldDelegate.controller != controller || oldDelegate.time != time;
  }
}
