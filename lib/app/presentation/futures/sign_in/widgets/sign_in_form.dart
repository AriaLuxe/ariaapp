import 'package:ariapp/app/presentation/futures/sign_in/bloc/sign_in_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/styles.dart';
import '../../layouts/layout.dart';
import '../../sign_up/sign_up_screen.dart';
import 'text_input.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _obscureText = true;

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
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: const Text(
                  'ACEPTAR',
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
