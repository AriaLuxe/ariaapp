import 'package:ariapp/app/infrastructure/data_sources/email_validation_data_provider.dart';
import 'package:ariapp/app/presentation/sign_in/sing_in_screen.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:flutter/material.dart';

import '../../sign_in/widgets/text_input.dart';
import '../../widgets/custom_button.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

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

  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF354271),
                      ),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.08,
                child: Image.asset(
                  'assets/images/tree_oficial.png',
                  key: const ValueKey<String>('assets/images/tree_oficial.png'),
                ),
              ),
              SizedBox(
                height: size.height *
                    0.03, // Ejemplo: 8% de la altura de la pantalla
              ),
              const Text(
                'Nueva contraseña',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SizedBox(
                width: size.width * 0.55,
                child: const Text(
                  'Su nueva contraseña debe ser diferente a su contraseña actual',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contraseña',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextInput(
                      obscureText: _obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      verticalPadding: 15,
                      controller: password,
                      label: 'Contraseña',
                      prefixIcon: Icons.lock,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.05),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirmar Contraseña',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextInput(
                      obscureText: _obscureTextConfirm,
                      verticalPadding: 15,
                      controller: confirmPassword,
                      label: 'Contraseña',
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureTextConfirm = !_obscureTextConfirm;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.08),
              SizedBox(
                  width: size.width * 0.8,
                  child: CustomButton(
                      text: 'Cambiar contraseña',
                      onPressed: () async {
                        final emailValidation = EmailValidationDataProvider();
                        final response = await emailValidation.resetPassword(
                            widget.email,
                            password.text.trim(),
                            confirmPassword.text.trim());
                        if (response == 'Password is updated') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogAccept(
                                text:
                                    'La contraseña se ha cambiado satisfactoriamente.\nInicie sesión con su nueva contraseña.',
                                onAccept: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInScreen(),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogAccept(
                                text:
                                    '¡Oops!\nParece que las contraseñas no coinciden. Revise e inténtelo de nuevo.',
                                onAccept: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        }
                      },
                      width: 0.5)),
              SizedBox(
                height: size.height * 0.2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
