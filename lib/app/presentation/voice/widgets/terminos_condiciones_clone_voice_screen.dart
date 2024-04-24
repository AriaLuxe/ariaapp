import 'package:flutter/material.dart';

class TerminosCondicionesCloneVoiceScreen extends StatelessWidget {
  const TerminosCondicionesCloneVoiceScreen({super.key, this.isAccepted});

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
                          _buildTitle(
                              '1. Consentimiento para Clonación de Voz:'),
                          _buildSubtitle(
                            'Al utilizar la función de clonación de voz en la aplicación, el usuario otorga su consentimiento expreso para que la aplicación acceda al micrófono y la galería/cámara del dispositivo con el objetivo de clonar su voz y permitir la interacción con otros usuarios mediante el envío de audios.',
                          ),
                          _buildTitle('2. Limitaciones de la Tecnología:'),
                          _buildSubtitle(
                            'La aplicación utiliza tecnología de inteligencia artificial para crear un clon de voz, pero se informa al usuario que no se puede garantizar que la voz clonada sea idéntica al 100% a la del usuario original',
                          ),
                          _buildTitle('3. Eliminación de Datos de Voz:'),
                          _buildSubtitle(
                            'El usuario tiene el derecho de solicitar la eliminación de los datos de voz clonada asociados a su cuenta en cualquier momento.',
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
                          _buildTitle('3. Cambios en los Términos:'),
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
