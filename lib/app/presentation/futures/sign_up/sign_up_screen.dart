import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/futures/sign_up/widgets/sign_up_text_input.dart';
import 'package:flutter/material.dart';

import 'widgets/sign_up_date_input.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(
            color: Colors.black), // Cambia el color del icono de regresar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Create una cuenta en Aria',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Styles.primaryColor),
              ),
              SignUpTextInput(
                title: 'Nombres',
                prefixIcon: Icons.person,
                labelText: 'Ingresa tus nombres',
              ),
              SignUpTextInput(
                title: 'Apellidos',
                prefixIcon: Icons.person,
                labelText: 'Ingresa tus apellidos',
              ),
              SignUpTextInput(
                title: 'Correo',
                prefixIcon: Icons.mail,
                labelText: 'Ingresa tu correo',
              ),
              SignUpTextInput(
                title: 'Contraseña',
                prefixIcon: Icons.lock,
                labelText: 'Ingresa tu contraseña',
                suffixIcon: Icons.visibility_off,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: SignUpDateInput(
                        title: 'Dia',
                        labelText: 'DD',
                        suffixIcon: Icons.arrow_drop_down,
                      )),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: SignUpDateInput(
                        title: 'Mes',
                        labelText: 'MM',
                        suffixIcon: Icons.arrow_drop_down,
                      )),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: SignUpDateInput(
                        title: 'Año',
                        labelText: 'AAAA',
                        suffixIcon: Icons.arrow_drop_down,
                      ))
                ],
              ),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () {},
                      child: const Text(
                        'Registrace',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
