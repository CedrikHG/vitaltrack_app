import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/vital_sign_model.dart';
import '../../data/services/mock_iot_service.dart';

class VitalsProvider extends ChangeNotifier {
  final MockIotService _mockService = MockIotService();

  VitalSign? _heartRate;
  VitalSign? _bloodPressure;
  VitalSign? _spo2;
  VitalSign? _sleep;
  VitalSign? _exercise;

  List<VitalSign> _heartRateHistory = [];
  List<VitalSign> _bloodPressureHistory = [];
  List<VitalSign> _spo2History = [];
  List<VitalSign> _sleepHistory = [];
  List<VitalSign> _exerciseHistory = [];

  bool _isMeasuring = false;
  Timer? _measurementTimer;

  VitalSign? get heartRate => _heartRate;
  VitalSign? get bloodPressure => _bloodPressure;
  VitalSign? get spo2 => _spo2;
  VitalSign? get sleep => _sleep;
  VitalSign? get exercise => _exercise;

  List<VitalSign> get heartRateHistory => _heartRateHistory;
  List<VitalSign> get bloodPressureHistory => _bloodPressureHistory;
  List<VitalSign> get spo2History => _spo2History;
  List<VitalSign> get sleepHistory => _sleepHistory;
  List<VitalSign> get exerciseHistory => _exerciseHistory;

  bool get isMeasuring => _isMeasuring;

  void loadInitialData() {
    _heartRate = _mockService.generateHeartRate();
    _bloodPressure = _mockService.generateBloodPressure();
    _spo2 = _mockService.generateSpO2();
    _sleep = _mockService.generateSleepData();
    _exercise = _mockService.generateExerciseData();

    _heartRateHistory = _mockService.generateHistoricalData(
      VitalType.heartRate,
      7,
    );
    _bloodPressureHistory = _mockService.generateHistoricalData(
      VitalType.bloodPressure,
      7,
    );
    _spo2History = _mockService.generateHistoricalData(VitalType.spo2, 7);
    _sleepHistory = _mockService.generateHistoricalData(VitalType.sleep, 7);
    _exerciseHistory = _mockService.generateHistoricalData(
      VitalType.exercise,
      7,
    );

    notifyListeners();
  }

  Future<void> startMeasurement(VitalType type) async {
    _isMeasuring = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));

    switch (type) {
      case VitalType.heartRate:
        _heartRate = _mockService.generateHeartRate();
        break;
      case VitalType.bloodPressure:
        _bloodPressure = _mockService.generateBloodPressure();
        break;
      case VitalType.spo2:
        _spo2 = _mockService.generateSpO2();
        break;
      case VitalType.sleep:
        _sleep = _mockService.generateSleepData();
        break;
      case VitalType.exercise:
        _exercise = _mockService.generateExerciseData();
        break;
    }

    _isMeasuring = false;
    notifyListeners();
  }

  void refreshData() {
    loadInitialData();
  }

  List<VitalSign> getHistoricalData(VitalType type, int days) {
    return _mockService.generateHistoricalData(type, days);
  }

  @override
  void dispose() {
    _measurementTimer?.cancel();
    super.dispose();
  }
}
