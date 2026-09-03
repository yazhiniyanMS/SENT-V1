## PART 15 — FUTURE MLX90640 INTEGRATION

### Where to Replace the Thermal Simulation

The current thermal simulation is a software-based effect applied to the video frame. To replace it with real MLX90640 thermal data, follow these steps:

#### 1. Abstract Thermal Data Source
- Define an abstract interface for thermal data in `lib/services/thermal/`:
  ```dart
  abstract class ThermalDataSource {
    Future<Uint8List?> getThermalImage(); // Returns a thermal image (e.g., 8x8 or 16x16 array) or null if unavailable
    Stream<Uint8List?> thermalImageStream();
    Size getResolution(); // e.g., Size(8, 8) for MLX90640
  }
  ```

#### 2. Implementations
- **Demo/Simulation**: `lib/services/thermal/simulated_thermal_source.dart`
  - Uses the current video frame and applies the shader to simulate thermal view.
  - This is what is currently used in `ThermalView`.
- **Real MLX90640**: `lib/services/thermal/mlx90640_thermal_source.dart`
  - Connects to MLX90640 sensor (via I2C, SPI, or through ESP32).
  - Reads the thermal matrix and converts it to a thermal image (uint8 list) that can be displayed.
  - May require scaling/interpolation to match video resolution.

#### 3. Thermal Rendering Widget
- Modify `lib/widgets/thermal_view.dart` to accept a `ThermalDataSource` instead of just a video controller.
- The widget will:
  - Use the video controller for the base image (if available) or generate a placeholder.
  - Overlay the thermal data from the source onto the video.
  - For real MLX90640 data, the thermal image might be low resolution (e.g., 8x8) and need to be upscaled and color-mapped to overlay on the video.

#### 4. Two Approaches for Integration
**Approach A: Replace Video with Thermal Image (Not Recommended for This UI)**
- If the MLX90640 provides a complete thermal image that should replace the video, then:
  - The `LiveCameraCard` would switch between video and thermal image sources.
  - This would lose the contextual video background.

**Approach B: Overlay Thermal Data on Video (Recommended)**
- Keep the video as the background and overlay the thermal data as a semi-transparent layer.
- Steps in `ThermalView`:
  1. Render the video frame (from `VideoPlayerController`).
  2. Fetch the latest thermal data from `ThermalDataSource`.
  3. Upscale the thermal data to match video resolution (using interpolation like bilinear).
  4. Apply a thermal color map to the upscaled thermal data.
  5. Blend the colored thermal image over the video frame with some opacity.
  6. Output the final image.

#### 5. Modifying ThermalView
- Change the constructor of `ThermalView` to accept a `ThermalDataSource`.
- In `_ThermalViewState`:
  - Initialize the thermal data source.
  - Listen to its stream for updates.
  - In the `paint` method of `_ThermalPainter`:
      a. Draw the video texture (if available) as the base.
      b. Draw the thermal overlay on top.

#### 6. Example Implementation Sketch
```dart
// In lib/widgets/thermal_view.dart
class ThermalView extends StatefulWidget {
  final VideoPlayerController videoController;
  final ThermalDataSource thermalSource;

  const ThermalView({
    Key? key,
    required this.videoController,
    required this.thermalSource,
  }) : super(key: key);
}

// In _ThermalViewState:
  @override
  void initState() {
    super.initState();
    _thermalSource.thermalImageStream().listen((thermalImage) {
      setState(() {
        _latestThermalImage = thermalImage;
      });
    });
  }

// In _ThermalPainter.paint:
  if (controller.value.isInitialized) {
    // Draw video
    final videoRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawTexture(controller.value.textureId, videoRect, paint);
  }

  // Draw thermal overlay if available
  if (_latestThermalImage != null) {
    // TODO: Upscale _latestThermalImage to video size, apply color map, and draw with blend mode
    // For simplicity, we'll draw a placeholder rect
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.3);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }
```

#### 7. Files to Modify/Create
- **Create**: `lib/services/thermal/thermal_data_source.dart` (abstract interface)
- **Create**: `lib/services/thermal/simulated_thermal_source.dart` (current simulation adapted)
- **Create**: `lib/services/thermal/mlx90640_thermal_source.dart` (real implementation)
- **Modify**: `lib/widgets/thermal_view.dart` to accept and use `ThermalDataSource`
- **Modify**: `lib/widgets/live_camera_card.dart` to pass the thermal source to `ThermalView`
- **Modify**: `lib/app.dart` to provide the thermal data source (based on demo/real toggle)
- **Modify**: `lib/screens/settings_screen.dart` to allow selecting thermal data source (simulated vs MLX90640)

#### 8. Data Flow for Real MLX90640
```
MLX90640 Sensor (I2C via ESP32 or direct)
        ↓
[MLX90640 Driver] - Reads raw thermal matrix, applies compensation
        ↓
[MLX90640ThermalSource] - Converts matrix to Uint8List thermal image (or scaled version)
        ↓
[AppState/ThermalView] - Receives thermal image stream
        ↓
[ThermalView] - Overlays thermal image on video feed with color mapping
        ↓
[UI] - Shows video with thermal overlay
```

#### 9. Handling Missing Hardware
- If MLX90640 is not connected, fall back to the simulated thermal source (which uses the video frame).
- The UI should indicate when real thermal data is active vs. simulated.

#### 10. Performance Considerations
- Thermal data from MLX90640 is low frequency (e.g., 4-16 Hz), so upscaling and blending must be efficient.
- Use `ui.Image` shaders or `Canvas.drawImageRect` with proper filtering.
- Consider using a shader that combines video and thermal data in one pass for best performance.

### Summary of Changes
By abstracting the thermal data source, you can switch between simulated thermal (based on video) and real MLX90640 data without changing the UI rendering logic. The `ThermalView` widget becomes agnostic to the source of the thermal data.