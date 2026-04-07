class AppConstants {
  static const String appName = 'Vitaltrack';
  static const String appVersion = '1.0.0';

  static const String loginTitle = 'Bienvenido a Vitaltrack';
  static const String loginSubtitle = 'Monitorea tu salud en tiempo real';

  static const String registerTitle = 'Crear Cuenta';
  static const String registerSubtitle = 'Regístrate para comenzar';

  static const String onboardingTitle1 = 'Monitorea tu Salud';
  static const String onboardingDesc1 =
      'Conecta tus dispositivos IoT y monitorea tus signos vitales en tiempo real';

  static const String onboardingTitle2 = 'Análisis Detallado';
  static const String onboardingDesc2 =
      'Visualiza gráficas históricas y conoce el estado de tu salud';

  static const String onboardingTitle3 = 'Alertas y Soporte';
  static const String onboardingDesc3 =
      'Recibe notificaciones y accede a contenido educativo';

  static const int onboardingPages = 3;

  static const String termsUrl = 'https://vitaltrack.com/terminos';
  static const String privacyUrl = 'https://vitaltrack.com/privacidad';

  static const String deviceName = 'VitalBand Pro';
  static const String deviceId = 'VB-2024-XXXX';

  static const int scanTimeout = 10;
  static const int connectionTimeout = 15;
}

class VitalRanges {
  static const Map<String, List<double>> heartRate = {
    'min': [40.0, 60.0, 100.0],
    'max': [59.0, 99.0, 200.0],
  };

  static const List<String> heartRateStatus = ['Bajo', 'Normal', 'Elevado'];

  static const Map<String, List<double>> systolic = {
    'min': [90.0, 120.0, 140.0],
    'max': [119.0, 139.0, 180.0],
  };

  static const Map<String, List<double>> diastolic = {
    'min': [60.0, 80.0, 90.0],
    'max': [79.0, 89.0, 120.0],
  };

  static const List<String> bloodPressureStatus = [
    'Normal',
    'Prehipertensión',
    'Hipertensión Etapa 1',
    'Hipertensión Etapa 2',
  ];

  static const Map<String, List<double>> spo2 = {
    'min': [90.0, 95.0],
    'max': [94.0, 100.0],
  };

  static const List<String> spo2Status = ['Hipoxia Leve', 'Normal'];

  static const Map<String, List<double>> sleep = {
    'min': [0.0, 6.0, 7.0],
    'max': [5.9, 6.9, 12.0],
  };

  static const List<String> sleepStatus = [
    'Insuficiente',
    'Suficiente',
    'Óptimo',
  ];

  static const Map<String, List<double>> exercise = {
    'min': [0.0, 30.0, 60.0],
    'max': [29.0, 59.0, 180.0],
  };

  static const List<String> exerciseStatus = [
    'Sedentario',
    'Moderado',
    'Activo',
  ];
}
