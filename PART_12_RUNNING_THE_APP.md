## PART 12 — RUNNING THE APP

### Android Studio Instructions

#### 1. Install Flutter
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install
2. Extract to a desired location (e.g., C:\src\flutter)
3. Add Flutter to your PATH:
   - For Windows: Add `C:\src\flutter\bin` to your system PATH
   - Verify installation: Run `flutter --version` in command prompt

#### 2. Install Android Studio
1. Download Android Studio from https://developer.android.com/studio
2. Install with default options
3. Launch Android Studio and complete the setup wizard
4. Install Android SDK Platform 34 (Android 14)
5. Install Android Virtual Device (if you don't have a physical device)

#### 3. Configure Flutter in Android Studio
1. Open Android Studio
2. Go to File > Settings > Languages & Frameworks > Flutter
3. Set Flutter SDK path to your Flutter installation directory
4. Apply changes

#### 4. Get the Code
1. Ensure all files from this response are placed in the correct directory structure
2. The project root should be `sentinel_x/` with the files as described in PART_1_PROJECT_ARCHITECTURE.md

#### 5. Get Dependencies
1. Open the project in Android Studio (File > Open > select sentinel_x folder)
2. Wait for Gradle sync to complete
3. Open Terminal in Android Studio (View > Tool Windows > Terminal)
4. Run: `flutter pub get`
5. Wait for dependencies to download

#### 6. Connect Android Device
**Option A: Physical Device**
1. Enable Developer Options on your Android phone:
   - Go to Settings > About phone
   - Tap "Build number" 7 times
2. Go back to Settings > System > Developer options
3. Enable "USB debugging"
4. Connect phone to PC via USB cable
5. When prompted on phone, allow USB debugging

**Option B: Emulator**
1. In Android Studio, go to Device Manager (View > Tool Windows > Device Manager)
2. Click "+" to create a new virtual device
3. Choose a phone definition (e.g., Pixel 5)
4. Download a system image (e.g., Tiramisu API 34)
5. Complete the setup and start the emulator

#### 7. Run the Application
1. In Android Studio, select your device from the dropdown menu
2. Click the "Run" button (green triangle) or press Shift+F10
3. Wait for the app to build and install on the device/emulator
4. The app should launch automatically

#### 8. Troubleshooting
**Common Issues:**
- **"Flutter devices not found"**: Run `flutter doctor` to diagnose issues
- **Gradle sync failed**: Try File > Invalidate Caches and Restart
- **App crashes on launch**: Check Logcat (View > Tool Windows > Logcat) for error details
- **Video not playing**: Ensure the video asset exists at `assets/videos/sentinel_demo.mp4`
- **Shader errors**: Check debug console for shader compilation messages

**Command Line Alternative:**
```bash
# Navigate to project directory
cd sentinel_x

# Get dependencies
flutter pub get

# List connected devices
flutter devices

# Run on selected device
flutter run

# Or specify device
flutter run -d <device-id>
```

### First Launch Experience
When the app starts:
1. You'll see the SENTINEL-X banner with "AI-POWERED DISASTER RESPONSE SYSTEM"
2. The LIVE CAMERA card will show the demo video (or loading indicator)
3. Sensor cards will show demo values that update every 2 seconds
4. The connection indicator will show "DEMO MODE"
5. All navigation tabs (Dashboard, Sensors, Alerts, Map, Settings) are functional

### Demo Mode Indicators
Look for these indicators that confirm you're in demo mode:
- "DEMO MODE" badge in the header
- "DEMO DATA" labels on sensor cards
- "DEMO LOCATION" on GPS cards
- "DEMO TELEMETRY" on robot status cards
- "Thermal camera hardware not connected" under thermal view toggle