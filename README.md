# SENTINEL-X - AI-Powered Robotics for Safer Disaster Response

A professional Android monitoring/dashboard application for disaster response robotics.

## Project Overview

SENTINEL-X is a Flutter-based Android application designed to monitor and display sensor data from disaster response robots. The app serves as a command dashboard showing live camera feeds (with simulated thermal visualization), sensor readings, GPS tracking, robot status, and emergency alerts.

**Important**: This application is ONLY a monitoring/dashboard application. It does NOT contain any robot movement controls, joystick controls, or motor control interfaces. The physical robot is controlled separately using an RC transmitter and Arduino UNOs.

## Features

- **Live Camera Feed**: Displays video from ESP32-CAM or demo video
- **Simulated Thermal View**: Software-based thermal visualization applied to video feed
- **Sensor Monitoring**: Gas detection, temperature, humidity, water detection
- **GPS Tracking**: Robot location and tracking information
- **Robot Status**: Battery, signal strength, speed, operation mode
- **Emergency Alert System**: SOS button for reporting emergencies
- **Multi-tab Navigation**: Dashboard, Sensors, Alerts, Map, Settings
- **Professional Dark UI**: Futuristic disaster-response theme with emergency color accents

## Project Structure

```
sentinel_x/
├── android/                  # Android project files
├── assets/
│   ├── videos/               # Place demo videos here (demo_disaster.mp4)
│   ├── images/               # Icons and images
│   └── icons/                # App icons
├── build/                    # Build outputs
├── lib/
│   ├── main.dart             # App entry point
│   ├── models/               # Data models (SensorData, etc.)
│   ├── screens/              # App screens (Dashboard, Sensors, etc.)
│   ├── widgets/              # Reusable UI components
│   └── theme/                # App theming and colors
├── test/                     # Test files
├── pubspec.yaml              # Flutter dependencies
└── README.md                 # This file
```

## Setup Instructions

### 1. Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0.0 or later)
- Android Studio with Android SDK
- A physical Android device or emulator for testing

### 2. Getting the Code

If you haven't already, create the project structure:

```bash
# The project files should already be created in your sentinel_x directory
# If starting from scratch:
flutter create sentinel_x
cd sentinel_x
```

Then copy all the Dart files and pubspec.yaml from this response into the appropriate locations.

### 3. Adding Assets

#### Demo Video
1. Place your demo disaster/building-rubble video in: `assets/videos/demo_disaster.mp4`
2. Supported formats: MP4, MOV, etc. (formats supported by video_player plugin)
3. For best performance, use a video with moderate resolution (720p or lower)

#### Other Assets
- Place any additional images/icons in `assets/images/` and `assets/icons/`
- Update `pubspec.yaml` if you add new asset directories

### 4. Dependencies

The project uses these key packages:
- `video_player`: For video playback
- `flutter_animate`: For UI animations
- `google_maps_flutter`: For map display (placeholder implementation)

Run `flutter pub get` to install dependencies.

### 5. Running the Application

#### In Android Studio:
1. Open the `sentinel_x` folder in Android Studio
2. Wait for Gradle sync to complete
3. Connect an Android device or start an emulator
4. Click the Run button

#### From Command Line:
```bash
cd sentinel_x
flutter pub get
flutter run
```

### 6. Building the APK

To generate a release APK:
```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

### 7. Architecture Notes for Future Development

#### Replacing Demo Data with Real ESP32/LoRa Data
All mock data is centralized in:
- `lib/models/sensor_data.dart` - SensorData class with `.demo()` factory method
- Replace the `.demo()` method with real data from your connection layer
- Create a service/class that handles ESP32/LoRa communication and updates the SensorData

#### Replacing Simulated Thermal View with Real MLX90640 Data
The thermal simulation is implemented in:
- `lib/widgets/live_camera_widget.dart` - LiveCameraWidget and ThermalPainter classes
- To replace with real thermal data:
  1. Modify the video processing pipeline to accept thermal data
  2. Replace the ThermalPainter with actual thermal image rendering
  3. Update the UI to remove "SIMULATED THERMAL VIEW" labels when real thermal data is active

#### Video Source Replacement
Currently using asset video: `assets/videos/demo_disaster.mp4`
To replace with ESP32-CAM stream:
1. In `dashboard_screen.dart`, change the VideoPlayerController initialization
2. Replace the asset URL with your ESP32-CAM stream URL (MJPEG, RTSP, or HTTP stream)
3. Add appropriate networking permissions to `android/app/src/main/AndroidManifest.xml`

### 8. Important Safety Notes

⚠️ **THERMAL VISUALIZATION DISCLAIMER**: 
The thermal effect in this application is purely software-simulated for demonstration purposes. It does NOT represent actual temperature measurements and should never be used for:
- Measuring human body temperature
- Detecting survivors in disaster situations
- Any safety-critical thermal measurements

The application clearly labels this as "SIMULATED THERMAL VIEW" and includes disclaimers about the lack of actual thermal camera hardware.

## Customization

### Colors and Theme
Modify `lib/theme/app_theme.dart` to adjust:
- Primary/secondary colors
- Accent colors (emergency reds/oranges)
- Safe/warning/danger indicators
- Thermal color palette

### Animations
Adjust animation parameters in widget implementations or use the `flutter_animate` package properties.

### Localization
All text is currently in English. For multilingual support, extract strings to ARB files.

## Troubleshooting

### Video Not Playing
- Ensure the demo video exists at `assets/videos/demo_disaster.mp4`
- Check that the video format is supported by the video_player plugin
- Verify assets are correctly referenced in pubspec.yaml

### Performance Issues
- Lower the demo video resolution if experiencing lag
- The thermal simulation uses a simplified implementation - for better performance on older devices, consider reducing the complexity

### Build Errors
- Run `flutter clean` followed by `flutter pub get`
- Ensure Flutter and Android SDK versions are compatible
- Check for missing dependencies in pubspec.yaml

## License

This project is created for the VIT EXPO disaster response robotics project.

---

**Remember**: This application is a monitoring dashboard only. Robot control is handled separately via RC transmitter and Arduino UNOs as specified in your requirements.