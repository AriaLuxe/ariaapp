import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/voice_repository.dart';
import 'package:ariapp/app/presentation/sign_in/widgets/text_input.dart';
import 'package:ariapp/app/presentation/widgets/arrow_back.dart';
import 'package:ariapp/app/presentation/widgets/custom_button_blue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/voice_bloc.dart';

class EditVoice extends StatelessWidget {
  EditVoice({Key? key, required this.title, required this.description}) : super(key: key);

  final String title;
  final String description;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleController.text = title;
    _descriptionController.text = description;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea elementos a la izquierda y al centro
                    children: [
                      ArrowBack(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Editar voz',
                        style: TextStyle(color: Colors.white, fontSize: 29),
                      ),
                      SizedBox(  width: MediaQuery.of(context).size.width * 0.1,),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                      TextInput(
                        controller: _titleController,
                        label: 'Nombre',
                        verticalPadding: 10,
                        prefixIcon: Icons.description,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                      const Text(
                        'Descripción',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                      TextInput(
                        controller: _descriptionController,
                        label: 'Descripción',
                        verticalPadding: 10,
                        prefixIcon: Icons.description,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.2),
                      CustomButtonBlue(
                        text: 'Guardar cambios',
                        onPressed: () {

                          final voiceBloc = BlocProvider.of<VoiceBloc>(context);
                          final voiceRepository = GetIt.instance<VoiceRepository>();
                          //TODO
                          voiceRepository.editVoiceClone(4, _titleController.text.trim(), _descriptionController.text.trim());
                          voiceBloc.fetchProfileVoice();


                        },
                        width: 0.2,
                      ),
                    ],
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
