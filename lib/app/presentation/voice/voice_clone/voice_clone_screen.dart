import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/voice_training_screen.dart';
import 'package:ariapp/app/presentation/voice/widgets/question_background.dart';
import 'package:ariapp/app/security/user_logged.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../widgets/custom_button.dart';

class VoiceClone extends StatelessWidget {
  const VoiceClone({super.key});
  final successSnackBar = const SnackBar(
      backgroundColor: Colors.green,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 30,
            ),
            Column(
              children: [
                Text(
                  'Solicitud enviada',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ));
  final errorSnackBar = const SnackBar(
      backgroundColor: Colors.red,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 30,
            ),
            Column(
              children: [
                Text(
                  'Usted  ya envio\nuna solicitud',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ));
  @override
  Widget build(BuildContext context) {
    final userLogged = GetIt.instance<UserLogged>();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/future.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Stack(
            children: [
              QuestionBackground(),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.7,
                      child: const Text(
                        'DESCUBRE EL PODER DE TU VOZ',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.2,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: size.width * 0.7,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'El primer paso para entrenar tu voz con Inteligencia Artificial consiste en responder 10 preguntas para que AIA pueda aprender y familiarizarse con tu voz. Imagina que estás teniendo una conversación amigable. Así la entonación de tu voz será completamente natural',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    if (userLogged.user.canCreate!)
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                            width: size.width * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30.0, horizontal: 20),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 0),
                                        blurRadius: 4,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: CustomButton(
                                      text: 'Comenzar',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const VoiceTraining()));
                                      },
                                      width: 0.8)),
                            )),
                      ),
                    if (!userLogged.user.canCreate!)
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: size.width * 0.7,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Por el momento, esta funcionalidad no está disponible para todos los usuarios, pero se priorizará aquellos que lo soliciten',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    if (!userLogged.user.canCreate!)
                      SizedBox(
                          width: size.width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 20),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 0),
                                      blurRadius: 4,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: CustomButton(
                                    text: 'Solicitar acceso prioritarios',
                                    onPressed: () async {
                                      // Procede con la creación de la voz y otras operaciones
                                      final userAriaRepository =
                                          GetIt.instance<UserAriaRepository>();

                                      final isSend = await userAriaRepository
                                          .getApplicant(userLogged.user.id!);

                                      if (isSend) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(errorSnackBar)
                                            .closed;
                                      } else {
                                        await userAriaRepository
                                            .sendApplicant(userLogged.user.id!);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(successSnackBar)
                                            .closed;
                                      }
                                    },
                                    width: 0.8)),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
