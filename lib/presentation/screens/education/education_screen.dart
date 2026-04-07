import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Educación y Soporte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Tutoriales en Video'),
            const SizedBox(height: 16),
            _buildVideoSection(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Preguntas Frecuentes'),
            const SizedBox(height: 16),
            _buildFaqSection(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Contacto de Soporte'),
            const SizedBox(height: 16),
            _buildSupportSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildVideoSection(BuildContext context) {
    final videos = [
      {'title': 'Cómo vincular tu dispositivo', 'duration': '2:30'},
      {'title': 'Interpretar tus signos vitales', 'duration': '4:15'},
      {'title': 'Usar la función de medición', 'duration': '3:00'},
      {'title': 'Configurar notificaciones', 'duration': '2:45'},
    ];

    return Column(
      children: videos
          .map(
            (video) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle_fill,
                    color: AppTheme.primaryColor,
                  ),
                ),
                title: Text(video['title']!),
                subtitle: Text(video['duration']!),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Video no disponible en modo demo'),
                    ),
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    final faqs = [
      {
        'question': '¿Cómo puedo vincular mi dispositivo?',
        'answer':
            'Ve a la sección de perfil y selecciona "Vincular dispositivo". Asegúrate de que tu dispositivo esté cerca y con Bluetooth activado.',
      },
      {
        'question': '¿Los datos son precisos?',
        'answer':
            'Los datos mostrados son simulados para demostración. En un dispositivo real, los sensores proporcionan lecturas precisas.',
      },
      {
        'question': '¿Necesito internet para usar la app?',
        'answer':
            'No, la app funciona sin conexión. Sin embargo, algunas funciones como la sincronización de datos requieren conexión.',
      },
      {
        'question': '¿Qué significan los colores en las gráficas?',
        'answer':
            'Verde indica valores normales, amarillo valores moderados y rojo valores que requieren atención médica.',
      },
      {
        'question': '¿Cómo contacto soporte técnico?',
        'answer':
            'Puedes escribirnos a soporte@vitaltrack.com o llamar al 1-800-VITAL.',
      },
    ];

    return ExpansionPanelList.radio(
      elevation: 1,
      children: faqs
          .map(
            (faq) => ExpansionPanelRadio(
              value: faqs.indexOf(faq).toString(),
              headerBuilder: (context, isExpanded) =>
                  ListTile(title: Text(faq['question']!)),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  faq['answer']!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.email, color: AppTheme.primaryColor),
            title: const Text('Correo electrónico'),
            subtitle: const Text('soporte@vitaltrack.com'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.phone, color: AppTheme.primaryColor),
            title: const Text('Teléfono'),
            subtitle: const Text('1-800-VITAL'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.web, color: AppTheme.primaryColor),
            title: const Text('Sitio web'),
            subtitle: const Text('www.vitaltrack.com'),
          ),
        ],
      ),
    );
  }
}
