## PART 5 — CAMERA SYSTEM

### lib/widgets/live_camera_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:sentinel_x/app.dart';
import 'package:sentinel_x/widgets/thermal_view.dart';

class LiveCameraCard extends StatefulWidget {
  const LiveCameraCard({Key? key}) : super(key: key);

  @override
  State<LiveCameraCard> createState() => _LiveCameraCardState();
}

class _LiveCameraCardState extends State<LiveCameraCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    _controller = VideoPlayerController.asset('assets/videos/sentinel_demo.mp4');
    _controller.addListener(() {
      if (_controller.value.hasError) {
        setState(() {
          _hasError = true;
        });
      }
    });
    try {
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool thermalEnabled =
        Provider.of<AppState>(context, listen: false).thermalSimulationEnabled;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisSpaceBetween,
              children: [
                const Text(
                  'LIVE CAMERA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: thermalEnabled,
                  onChanged: (value) {
                    Provider.of<AppState>(context, listen: false)
                        .setThermalSimulationEnabled(value);
                  },
                  activeColor: Colors.orange,
                ),
              ],
            ),
          ),
          // Video or placeholder
          Expanded(
            child: _hasError
                ? const Center(
                    child: Text(
                      'CAMERA SOURCE UNAVAILABLE\nUsing DEMO FALLBACK',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  )
                : !_isInitialized
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          VideoPlayer(_controller),
                          if (thermalEnabled)
                            ThermalView(
                              controller: _controller,
                            ),
                        ],
                      ),
          ),
          // Footer with labels
          if (thermalEnabled)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisSpaceBetween,
                children: [
                  Text(
                    'SIMULATED THERMAL VIEW',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    'Thermal camera hardware not connected',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

### lib/widgets/thermal_view.dart
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  ui.FragmentShader? _shader;
  bool _shaderInitialized = false;
  double _time = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeShader();
    _startTimer();
  }

  Future<void> _initializeShader() async {
    try {
      final manifestByteData = await DefaultAssetBundle.of(context)
          .load('assets/shaders/thermal.frag');
      final String shaderCode =
          manifestByteData.buffer.asUint8List().decodeUtf8();
      final Shader shader = await ui.FragmentProgram.fromSource(shaderCode)
          .then((program) => ui.FragmentShader(program));
      setState(() {
        _shader = shader;
        _shaderInitialized = true;
      });
    } catch (e) {
      debugPrint('Failed to load thermal shader: $e');
      // Fallback to a simple gradient if shader fails
      setState(() {
        _shaderInitialized = true;
        // We'll use a fallback shader (a simple gradient)
        _shader = ui.Gradient.linear(
          const Offset(0, 0),
          const Offset(0, 256),
          [
            const Color(0xFF000032), // dark blue
            const Color(0xFF000080), // navy blue
            const Color(0xFF008000), // green
            const Color(0xFFFFFFFF0), // yellow
            const Color(0xFFFFA500), // orange
            const Color(0xFFFF0000), // red
            const Color(0xFFFFFFFF), // white
          ],
        ).toShader();
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _time += 0.016;
      if (_shader != null) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shaderInitialized) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: CustomPaint(
            painter: _ThermalPainter(
              controller: widget.controller,
              shader: _shader,
              time: _time,
            ),
            child: VideoPlayer(widget.controller),
          ),
        );
      },
    );
  }
}

class _ThermalPainter extends CustomPainter {
  _ThermalPainter({
    required this.controller,
    this.shader,
    required this.time,
  });

  final VideoPlayerController controller;
  final ui.FragmentShader? shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    if (!controller.value.isInitialized) {
      return;
    }

    final Paint paint = Paint();
    if (shader != null) {
      paint.shader = shader;
    } else {
      // Fallback to a gradient
      paint.shader = ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(0, size.height),
        [
          const Color(0xFF000032),
          const Color(0xFF000080),
          const Color(0xFF008000),
          const Color(0xFFFFFFFF0),
          const Color(0xFFFFA500),
          const Color(0xFFFF0000),
          const Color(0xFFFFFFFF),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ThermalPainter oldDelegate) {
    return oldDelegate.controller != controller ||
        oldDelegate.shader != shader ||
        oldDelegate.time != time;
  }
}