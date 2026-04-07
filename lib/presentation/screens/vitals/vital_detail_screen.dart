import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/vital_sign_model.dart';
import '../../../data/services/mock_iot_service.dart';
import '../../providers/vitals_provider.dart';

class VitalDetailScreen extends StatefulWidget {
  final VitalType vitalType;

  const VitalDetailScreen({super.key, required this.vitalType});

  @override
  State<VitalDetailScreen> createState() => _VitalDetailScreenState();
}

class _VitalDetailScreenState extends State<VitalDetailScreen> {
  String _selectedPeriod = 'Semana';
  final List<String> _periods = ['Día', 'Semana', 'Mes', 'Año'];
  List<VitalSign> _historicalData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final days = _selectedPeriod == 'Día'
        ? 1
        : _selectedPeriod == 'Semana'
        ? 7
        : _selectedPeriod == 'Mes'
        ? 30
        : 365;
    setState(() {
      _historicalData = MockIotService().generateHistoricalData(
        widget.vitalType,
        days,
      );
    });
  }

  String get _title {
    switch (widget.vitalType) {
      case VitalType.heartRate:
        return 'Frecuencia Cardíaca';
      case VitalType.bloodPressure:
        return 'Presión Arterial';
      case VitalType.spo2:
        return 'SpO2';
      case VitalType.sleep:
        return 'Sueño';
      case VitalType.exercise:
        return 'Ejercicio';
    }
  }

  IconData get _icon {
    switch (widget.vitalType) {
      case VitalType.heartRate:
        return Icons.favorite;
      case VitalType.bloodPressure:
        return Icons.speed;
      case VitalType.spo2:
        return Icons.air;
      case VitalType.sleep:
        return Icons.bedtime;
      case VitalType.exercise:
        return Icons.directions_run;
    }
  }

  Color get _color {
    switch (widget.vitalType) {
      case VitalType.heartRate:
        return AppTheme.heartColor;
      case VitalType.bloodPressure:
        return AppTheme.bloodPressureColor;
      case VitalType.spo2:
        return AppTheme.spo2Color;
      case VitalType.sleep:
        return AppTheme.sleepColor;
      case VitalType.exercise:
        return AppTheme.exerciseColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Consumer<VitalsProvider>(
        builder: (context, vitalsProvider, child) {
          final vital = _getCurrentVital(vitalsProvider);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCurrentValue(vital),
                const SizedBox(height: 24),
                _buildPeriodSelector(),
                const SizedBox(height: 16),
                _buildChart(),
                const SizedBox(height: 24),
                _buildReferenceRanges(),
                const SizedBox(height: 24),
                _buildMeasureButton(vitalsProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  VitalSign? _getCurrentVital(VitalsProvider provider) {
    switch (widget.vitalType) {
      case VitalType.heartRate:
        return provider.heartRate;
      case VitalType.bloodPressure:
        return provider.bloodPressure;
      case VitalType.spo2:
        return provider.spo2;
      case VitalType.sleep:
        return provider.sleep;
      case VitalType.exercise:
        return provider.exercise;
    }
  }

  Widget _buildCurrentValue(VitalSign? vital) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(_icon, size: 48, color: _color),
            const SizedBox(height: 16),
            Text(
              vital?.displayValue ?? '--',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: _color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              vital?.unit ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                vital?.getStatus() ?? 'Sin datos',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: _color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _periods.map((period) {
        final isSelected = period == _selectedPeriod;
        return ChoiceChip(
          label: Text(period),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedPeriod = period;
              });
              _loadData();
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    if (_historicalData.isEmpty) {
      return const Card(
        child: SizedBox(
          height: 200,
          child: Center(child: Text('No hay datos disponibles')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(height: 200, child: _buildSimpleChart()),
      ),
    );
  }

  Widget _buildSimpleChart() {
    final spots = _historicalData
        .asMap()
        .entries
        .map((e) => e.value.value)
        .toList();

    return CustomPaint(
      painter: _ChartPainter(spots: spots, color: _color),
      size: const Size(double.infinity, 200),
    );
  }

  Widget _buildReferenceRanges() {
    final ranges = _getReferenceRanges();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rangos de Referencia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...ranges.map(
              (range) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(range['status']!),
                    Text(
                      range['range']!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getReferenceRanges() {
    switch (widget.vitalType) {
      case VitalType.heartRate:
        return [
          {'status': 'Bajo', 'range': '< 60 lpm'},
          {'status': 'Normal', 'range': '60 - 100 lpm'},
          {'status': 'Elevado', 'range': '> 100 lpm'},
        ];
      case VitalType.bloodPressure:
        return [
          {'status': 'Normal', 'range': '< 120/80 mmHg'},
          {'status': 'Prehipertensión', 'range': '120-139/80-89 mmHg'},
          {'status': 'Hipertensión Etapa 1', 'range': '140-159/90-99 mmHg'},
          {'status': 'Hipertensión Etapa 2', 'range': '≥ 160/100 mmHg'},
        ];
      case VitalType.spo2:
        return [
          {'status': 'Hipoxia Leve', 'range': '90 - 94 %'},
          {'status': 'Normal', 'range': '95 - 100 %'},
        ];
      case VitalType.sleep:
        return [
          {'status': 'Insuficiente', 'range': '< 6 horas'},
          {'status': 'Suficiente', 'range': '6 - 7 horas'},
          {'status': 'Óptimo', 'range': '7 - 9 horas'},
        ];
      case VitalType.exercise:
        return [
          {'status': 'Sedentario', 'range': '< 30 min'},
          {'status': 'Moderado', 'range': '30 - 60 min'},
          {'status': 'Activo', 'range': '> 60 min'},
        ];
    }
  }

  Widget _buildMeasureButton(VitalsProvider provider) {
    return ElevatedButton.icon(
      onPressed: provider.isMeasuring
          ? null
          : () async {
              await provider.startMeasurement(widget.vitalType);
            },
      icon: provider.isMeasuring
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.play_arrow),
      label: Text(provider.isMeasuring ? 'Midiendo...' : 'Iniciar Medición'),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> spots;
  final Color color;

  _ChartPainter({required this.spots, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (spots.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final minVal = spots.reduce((a, b) => a < b ? a : b);
    final maxVal = spots.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;
    final stepX = size.width / (spots.length - 1);

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < spots.length; i++) {
      final x = i * stepX;
      final y = size.height - ((spots[i] - minVal) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    for (int i = 0; i < spots.length; i++) {
      final x = i * stepX;
      final y = size.height - ((spots[i] - minVal) / range) * size.height;
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
