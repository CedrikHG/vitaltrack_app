import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/device_provider.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceProvider>().scanForDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conectar Dispositivo')),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBluetoothStatus(deviceProvider),
                const SizedBox(height: 24),
                if (deviceProvider.isConnected)
                  _buildConnectedDevice(deviceProvider)
                else
                  _buildAvailableDevices(deviceProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBluetoothStatus(DeviceProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              provider.isConnected
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_searching,
              size: 64,
              color: provider.isConnected
                  ? AppTheme.primaryColor
                  : AppTheme.textDisabled,
            ),
            const SizedBox(height: 16),
            Text(
              provider.isConnected
                  ? 'Dispositivo Conectado'
                  : 'Buscando dispositivos...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              provider.isConnected
                  ? 'Tu VitalBand está listo para usar'
                  : 'Asegúrate de que tu dispositivo esté cerca',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedDevice(DeviceProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dispositivo Vinculado',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.watch, color: AppTheme.successColor),
            title: Text(provider.connectedDevice?.name ?? 'Dispositivo'),
            subtitle: Text('ID: ${provider.connectedDevice?.deviceId ?? ""}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${provider.connectedDevice?.batteryLevel ?? 0}%',
                  style: const TextStyle(color: AppTheme.successColor),
                ),
                const Icon(
                  Icons.battery_full,
                  color: AppTheme.successColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Desvincular Dispositivo'),
                content: const Text(
                  '¿Seguro que deseas desvincular este dispositivo?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Desvincular'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              await provider.disconnectDevice();
            }
          },
          icon: const Icon(Icons.link_off),
          label: const Text('Desvincular Dispositivo'),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
        ),
      ],
    );
  }

  Widget _buildAvailableDevices(DeviceProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dispositivos Disponibles',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: provider.isScanning
                  ? null
                  : () => provider.scanForDevices(),
              icon: provider.isScanning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(provider.isScanning ? 'Buscando...' : 'Buscar'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (provider.isScanning)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else if (provider.availableDevices.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('No se encontraron dispositivos')),
            ),
          )
        else
          ...provider.availableDevices.map(
            (device) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.watch, color: AppTheme.primaryColor),
                title: Text(device.name),
                subtitle: Text('ID: ${device.deviceId ?? device.id}'),
                trailing: provider.isConnecting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : OutlinedButton(
                        onPressed: () async {
                          await provider.connectToDevice(device);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Conectado a ${device.name}'),
                              ),
                            );
                          }
                        },
                        child: const Text('Conectar'),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
