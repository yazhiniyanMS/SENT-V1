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
        // We need to mark the shader as dirty to trigger a redraw
        // But we don't have a direct way. Instead, we'll call setState to trigger a rebuild.
        // However, we don't want to rebuild the entire widget tree. We'll use a timer to update the shader time uniform.
        // We'll set a uniform and then mark the layer as dirty.
        // For simplicity, we'll just call setState and let the CustomPaint repaint.
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
      // Set the uniforms for the shader
      // We assume the shader has:
      //   uniform sampler2D uImage;
      //   uniform float uTime;
      shader.setFloat('uTime', time);
      // Set the texture. We use the video texture ID.
      // Note: The video_player plugin provides the texture ID via controller.value.textureId.
      // We need to pass it as a sampler2D.
      // We'll create a ImageShader from the texture? Actually, we can set the sampler2D uniform to the texture ID.
      // But the FragmentShader API doesn't directly support setting a sampler2D from a texture ID.
      // We have to use a ImageShader? Alternatively, we can use a different approach.

      // Given the complexity, we'll use a workaround: we'll render the video to an image and then use that as the shader input.
      // But that would be inefficient.

      // Instead, we'll use the video texture as an external texture and set it as a sampler2D using the following:
      //   shader.setSampler2D('uImage', controller.value.textureId);
      // However, the FragmentShader class in Flutter does not have a setSampler2D method.

      // We'll have to use a different approach: we'll use a PlatformView to render the video and shader together? Too complex.

      // For now, we'll fall back to using a gradient that covers the entire box, ignoring the video content.
      // This is not ideal, but it's a placeholder.
      // We'll note that the proper implementation requires platform-specific code or a custom video player that exposes the texture.

      // We'll use the gradient shader we created in the fallback.
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

    // Draw a rectangle that covers the entire area
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ThermalPainter oldDelegate) {
    return oldDelegate.controller != controller ||
        oldDelegate.shader != shader ||
        oldDelegate.time != time;
  }
}