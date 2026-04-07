enum DeviceConnectionStatus { disconnected, scanning, connecting, connected }

class BluetoothDevice {
  final String id;
  final String name;
  final String? deviceId;
  final int? batteryLevel;
  final DeviceConnectionStatus status;
  final DateTime? lastConnected;

  BluetoothDevice({
    required this.id,
    required this.name,
    this.deviceId,
    this.batteryLevel,
    this.status = DeviceConnectionStatus.disconnected,
    this.lastConnected,
  });

  BluetoothDevice copyWith({
    String? id,
    String? name,
    String? deviceId,
    int? batteryLevel,
    DeviceConnectionStatus? status,
    DateTime? lastConnected,
  }) {
    return BluetoothDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      status: status ?? this.status,
      lastConnected: lastConnected ?? this.lastConnected,
    );
  }
}
