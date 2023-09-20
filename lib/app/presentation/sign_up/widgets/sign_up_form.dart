import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    final signUpBloc = context.watch<SignUpBloc>();

    final nameUser = signUpBloc.state.nameInputValidator;
    final lastName = signUpBloc.state.lastNameInputValidator;
    final nickname = signUpBloc.state.nicknameInputValidator;
    final email = signUpBloc.state.emailInputValidator;
    final country = signUpBloc.state.countryInputValidator;

    final password = signUpBloc.state.passwordInputValidator;
    final birthDate = signUpBloc.state.birthDateInputValidator;
    //final gender  = signUpBloc.state.emailInputValidator;
    //final country =  signUpBloc.state.nickName;
    //final city =  signUpBloc.state.city;

    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
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
              onChanged: (name) =>
                  context.read<SignUpBloc>().add(NameChanged(name)),
              errorMessage: state.nameInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
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
              prefixIcon: Icons.person,
              label: 'Ingresa tu nickname',
              onChanged: (nickname) =>
                  context.read<SignUpBloc>().add(NicknameChanged(nickname)),
              errorMessage: state.nicknameInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
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
                          title: Text('Femenino'),
                          onTap: () {
                            onGenderChanged('Femenino');
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Masculino'),
                          onTap: () {
                            onGenderChanged('Masculino');
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Otro'),
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
              prefixIcon: Icons.female,
              suffixIcon: Container(
                  decoration: BoxDecoration(
                    color: Styles.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.white,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextInput(
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
                    suffixIcon: Container(
                      decoration: BoxDecoration(
                        color: Styles.primaryColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Colors.white,
                      ),
                    ),
                    prefixIcon: Icons.location_city,
                    label: 'Pais',
                    errorMessage: state.countryInputValidator.errorMessage,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextInput(
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
              onChanged: (password) =>
                  context.read<SignUpBloc>().add(PasswordChanged(password)),
              errorMessage: state.passwordInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              suffixIcon: Container(
                  decoration: BoxDecoration(
                    color: Styles.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.white,
                  )),
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
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.height * 2,
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
              prefixIcon: Icons.cake,
              isAnimated: FloatingLabelBehavior.never,
              controller: _birthDateController,
              errorMessage: state.birthDateInputValidator.errorMessage,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: signUpBloc.state.isValid
                        ? () async {
                            final user = UserAria(
                              nameUser: nameUser.value,
                              lastName: lastName.value,
                              email: email.value,
                              password: password.value,
                              gender: _genderController.text,
                              country: _countryController.text,
                              city: country.value,
                              nickname: nickname.value,
                              dateBirth: DateTime.parse(DateFormat('yyyy-MM-dd')
                                  .format(DateTime.parse(birthDate.value))),
                            );
                            await usersRepository.signUpUser(user);
                            print('nice');
                          }
                        : null,
                    child: const Text(
                      'Registrace',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )))
          ],
        );
      },
    );
  }
}
