

import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/chats/chat/widgets/audio_message_content.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Question  {
  final String question;
  const Question({
    required this.question,
  });
}

List<Question> questions1 = [
  const Question(question: '¿Cúal es tu nombre y como te gusta que te llamen?'),
  const Question(question: '¿Cúal es tu comida favorita y por qué?(Sé breve, por favor)'),
  const Question(question: '¿Cúal es tu canción favorita  y por qué?(Sé breve, por favor)'),
  const Question(question: '¿Puedes contarme un chiste o una experiencia que te hizo reír mucho?'),
  const Question(question: '¿Cómo te sentirías si ganaras un premio sorpresa en este momento?'),
];