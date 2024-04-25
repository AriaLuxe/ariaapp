import 'package:ariapp/app/presentation/profiles/my_profile/update_password/bloc/update_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/repositories/user_aria_repository.dart';
import '../../../../security/shared_preferences_manager.dart';
import '../../../sign_in/widgets/text_input.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/header.dart';

class UpdatePassword extends StatelessWidget {
  const UpdatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => UpdatePasswordBloc(),
      child: Center(
        child: SizedBox(width: size.width * 0.9, child: UpdatePasswordForm()),
      ),
    );
  }
}

class UpdatePasswordForm extends StatelessWidget {
  UpdatePasswordForm({super.key});

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final errorSnackBar = const SnackBar(
      backgroundColor: Colors.red,
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
                  'Contraseña incorrecta',
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
  final errorSnackBar1 = const SnackBar(
      backgroundColor: Colors.red,
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
                  'Las contraseñas\nno coinciden',
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
                  'Contraseña actualizada',
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
    final updateEmailBloc = context.watch<UpdatePasswordBloc>();

    return BlocBuilder<UpdatePasswordBloc, UpdatePasswordState>(
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
                    title: 'Cambiar Contraseña',
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
                        'Contraseña Actual',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _currentPasswordController,
                        verticalPadding: 15,
                        prefixIcon: Icons.lock,
                        label: 'Ingresa tu contraseña',
                        onChanged: (email) => context
                            .read<UpdatePasswordBloc>()
                            .add(CurrentPasswordChanged(email)),
                        errorMessage:
                            state.currentPasswordInputValidator.errorMessage,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contraseña nueva',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _passwordController,
                        verticalPadding: 15,
                        prefixIcon: Icons.lock,
                        label: 'Ingrese una nueva contraseña',
                        onChanged: (password) => context
                            .read<UpdatePasswordBloc>()
                            .add(PasswordChanged(password)),
                        errorMessage: state.passwordInputValidator.errorMessage,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirmar contraseña ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _confirmPasswordController,
                        verticalPadding: 15,
                        prefixIcon: Icons.lock,
                        label: 'Confirma tu contraseña',
                        onChanged: (password) => context
                            .read<UpdatePasswordBloc>()
                            .add(ConfirmPasswordChanged(password)),
                        errorMessage:
                            state.confirmPasswordInputValidator.errorMessage,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  SizedBox(
                      width: size.width * 0.7,
                      child: CustomButton(
                        onPressed: updateEmailBloc.state.isValid
                            ? () async {
                                final userRepository =
                                    GetIt.instance<UserAriaRepository>();
                                final userId =
                                    await SharedPreferencesManager.getUserId();
                                final response =
                                    await userRepository.updateUserPassword(
                                        userId!,
                                        _passwordController.text.trim(),
                                        _currentPasswordController.text.trim());
                                if (_passwordController.text.trim() !=
                                    _confirmPasswordController.text.trim()) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(errorSnackBar1)
                                      .closed;
                                } else {
                                  if (response == 'Password is updated') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(successSnackBar)
                                        .closed;
                                    context.go("/my_profile");
                                  } else if (response == 'Incorrect password') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(errorSnackBar)
                                        .closed;
                                  }
                                  _currentPasswordController.clear();
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                }
                              }
                            : null,
                        text: 'Guardar',
                        width: 0.8,
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
