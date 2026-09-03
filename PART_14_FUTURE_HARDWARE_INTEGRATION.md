## PART 14 — FUTURE HARDWARE INTEGRATION

### Where to Connect Real ESP32/LoRa/GPS/Sensor Data

The application is designed with a clean separation between UI, data, demo data, and hardware integration. To replace demo data with real hardware data, follow these steps:

#### 1. Communication Layer
- Create a new service (e.g., `lib/services/esp32_lora_service.dart`) that handles communication with ESP32/LoRa hardware.
- This service should:
  - Establish connection (WiFi, Bluetooth, Serial, LoRa, etc.)
  - Parse incoming data (JSON, CSV, custom protocol)
  - Validate and convert data to the appropriate data models
  - Handle connection errors and reconnection logic
  - Run in the background (using isolates or async methods)

#### 2. Repository Pattern
- Replace the mock/demo implementations in the `lib/demo/` directory (or create new repository implementations) with real hardware repositories.
- For example:
  - Create `lib/repositories/esp32_sensor_repository.dart` that implements an abstract `SensorRepository`
  - Create `lib/repositories/lora_gps_repository.dart` that implements an abstract `GpsRepository`
  - Create `lib/repositories/esp32_robot_repository.dart` that implements an abstract `RobotRepository`

#### 3. Abstract Interfaces (Should Already Exist)
- Define abstract interfaces in `lib/repositories/` (if not already created):
  ```dart
  abstract class SensorRepository {
    Future<SensorData> getSensorData();
    Stream<SensorData> sensorDataStream();
  }

  abstract class GpsRepository {
    Future<GpsData> getGpsData();
    Stream<GpsData> gpsDataStream();
  }

  abstract class RobotRepository {
    Future<RobotStatus> getRobotStatus();
    Stream<RobotStatus> robotStatusStream();
  }
  ```

#### 4. State Management (App State)
- Modify `lib/app.dart` (AppState) to use the real repositories instead of demo data when hardware is connected.
- Add a connection status flag and switch between demo and real data sources:
  ```dart
  // In AppState
  SensorRepository _sensorRepository;
  GpsRepository _gpsRepository;
  RobotRepository _robotRepository;

  // Constructor or initializer
  AppState({required SensorRepository sensorRepository, ...}) {
    _sensorRepository = sensorRepository;
    // ... 
    _startListeningToRepositories();
  }

  void _startListeningToRepositories() {
    _sensorRepository.sensorDataStream().listen((sensorData) {
      // Update app state with real data
      _temperature = sensorData.temperature;
      // ... update other fields
      notifyListeners();
    });
    // ... similarly for GPS and robot
  }
  ```

#### 5. Dependency Injection
- When initializing the app (in `main.dart`), provide the appropriate repository implementations based on hardware availability:
  ```dart
  void main() {
    // Determine if hardware is connected (could be via a settings check or detection)
    final useRealHardware = /* check for hardware */ false;

    SensorRepository sensorRepository = useRealHardware
        ? Esp32SensorRepository()
        : MockSensorRepository(); // or use the demo data from AppState's timer

    // Similarly for GPS and robot repositories

    runApp(
      ChangeNotifierProvider(
        create: (_) => AppState(
          sensorRepository: sensorRepository,
          gpsRepository: gpsRepository,
          robotRepository: robotRepository,
        ),
        child: MaterialApp(
          // ... 
        ),
      ),
    );
  }
  ```

#### 6. UI Automatic Updates
- The UI already consumes data from `AppState` via `Provider.of<AppState>(context)`.
- When the repositories update the `AppState` with real data, the UI will rebuild automatically.

#### 7. Files to Modify
- **Create**: `lib/services/esp32_lora_service.dart` (or similar)
- **Create**: `lib/repositories/` with abstract interfaces and real implementations
- **Modify**: `lib/app.dart` to accept repositories and listen to their streams
- **Modify**: `lib/main.dart` to initialize with the correct repositories
- **Optional**: Create a connection service to detect hardware availability

#### 8. Example Data Flow
```
ESP32 Sensor (LoRa/WiFi)
        ↓
[Communication Service] - Parses raw data into Map<String, dynamic>
        ↓
[SensorRepository] - Converts map to SensorData model
        ↓
[AppState] - Receives SensorData via stream and updates its fields
        ↓
[UI] - Rebuilds via Provider, showing new sensor values
```

#### 9. Safety Considerations
- Never block the UI thread with communication logic.
- Use isolates or async/await for long-running operations.
- Handle timeouts and errors gracefully (show disconnected state in UI).
- Validate incoming data ranges to prevent UI glitches.

### Summary of Changes
By following this architecture, you can replace the demo data with real hardware data without changing any UI code. The UI is completely decoupled from the data source.