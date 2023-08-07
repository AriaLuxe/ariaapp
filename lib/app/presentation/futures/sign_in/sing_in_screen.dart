import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/futures/sign_in/widgets/text_input.dart';
import 'package:ariapp/app/presentation/futures/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: SafeArea(
          child: Column(
        children: [
          Image.asset(
            'assets/images/messi.jpg',
            width: 250,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
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
                      height: 00,
                    ),
                    TextInput(
                      textInputType: TextInputType.emailAddress,
                      label: 'Correo',
                      prefixIcon: Icons.email,
                      isPassword: false,
                    ),
                    const SizedBox(
                      height: 00,
                    ),
                    Column(
                      children: [
                        TextInput(
                            label: 'Contraseña',
                            isPassword: true,
                            prefixIcon: Icons.lock,
                            suffixIcon: Icons.visibility),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
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
                              text: 'Registrate',
                              style: TextStyle(
                                  color: Styles.primaryColor,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
