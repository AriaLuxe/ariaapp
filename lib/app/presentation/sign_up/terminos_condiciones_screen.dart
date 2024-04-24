import 'package:flutter/material.dart';

class TerminosCondicionesScreen extends StatelessWidget {
  const TerminosCondicionesScreen({super.key, this.isAccepted});

  final isAccepted;

  TextSpan _buildTitle(String text) {
    return TextSpan(
      text: '$text\n',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.red,
      ),
    );
  }

  TextSpan _buildSubtitle(String text) {
    return TextSpan(
      text: '$text\n\n',
      style: const TextStyle(
        fontSize: 13,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF5368d6), // Color específico
        onPressed: () {
          Navigator.pop(context);
        },
        label: const Text(
          'Leí los términos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Términos y condiciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(
                            color: Colors.black,
                            decoration: TextDecoration
                                .none // Ajusta el color del texto aquí
                            ),
                        children: [
                          _buildTitle('1. Registro y Consentimiento de Uso:'),
                          _buildSubtitle(
                            'Al registrarse en la aplicación, el usuario otorga su consentimiento para el uso de su información personal (nombre, correo electrónico, fecha de nacimiento, etc.) con el único propósito de crear y gestionar un perfil en la aplicación.',
                          ),
                          _buildTitle('2. Permisos de la Aplicación:'),
                          _buildSubtitle(
                            'La aplicación solicita acceso al micrófono y la galería/cámara del dispositivo para clonar la voz del usuario, permitiéndole establecer conversaciones mediante el envío de audios. El contenido de audio nunca se compartirá sin un consentimiento explícito adicional.',
                          ),
                          _buildSubtitle(
                            'Es importante tener en cuenta que el acceso al micrófono y la cámara es necesario para la funcionalidad principal de la aplicación y no se utilizará con fines distintos a los especificados.',
                          ),
                          _buildTitle(
                              '3. Tecnología de Inteligencia Artificial:'),
                          _buildSubtitle(
                            'La aplicación utiliza tecnología de inteligencia artificial para crear un clon de voz que facilita la interacción entre usuarios. Sin embargo, no se puede garantizar que la voz clonada sea idéntica al 100% a la del usuario original.',
                          ),
                          _buildTitle('4. Eliminación de Perfil y Datos:'),
                          _buildSubtitle(
                            'El usuario tiene el derecho de eliminar su perfil y cuenta en cualquier momento, lo que conlleva a la eliminación permanente de los datos recolectados.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  const Text(
                    'Políticas de privacidad',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(
                            color: Colors.black,
                            decoration: TextDecoration
                                .none // Ajusta el color del texto aquí
                            ),
                        children: [
                          _buildTitle('1. Recopilación de Datos:'),
                          _buildSubtitle(
                            'La aplicación recolecta únicamente los datos personales proporcionados durante el registro (nombre, correo electrónico, fecha de nacimiento, género, ubicación, etc.) con el propósito de crear y mantener un perfil de usuario para el funcionamiento de la aplicación.',
                          ),
                          _buildSubtitle(
                              'La fecha de nacimiento se utiliza exclusivamente para verificar la mayoría de edad y cumplir con las pautas de las tiendas de aplicaciones.'),
                          _buildTitle('2. Visibilidad de Datos:'),
                          _buildSubtitle(
                            'Los datos de nombre, apodo, correo electrónico y foto de perfil son los únicos que se muestran públicamente a otros usuarios de la aplicación.',
                          ),
                          _buildTitle('3. Uso Interno y Mejora del Servicio:'),
                          _buildSubtitle(
                            'La aplicación no comparte ni vende datos de usuarios a terceros. La información se utiliza exclusivamente dentro de la aplicación y con el fin de mejorar la calidad del servicio.',
                          ),
                          _buildTitle('4. Cambios en los Términos:'),
                          _buildSubtitle(
                            'Nos reservamos el derecho de modificar estos términos en cualquier momento y te notificaremos sobre cambios significativos. La continua utilización de la aplicación después de dichas modificaciones se considerará como aceptación de los nuevos términos',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
