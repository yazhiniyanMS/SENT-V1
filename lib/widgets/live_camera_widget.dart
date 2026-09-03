import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:sentinel_x/theme/app_theme.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

class LiveCameraWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isThermalView;
  final VoidCallback onThermalToggle;

  const LiveCameraWidget({
    super.key,
    required this.controller,
    required this.isThermalView,
    required this.onThermalToggle,
  });

  @override
  State<LiveCameraWidget> createState() => _LiveCameraWidgetState();
}

class _LiveCameraWidgetState extends State<LiveCameraWidget> {
  ui.FragmentProgram? _thermalProgram;
  bool _isShaderLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadThermalShader();
  }

  Future<void> _loadThermalShader() async {
    try {
      final String fragmentShader = await rootBundle.loadString(
        'lib/shaders/thermal_fragment.glsl',
      );
      _thermalProgram = ui.FragmentProgram(fragmentShader);
      if (mounted) {
        setState(() {
          _isShaderLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Failed to load thermal shader: $e');
      // Fall back to simpler approach if shader fails
      if (mounted) {
        setState(() {
          _isShaderLoaded = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.accentColor,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          SizedBox.expand(
            child: widget.isThermalView && _isShaderLoaded && _thermalProgram != null
                ? _buildThermalVideo()
                : VideoPlayer(widget.controller),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isThermalView
                      ? AppTheme.thermalHottest.withOpacity(0.7)
                      : Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wb_sunny_outlined,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.isThermalView ? 'THERMAL' : 'NORMAL',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              'SIMULATED THERMAL VIEW\nThermal camera hardware not connected',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white70,
                height: 1.2,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              onPressed: widget.onThermalToggle,
              icon: Icon(
                widget.isThermalView
                    ? Icons.wb_sunny_outlined
                    : Icons.ac_unit,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThermalVideo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: ThermalVideoPainter(
            videoTextureId: widget.controller.value.textureId,
            thermalProgram: _thermalProgram!,
            videoSize: Size(
              widget.controller.value.size.width,
              widget.controller.value.size.height,
            ),
          ),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
      },
    );
  }

  @override
  void dispose() {
    _thermalProgram?.dispose();
    super.dispose();
  }
}

class ThermalVideoPainter extends CustomPainter {
  final int videoTextureId;
  final ui.FragmentProgram thermalProgram;
  final Size videoSize;

  ThermalVideoPainter({
    required this.videoTextureId,
    required this.thermalProgram,
    required this.videoSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (videoTextureId == 0) {
      // Draw placeholder if no video
      final paint = Paint()..color = Colors.grey[800]!;
      canvas.drawRect(Offset.zero & size, paint);
      return;
    }

    // Save layer for shader application
    final layer = canvas.saveLayer(Offset.zero & size, Paint());

    // Draw video texture
    if (videoSize.width > 0 && videoSize.height > 0) {
      final dstRect = Offset.zero & size;
      final srcRect = Offset.zero & videoSize;

      canvas.drawVideoTexture(
        videoTextureId,
        srcRect,
        dstRect,
        Paint()..blendMode = BlendMode.src,
      );
    }

    // Apply thermal shader
    final paint = Paint()
      ..shader = thermalProgram.asFragmentShader()
      ..blendMode = BlendMode.modulate; // This applies the shader effect

    canvas.drawRect(Offset.zero & size, paint);
    canvas.restoreLayer(layer);
  }

  @override
  bool shouldRepaint(covariant ThermalVideoPainter oldDelegate) =>
      oldDelegate.videoTextureId != videoTextureId ||
      oldDelegate.videoSize != videoSize;
}