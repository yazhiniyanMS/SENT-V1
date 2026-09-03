## PART 11 — ASSETS

### Asset Structure
```
assets/
├── videos/
│   └── sentinel_demo.mp4        # Demo video for live camera
├── shaders/
│   └── thermal.frag             # Fragment shader for thermal simulation
├── images/                      # Placeholder for images (icons, logos, etc.)
└── icons/                       # Placeholder for icon assets
```

### How to Add Assets

#### 1. Demo Video
1. Obtain a royalty-free disaster/building-rubble video or create a simple demonstration video
2. Recommended format: MP4 with H.264 encoding
3. Recommended specifications:
   - Resolution: 720x480 or lower (for better performance on mobile)
   - Duration: 10-30 seconds (will loop continuously)
   - Content: Indoor/outdoor disaster scene, rubble, smoke (optional)
4. Place the file at: `assets/videos/sentinel_demo.mp4`
5. The asset is already declared in `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/videos/sentinel_demo.mp4
       - assets/shaders/thermal.frag
       - assets/icons/
       - assets/images/
   ```

#### 2. Thermal Shader
1. The shader file `assets/shaders/thermal.frag` is already provided
2. It implements a thermal color mapping algorithm that converts luminance to a thermal palette
3. No additional steps needed

#### 3. Icons and Images
1. Place any custom icons in `assets/icons/`
2. Place any images (logos, etc.) in `assets/images/`
3. These directories are already declared in `pubspec.yaml`

### Fallback Handling
The application includes fallback states for missing assets:

#### Video Fallback
If `assets/videos/sentinel_demo.mp4` is missing or fails to load:
- The LiveCameraCard displays an error message: "CAMERA SOURCE UNAVAILABLE\nUsing DEMO FALLBACK"
- The application continues to function without video
- All other features (sensors, alerts, map, etc.) remain operational

#### Shader Fallback
If `assets/shaders/thermal.frag` fails to load or compile:
- The ThermalView falls back to a linear gradient approximation of the thermal color palette
- The thermal simulation will still work, though with slightly different colors
- A debug message is printed to the console: "Failed to load thermal shader: [error]"

### Asset Usage in Code

#### Video Player
```dart
VideoPlayerController.asset('assets/videos/sentinel_demo.mp4')
```

#### Shader Loading
```dart
final manifestByteData = await DefaultAssetBundle.of(context)
    .load('assets/shaders/thermal.frag');
final String shaderCode =
    manifestByteData.buffer.asUint8List().decodeUtf8();
```

### Recommended Video Sources
For demo purposes, you can use:
1. **Pexels** (https://www.pexels.com/) - Search for "disaster", "rubble", "fire scene"
2. **Pixabay** (https://pixabay.com/) - Similar search terms
3. **Videvo** (https://www.videvo.net/) - Free stock video
4. Create your own simple video using a smartphone camera

Ensure the video is royalty-free and suitable for public demonstration.

### Asset Optimization
For better performance:
1. Compress the video using tools like HandBrake
2. Use baseline profile for H.264 for better compatibility
3. Keep keyframe frequency high (every 1-2 seconds) for better seeking
4. Consider using MP4 rather than MOV for better Android compatibility