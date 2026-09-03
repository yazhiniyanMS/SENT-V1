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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          SizedBox(
            height: 220,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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