import 'package:ariapp/app/presentation/profiles/my_profile/sugerir/bloc/sugerir_bloc.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../infrastructure/repositories/user_aria_repository.dart';
import '../../../sign_in/widgets/text_input.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/header.dart';

class Sugerir extends StatelessWidget {
  const Sugerir({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => SugerirBloc(),
      child: Center(
        child: SizedBox(width: size.width * 0.9, child: SugerirForm()),
      ),
    );
  }
}

class SugerirForm extends StatelessWidget {
  SugerirForm({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final successSnackBar = const SnackBar(
      backgroundColor: Colors.green,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 60,
            ),
            Column(
              children: [
                Text(
                  'Enviado',
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
    Size size = MediaQuery.of(context).size;
    final updateEmailBloc = context.watch<SugerirBloc>();

    return BlocBuilder<SugerirBloc, SugerirState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Header(
                    title: 'Sugerencias',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Título',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _titleController,
                        verticalPadding: 15,
                        prefixIcon: Icons.email,
                        label: 'Ingresa título o asunto',
                        onChanged: (email) => context
                            .read<SugerirBloc>()
                            .add(EmailChanged(email)),
                        errorMessage: state.emailInputValidator.errorMessage,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Comentario',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _contentController,
                        verticalPadding: 50,
                        prefixIcon: Icons.comment,
                        label:
                            'Ingrese comentario, sugerencia,\nreclamo o algún mensaje que\nquieras decirnos',
                        onChanged: (password) => context
                            .read<SugerirBloc>()
                            .add(PasswordChanged(password)),
                        errorMessage: state.passwordInputValidator.errorMessage,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  SizedBox(
                      width: size.width * 0.5,
                      child: CustomButton(
                        onPressed: updateEmailBloc.state.isValid
                            ? () async {
                                final userRepository =
                                    GetIt.instance<UserAriaRepository>();
                                final userId =
                                    await SharedPreferencesManager.getUserId();

                                await userRepository.sendSuggestion(
                                    userId!,
                                    _titleController.text.trim(),
                                    _contentController.text.trim());
                                _titleController.clear();
                                _contentController.clear();
                                context
                                    .read<SugerirBloc>()
                                    .add(const ClearData());

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(successSnackBar)
                                    .closed;
                              }
                            : null,
                        text: 'Enviar',
                        width: 0.1,
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
