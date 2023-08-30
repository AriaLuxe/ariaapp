import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/futures/sign_up/widgets/sign_up_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../sign_in/widgets/text_input.dart';
import 'widgets/sign_up_date_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        iconTheme: const IconThemeData(
            color: Colors.black), // Cambia el color del icono de regresar
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create una cuenta en Aria',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Styles.primaryColor),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextInput(
                  prefixIcon: Icons.person,
                  label: 'Ingresa tus nombres',
                ),
                const SizedBox(
                  height: 20,
                ),
                TextInput(
                  prefixIcon: Icons.person,
                  label: 'Ingresa tus apellidos',
                ),
                const SizedBox(
                  height: 20,
                ),
                TextInput(
                  prefixIcon: Icons.mail,
                  label: 'Ingresa tu correo',
                ),
                const SizedBox(
                  height: 20,
                ),
                TextInput(
                  obscureText: _obscureText,
                  label: 'Contraseña',
                  prefixIcon: Icons.lock,
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
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        DateTime selectedDate = DateTime(2000);
                        return AlertDialog(
                          title: Text(
                            'Selecciona una fecha',
                            style: TextStyle(
                                color: Styles.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.height * 2,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: DateTime(2000),
                              maximumDate: DateTime.now(),
                              onDateTimeChanged: (DateTime newDate) {
                                selectedDate = newDate;
                              },
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Aquí puedes manejar la fecha seleccionada (selectedDate)
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: TextInput(
                    enabled: false,
                    label: 'Fecha de nacimiento',
                    prefixIcon: Icons.cake,
                    readOnly: true,
                    isAnimated: FloatingLabelBehavior.never,
                  ),
                ),
                const SizedBox(
                  height: 20,
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
      ),
    );
  }
}
