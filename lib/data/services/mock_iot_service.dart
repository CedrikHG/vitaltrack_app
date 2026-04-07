import 'dart:math';
import '../models/vital_sign_model.dart';
import '../models/bluetooth_device_model.dart';

class MockIotService {
  final Random _random = Random();

  static final MockIotService _instance = MockIotService._internal();
  factory MockIotService() => _instance;
  MockIotService._internal();

  VitalSign generateHeartRate() {
    final baseValue = 70 + _random.nextInt(20);
    final variation = _random.nextDouble() * 10 - 5;
    final value = (baseValue + variation).clamp(40.0, 180.0);

    return VitalSign(
      id: 'hr_${DateTime.now().millisecondsSinceEpoch}',
      type: VitalType.heartRate,
      value: value,
      timestamp: DateTime.now(),
      isSimulated: true,
    );
  }

  VitalSign generateBloodPressure() {
    final systolicBase = 110 + _random.nextInt(20);
    final systolicVariation = _random.nextDouble() * 10 - 5;
    final systolic = (systolicBase + systolicVariation)
        .clamp(90.0, 180.0)
        .toDouble();

    final diastolicBase = 70 + _random.nextInt(15);
    final diastolicVariation = _random.nextDouble() * 8 - 4;
    final diastolic = (diastolicBase + diastolicVariation)
        .clamp(60.0, 120.0)
        .toDouble();

    return VitalSign(
      id: 'bp_${DateTime.now().millisecondsSinceEpoch}',
      type: VitalType.bloodPressure,
      value: systolic,
      secondaryValue: diastolic,
      timestamp: DateTime.now(),
      isSimulated: true,
    );
  }

  VitalSign generateSpO2() {
    final baseValue = 97 + _random.nextInt(3);
    final variation = _random.nextDouble() * 2 - 1;
    final value = (baseValue + variation).clamp(90.0, 100.0);

    return VitalSign(
      id: 'spo2_${DateTime.now().millisecondsSinceEpoch}',
      type: VitalType.spo2,
      value: value,
      timestamp: DateTime.now(),
      isSimulated: true,
    );
  }

  VitalSign generateSleepData() {
    final hours = [5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5][_random.nextInt(7)];
    final minutes = _random.nextInt(60);
    final value = hours + (minutes / 60.0);

    return VitalSign(
      id: 'sleep_${DateTime.now().millisecondsSinceEpoch}',
      type: VitalType.sleep,
      value: value.clamp(0.0, 12.0),
      timestamp: DateTime.now(),
      isSimulated: true,
    );
  }

  VitalSign generateExerciseData() {
    final value = (_random.nextDouble() * 120).clamp(0.0, 180.0);

    return VitalSign(
      id: 'exercise_${DateTime.now().millisecondsSinceEpoch}',
      type: VitalType.exercise,
      value: value,
      timestamp: DateTime.now(),
      isSimulated: true,
    );
  }

  List<VitalSign> generateHistoricalData(VitalType type, int days) {
    final List<VitalSign> data = [];
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));

      for (int hour = 0; hour < 24; hour += 4) {
        final timestamp = DateTime(date.year, date.month, date.day, hour);
        VitalSign? vital;

        switch (type) {
          case VitalType.heartRate:
            vital = VitalSign(
              id: 'hr_hist_${timestamp.millisecondsSinceEpoch}',
              type: type,
              value: (65 + _random.nextInt(25) + _random.nextDouble() * 10 - 5)
                  .clamp(40.0, 180.0),
              timestamp: timestamp,
              isSimulated: true,
            );
            break;
          case VitalType.bloodPressure:
            vital = VitalSign(
              id: 'bp_hist_${timestamp.millisecondsSinceEpoch}',
              type: type,
              value: (100 + _random.nextInt(40) + _random.nextDouble() * 10 - 5)
                  .clamp(90.0, 180.0),
              secondaryValue:
                  (60 + _random.nextInt(30) + _random.nextDouble() * 8 - 4)
                      .clamp(60.0, 120.0),
              timestamp: timestamp,
              isSimulated: true,
            );
            break;
          case VitalType.spo2:
            vital = VitalSign(
              id: 'spo2_hist_${timestamp.millisecondsSinceEpoch}',
              type: type,
              value: (95 + _random.nextInt(5) + _random.nextDouble() * 2 - 1)
                  .clamp(90.0, 100.0),
              timestamp: timestamp,
              isSimulated: true,
            );
            break;
          case VitalType.sleep:
            if (hour == 0) {
              vital = VitalSign(
                id: 'sleep_hist_${timestamp.millisecondsSinceEpoch}',
                type: type,
                value: (5.0 + _random.nextDouble() * 4).clamp(0.0, 12.0),
                timestamp: timestamp,
                isSimulated: true,
              );
            }
            break;
          case VitalType.exercise:
            vital = VitalSign(
              id: 'exercise_hist_${timestamp.millisecondsSinceEpoch}',
              type: type,
              value: (_random.nextDouble() * 150).clamp(0.0, 180.0),
              timestamp: timestamp,
              isSimulated: true,
            );
            break;
        }

        if (vital != null) {
          data.add(vital);
        }
      }
    }

    data.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return data;
  }

  List<BluetoothDevice> scanForDevices() {
    final devices = [
      BluetoothDevice(
        id: 'device_1',
        name: 'VitalBand Pro',
        deviceId: 'VB-2024-001',
        batteryLevel: 85,
        status: DeviceConnectionStatus.disconnected,
      ),
      BluetoothDevice(
        id: 'device_2',
        name: 'VitalBand Lite',
        deviceId: 'VB-2024-002',
        batteryLevel: 62,
        status: DeviceConnectionStatus.disconnected,
      ),
      BluetoothDevice(
        id: 'device_3',
        name: 'HealthWatch X',
        deviceId: 'HW-2024-001',
        batteryLevel: 45,
        status: DeviceConnectionStatus.disconnected,
      ),
    ];
    return devices;
  }
}
