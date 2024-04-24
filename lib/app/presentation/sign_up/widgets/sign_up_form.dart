import 'package:ariapp/app/config/helpers/custom_dialogs.dart';
import 'package:ariapp/app/infrastructure/data_sources/email_validation_data_provider.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/sign_up/terminos_condiciones_screen.dart';
import 'package:ariapp/app/presentation/sign_up/widgets/verify_code.dart';
import 'package:ariapp/app/presentation/widgets/custom_button.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:ariapp/app/presentation/widgets/header.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../config/styles.dart';
import '../../../domain/entities/user_aria.dart';
import '../../sign_in/widgets/text_input.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _obscureText = true;
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  bool isLoadingSignUp = false;
  bool isAcceptedTerminos = false;

  @override
  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  List<String> generos = ["Masculino", "Femenino", "Otro"];

  String selectedGenero = "Masculino";

  void onGenderChanged(String newValue) {
    setState(() {
      _genderController.text = newValue;
      context.read<SignUpBloc>().add(GenderChanged(_genderController.text));
    });
  }

  final usersRepository = GetIt.instance<UserAriaRepository>();
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
                  'Correo invalido',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Verifique su correo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    final signUpBloc = context.watch<SignUpBloc>();
    Size size = MediaQuery.of(context).size;

    final nameUser = signUpBloc.state.nameInputValidator;
    final lastName = signUpBloc.state.lastNameInputValidator;
    final nickname = signUpBloc.state.nicknameInputValidator;
    final email = signUpBloc.state.emailInputValidator;
    final country = signUpBloc.state.countryInputValidator;

    final password = signUpBloc.state.passwordInputValidator;
    final birthDate = signUpBloc.state.birthDateInputValidator;

    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          children: [
            Header(
              title: 'Crear cuenta',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 25,
            ),
            TextInput(
              verticalPadding: 15,
              prefixIcon: Icons.person,
              label: 'Ingresa tus nombres',
              onChanged: (name) =>
                  context.read<SignUpBloc>().add(NameChanged(name)),
              errorMessage: state.nameInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              verticalPadding: 15,
              prefixIcon: Icons.person,
              label: 'Ingresa tus apellidos',
              onChanged: (lastName) =>
                  context.read<SignUpBloc>().add(LastNameChanged(lastName)),
              errorMessage: state.lastNameInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              verticalPadding: 15,
              prefixIcon: Icons.verified_user,
              label: 'Ingresa tu nickname',
              onChanged: (nickname) =>
                  context.read<SignUpBloc>().add(NicknameChanged(nickname)),
              errorMessage: state.nicknameInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              verticalPadding: 15,
              readOnly: true,
              onTap: () {
                context
                    .read<SignUpBloc>()
                    .add(BirthDateChanged(_birthDateController.text));
                showDialog(
                  context: context,
                  builder: (context1) {
                    return AlertDialog(
                      title: Text(
                        'Selecciona una fecha',
                        style: TextStyle(
                          color: Styles.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: SizedBox(
                        height: size.height / 4,
                        width: size.height * 2,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime(2000),
                          maximumDate: DateTime.now(),
                          onDateTimeChanged: (DateTime newDate) {
                            _birthDateController.text =
                                DateFormat('yyyy-MM-dd').format(newDate);
                          },
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            context.read<SignUpBloc>().add(
                                BirthDateChanged(_birthDateController.text));
                            Navigator.of(context).pop();
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              },
              enabled: true,
              label: 'Fecha de nacimiento',
              prefixIcon: Icons.calendar_month,
              isAnimated: FloatingLabelBehavior.never,
              controller: _birthDateController,
              errorMessage: state.birthDateInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              verticalPadding: 15,
              errorMessage: state.genderInputValidator.errorMessage,
              controller: _genderController,
              onTap: () {
                context
                    .read<SignUpBloc>()
                    .add(GenderChanged(_genderController.text));

                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Femenino'),
                          onTap: () {
                            onGenderChanged('Femenino');
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('Masculino'),
                          onTap: () {
                            onGenderChanged('Masculino');
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('Otro'),
                          onTap: () {
                            onGenderChanged('Otro');
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              readOnly: true,
              label: 'Género',
              prefixIcon: Icons.circle_outlined,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.45,
                  child: TextInput(
                    verticalPadding: 15,
                    controller: _countryController,
                    readOnly: true,
                    onTap: () {
                      context
                          .read<SignUpBloc>()
                          .add(CountryChanged(_countryController.text));
                      showCountryPicker(
                          context: context,
                          countryListTheme: const CountryListThemeData(
                            searchTextStyle: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                          ),
                          onSelect: (Country country) {
                            _countryController.text = country.name;
                            context
                                .read<SignUpBloc>()
                                .add(CountryChanged(_countryController.text));
                          });
                    },
                    prefixIcon: Icons.flag,
                    label: 'Pais',
                    errorMessage: state.countryInputValidator.errorMessage,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.4,
                  child: TextInput(
                    verticalPadding: 15,
                    prefixIcon: Icons.location_on,
                    label: 'Ciudad',
                    onChanged: (city) =>
                        context.read<SignUpBloc>().add(CityChanged(city)),
                    errorMessage: state.cityInputValidator.errorMessage,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              verticalPadding: 15,
              prefixIcon: Icons.mail,
              label: 'Ingresa tu correo',
              onChanged: (email) =>
                  context.read<SignUpBloc>().add(EmailChanged(email)),
              errorMessage: state.emailInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              verticalPadding: 15,
              obscureText: _obscureText,
              label: 'Contraseña',
              prefixIcon: Icons.lock,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              onChanged: (password) =>
                  context.read<SignUpBloc>().add(PasswordChanged(password)),
              errorMessage: state.passwordInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 15,
            ),
            _TerminosCondiciones((newValue) {
              setState(() {
                isAcceptedTerminos = newValue!;
              });
            }, isAcceptedTerminos),
            SizedBox(
                width: double.infinity,
                child: isLoadingSignUp
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        onPressed: signUpBloc.state.isValid
                            ? () async {
                                if (isAcceptedTerminos) {
                                  setState(() {
                                    isLoadingSignUp = true;
                                  });
                                  final emailValidation =
                                      EmailValidationDataProvider();
                                  final response = await emailValidation
                                      .sendEmailToRegisterUser(email.value);
                                  print(response);
                                  if (response == 'Email sent successfully') {
                                    final user = UserAria(
                                        nameUser: nameUser.value.trim(),
                                        lastName: lastName.value.trim(),
                                        email: email.value.trim(),
                                        password: password.value,
                                        gender: _genderController.text.trim(),
                                        country: _countryController.text.trim(),
                                        city: country.value.trim(),
                                        nickname: nickname.value.trim(),
                                        dateBirth: DateTime.parse(
                                            DateFormat('yyyy-MM-dd').format(
                                                DateTime.parse(
                                                    birthDate.value))),
                                        role: 'USER');

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VerifyCode(
                                                email: email.value.trim(),
                                                verify:
                                                    'Verificar y Registrarse',
                                                isResetPassword: false,
                                                user: user)));
                                    setState(() {
                                      isLoadingSignUp = false;
                                    });
                                  } else if (response ==
                                      'Has already exists an account with this email') {
                                    CustomDialogs().showConfirmationDialog(
                                      context: context,
                                      title: 'Alerta',
                                      content:
                                          'Ya existe una cuenta con este correo.\n Ingrese nuevo correo',
                                      onAccept: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  } else if (response ==
                                      'Code already send to this email') {
                                    CustomDialogs().showConfirmationDialog(
                                      context: context,
                                      title: 'Alerta',
                                      content:
                                          'Ya se envio un codigo a este correo',
                                      onAccept: () {
                                        setState(() {
                                          isLoadingSignUp = true;
                                        });
                                        final user = UserAria(
                                            nameUser: nameUser.value.trim(),
                                            lastName: lastName.value.trim(),
                                            email: email.value.trim(),
                                            password: password.value,
                                            gender:
                                                _genderController.text.trim(),
                                            country:
                                                _countryController.text.trim(),
                                            city: country.value.trim(),
                                            nickname: nickname.value.trim(),
                                            dateBirth: DateTime.parse(
                                                DateFormat('yyyy-MM-dd').format(
                                                    DateTime.parse(
                                                        birthDate.value))),
                                            role: 'USER');
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VerifyCode(
                                                        email:
                                                            email.value.trim(),
                                                        verify: 'Crear cuenta',
                                                        isResetPassword: false,
                                                        user: user)));

                                        setState(() {
                                          isLoadingSignUp = false;
                                        });
                                      },
                                    );
                                  } else {
                                    CustomDialogs().showConfirmationDialog(
                                      context: context,
                                      title: 'Alerta',
                                      content: 'Verifique sus datos',
                                      onAccept: () {
                                        setState(() {
                                          isLoadingSignUp = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  }
                                } else {
                                  CustomDialogs().showConfirmationDialog(
                                    context: context,
                                    title: 'Alerta',
                                    content:
                                        'Por favor, acepta los términos y condiciones antes de continuar.',
                                    onAccept: () {
                                      setState(() {
                                        isLoadingSignUp = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                }
                              }
                            : null,
                        text: 'Siguiente',
                        width: 0.8,
                      ))
          ],
        );
      },
    );
  }
}

class _TerminosCondiciones extends StatelessWidget {
  const _TerminosCondiciones(this.onChanged, this.value);

  final void Function(bool?)? onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
          activeColor: const Color(0xFF5368d6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          value: value,
          onChanged: onChanged,
        ),
        const Text(
          "Acepto los ",
          style: TextStyle(color: Colors.grey),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TerminosCondicionesScreen()));
          },
          child: const Text(
            "Términos y condiciones",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
