import 'dart:convert';

import 'package:ariapp/app/presentation/widgets/header.dart';
import 'package:ariapp/app/security/user_logged.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/styles.dart';
import '../../../../infrastructure/repositories/user_aria_repository.dart';
import '../../../sign_in/widgets/text_input.dart';
import '../../../widgets/custom_button.dart';
import '../bloc/profile_bloc.dart';
import 'bloc/my_profile_bloc.dart';

class UpdateInformation extends StatelessWidget {
  const UpdateInformation({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => MyProfileBloc(),
      child: Center(
        child: SizedBox(
            width: size.width * 0.9, child: const UpdateInformationForm()),
      ),
    );
  }
}

class UpdateInformationForm extends StatefulWidget {
  const UpdateInformationForm({super.key});

  @override
  State<UpdateInformationForm> createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformationForm> {
  final usersRepository = GetIt.instance<UserAriaRepository>();

  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final UserLogged userLog = GetIt.instance<UserLogged>();

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  void loadUserData() async {
    _birthDateController.text =
        DateFormat('yyyy-MM-dd').format(userLog.user.dateBirth!);
    _genderController.text = userLog.user.gender;
    _countryController.text = utf8.decode(userLog.user.country.codeUnits);
    _nameController.text = userLog.user.nameUser;
    _lastNameController.text = userLog.user.lastName;
    _nicknameController.text = userLog.user.nickname;
    _cityController.text = userLog.user.city;
  }

  bool hasChanged() {
    if (_nameController.text != userLog.user.nameUser ||
        _lastNameController.text != userLog.user.lastName ||
        _nicknameController.text != userLog.user.nickname ||
        _genderController.text != userLog.user.gender ||
        _countryController.text != userLog.user.country ||
        _cityController.text != userLog.user.city ||
        _birthDateController.text !=
            DateFormat('yyyy-MM-dd').format(userLog.user.dateBirth!)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    _genderController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  List<String> generos = ["Masculino", "Femenino", "Otro"];

  String selectedGenero = "Masculino";

  void onGenderChanged(String newValue) {
    setState(() {
      _genderController.text = newValue;
      context.read<MyProfileBloc>().add(GenderChanged(_genderController.text));
    });
  }

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
                  'Error',
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
                  'Datos actualizados',
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
    hasChanged();
    final myProfileBloc = context.watch<MyProfileBloc>();
    myProfileBloc.add(NameChanged(_nameController.text));
    myProfileBloc.add(LastNameChanged(_lastNameController.text));
    myProfileBloc.add(NicknameChanged(_nicknameController.text));
    myProfileBloc.add(GenderChanged(_genderController.text));
    myProfileBloc.add(BirthDateChanged(_birthDateController.text));
    myProfileBloc.add(CountryChanged(_countryController.text));
    myProfileBloc.add(CityChanged(_cityController.text));
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<MyProfileBloc, MyProfileState>(
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
                    title: 'Actualizar',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nombres',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _nameController,
                        verticalPadding: 15,
                        prefixIcon: Icons.person,
                        label: 'Ingresa tus nombres',
                        onChanged: (name) => context
                            .read<MyProfileBloc>()
                            .add(NameChanged(name)),
                        errorMessage: state.nameInputValidator.errorMessage,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Apellidos',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _lastNameController,
                        verticalPadding: 15,
                        prefixIcon: Icons.person,
                        label: 'Ingresa tus apellidos',
                        onChanged: (lastName) => context
                            .read<MyProfileBloc>()
                            .add(LastNameChanged(lastName)),
                        errorMessage: state.lastNameInputValidator.errorMessage,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  /*Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Apodo',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _nicknameController,
                        verticalPadding: 15,
                        prefixIcon: Icons.verified_user,
                        label: 'Ingresa tu nickname',
                        onChanged: (nickname) => context
                            .read<MyProfileBloc>()
                            .add(NicknameChanged(nickname)),
                        errorMessage: state.nicknameInputValidator.errorMessage,
                      ),
                    ],
                  ),*/
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Género',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _genderController,
                        verticalPadding: 15,
                        errorMessage: state.genderInputValidator.errorMessage,
                        onTap: () {
                          context
                              .read<MyProfileBloc>()
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
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fecha de nacimiento',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextInput(
                        controller: _birthDateController,
                        verticalPadding: 15,
                        readOnly: true,
                        onTap: () {
                          context
                              .read<MyProfileBloc>()
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
                                          DateFormat('yyyy-MM-dd')
                                              .format(newDate);
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      context.read<MyProfileBloc>().add(
                                          BirthDateChanged(
                                              _birthDateController.text));

                                      context.pop();
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
                        errorMessage:
                            state.birthDateInputValidator.errorMessage,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'País',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextInput(
                              verticalPadding: 15,
                              controller: _countryController,
                              readOnly: true,
                              onTap: () {
                                context.read<MyProfileBloc>().add(
                                    CountryChanged(_countryController.text));
                                showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                        const CountryListThemeData(
                                      searchTextStyle: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                      ),
                                    ),
                                    onSelect: (Country country) {
                                      _countryController.text = country.name;
                                      context.read<MyProfileBloc>().add(
                                          CountryChanged(
                                              _countryController.text));
                                    });
                              },
                              prefixIcon: Icons.flag,
                              label: 'Pais',
                              errorMessage:
                                  state.countryInputValidator.errorMessage,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ciudad',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextInput(
                              verticalPadding: 15,
                              controller: _cityController,
                              prefixIcon: Icons.location_on,
                              label: 'Ciudad',
                              onChanged: (city) => context
                                  .read<MyProfileBloc>()
                                  .add(CityChanged(city)),
                              errorMessage:
                                  state.cityInputValidator.errorMessage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: /* hasChanged() && myProfileBloc.state.isValid
                            ?*/
                            () async {
                          final userRepository =
                              GetIt.instance<UserAriaRepository>();
                          final response = await userRepository.updateUserData(
                              userLog.user.id.toString(),
                              _nameController.text,
                              _lastNameController.text,
                              _nicknameController.text,
                              _genderController.text,
                              DateTime.parse(_birthDateController.text),
                              _countryController.text,
                              _cityController.text);
                          final userUpdated = await usersRepository
                              .getUserById(userLog.user.id!);
                          userLog.user = userUpdated;
                          if (response == 'UserInfo is updated') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(successSnackBar)
                                .closed;
                            context
                                .read<ProfileBloc>()
                                .fetchDataProfile(userLog.user.id!);
                            context.go("/my_profile");
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(errorSnackBar)
                                .closed;
                          }
                        } /* : null,*/,
                        text: 'Guardar Cambios ',
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
