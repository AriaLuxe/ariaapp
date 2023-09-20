import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:ariapp/app/security/sign_in_service.dart';
import 'package:ariapp/injections.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../config/styles.dart';
import '../../../infrastructure/repositories/user_aria_repository.dart';
import '../../layouts/layout.dart';
import '../../sign_up/sign_up_screen.dart';
import '../bloc/sign_in_bloc.dart';
import 'text_input.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final usersRepository = GetIt.instance<UserAriaRepository>();

  bool _obscureText = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Bienvenido',
              style: TextStyle(
                  color: Styles.primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            TextInput(
              controller: email,
              textInputType: TextInputType.emailAddress,
              label: 'Correo',
              prefixIcon: Icons.email,
              onChanged: (email) =>
                  context.read<SignInBloc>().add(EmailChanged(email)),
              errorMessage: state.emailInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 25,
            ),
            Column(
              children: [
                TextInput(
                  controller: password,
                  obscureText: _obscureText,
                  label: 'Contraseña',
                  prefixIcon: Icons.lock,
                  onChanged: (password) =>
                      context.read<SignInBloc>().add(PasswordChanged(password)),
                  errorMessage: state.passwordInputValidator.errorMessage,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text(
                      'Recuperar contraseña',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 0,
            ),
            FilledButton(
                onPressed: () async {
                  final signInService = SignInService();
                  final isSignedIn =
                      await signInService.signIn(email.text, password.text);

                  if (isSignedIn) {
                    int? userId = await SharedPreferencesManager.getUserId();
                    String token = 'asd';
                    final user = await usersRepository.getUserById(userId!);
                    userLogged(user, token);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  }
                },
                child: const Text(
                  'Iniciar Sesion',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            RichText(
              text: TextSpan(
                text: '¿No tienes una cuenta? ',
                style: TextStyle(color: Styles.primaryColor),
                children: <TextSpan>[
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                    text: 'Registrate',
                    style: TextStyle(
                        color: Styles.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
