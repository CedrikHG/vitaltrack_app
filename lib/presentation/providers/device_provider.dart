import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/bluetooth_device_model.dart';
import '../../data/services/mock_iot_service.dart';

class DeviceProvider extends ChangeNotifier {
  final MockIotService _mockService = MockIotService();

  BluetoothDevice? _connectedDevice;
  List<BluetoothDevice> _availableDevices = [];
  bool _isScanning = false;
  bool _isConnecting = false;
  Timer? _scanTimer;

  BluetoothDevice? get connectedDevice => _connectedDevice;
  List<BluetoothDevice> get availableDevices => _availableDevices;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;
  bool get isConnected => _connectedDevice != null;

  Future<void> scanForDevices() async {
    _isScanning = true;
    _availableDevices = [];
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _availableDevices = _mockService.scanForDevices();
    _isScanning = false;
    notifyListeners();
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    _isConnecting = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _connectedDevice = device.copyWith(
      status: DeviceConnectionStatus.connected,
      lastConnected: DateTime.now(),
    );
    _isConnecting = false;
    notifyListeners();

    return true;
  }

  Future<void> disconnectDevice() async {
    if (_connectedDevice != null) {
      _connectedDevice = _connectedDevice!.copyWith(
        status: DeviceConnectionStatus.disconnected,
      );
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      _connectedDevice = null;
      notifyListeners();
    }
  }

  void clearDevices() {
    _availableDevices = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }
}
