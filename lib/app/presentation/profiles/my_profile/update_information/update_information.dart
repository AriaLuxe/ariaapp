import 'package:ariapp/app/presentation/profiles/my_profile/bloc/my_profile_bloc.dart';
import 'package:ariapp/app/presentation/widgets/header.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
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
import '../../../../security/user_logged.dart';
import '../../../../security/user_logged.dart';
import '../../../sign_in/widgets/text_input.dart';
import '../../../widgets/arrow_back.dart';
import '../../../widgets/custom_button.dart';

class UpdateInformation extends StatelessWidget {
  const UpdateInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => MyProfileBloc(),
  child: Center(
    child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,

        child: const UpdateInformationForm()),
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
  final userLogged = GetIt.instance<UserLogged>();


  @override
  void initState()  {
    loadUserData();
    super.initState();
  }

  void loadUserData()  {

    _birthDateController.text =
        DateFormat('yyyy-MM-dd').format(userLogged.user.dateBirth!);
    //_birthDateController.text = '${userLogged.user.dateBirth?.year}-${userLogged.user.dateBirth?.month}-${userLogged.user.dateBirth?.day}';
    _genderController.text = userLogged.user.gender;
    _countryController.text = userLogged.user.country;
    _nameController.text = userLogged.user.nameUser;
    _lastNameController.text = userLogged.user.lastName;
    _nicknameController.text = userLogged.user.nickname;
    _cityController.text = userLogged.user.city;


  }

  bool hasChanged(){
    if (_nameController.text != userLogged.user.nameUser ||
        _lastNameController.text != userLogged.user.lastName ||
        _nicknameController.text != userLogged.user.nickname ||
        _genderController.text != userLogged.user.gender ||
        _countryController.text != userLogged.user.country ||
        _cityController.text != userLogged.user.city ||
        _birthDateController.text !=
            DateFormat('yyyy-MM-dd').format(userLogged.user.dateBirth!)) {
      return true;
    }else{
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


  @override
  Widget build(BuildContext context) {

    print(_birthDateController.text);

    hasChanged();
    final myProfileBloc = context.watch<MyProfileBloc>();
    myProfileBloc.add(NameChanged(_nameController.text));
    myProfileBloc.add(LastNameChanged(_lastNameController.text));
    myProfileBloc.add(NicknameChanged(_nicknameController.text));
    myProfileBloc.add(GenderChanged(_genderController.text));
    myProfileBloc.add(BirthDateChanged(_birthDateController.text));
    myProfileBloc.add(CountryChanged(_countryController.text));
    myProfileBloc.add(CityChanged(_cityController.text));
    final nameUser = myProfileBloc.state.nameInputValidator;
    final lastName = myProfileBloc.state.lastNameInputValidator;
    final nickname = myProfileBloc.state.nicknameInputValidator;
    final country = myProfileBloc.state.countryInputValidator;

    final birthDate = myProfileBloc.state.birthDateInputValidator;

    Size size = MediaQuery.of(context).size;

    return BlocBuilder<MyProfileBloc, MyProfileState>(
  builder: (context, state) {
    print(state.isValid);
    return Scaffold(
      body: SingleChildScrollView(
        child:  SafeArea(
          child: Column(

              children: [
                const Header(title: 'Actualizar'),

                 SizedBox(
                  height: size.height*0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text('Nombres',style: TextStyle(color: Colors.white),),
                    TextInput(
                      controller: _nameController,
                      verticalPadding: 15,
                      prefixIcon: Icons.person,
                      label: 'Ingresa tus nombres',
                      onChanged: (name) =>
                          context.read<MyProfileBloc>().add(NameChanged(name)),
                      errorMessage: state.nameInputValidator.errorMessage,
                    ),
                  ],
                ),
                 SizedBox(
                  height: size.height*0.015,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text('Apellidos',style: TextStyle(color: Colors.white),),

                    TextInput(
                      controller: _lastNameController,

                      verticalPadding: 15,

                      prefixIcon: Icons.person,
                      label: 'Ingresa tus apellidos',
                      onChanged: (lastName) =>
                          context.read<MyProfileBloc>().add(LastNameChanged(lastName)),
                      errorMessage: state.lastNameInputValidator.errorMessage,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height*0.015,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text('Apodo',style: TextStyle(color: Colors.white),),

                    TextInput(
                      controller: _nicknameController,

                      verticalPadding: 15,

                      prefixIcon: Icons.verified_user,
                      label: 'Ingresa tu nickname',
                      onChanged: (nickname) =>
                          context.read<MyProfileBloc>().add(NicknameChanged(nickname)),
                      errorMessage: state.nicknameInputValidator.errorMessage,
                    ),
                  ],
                ),




                SizedBox(
                  height: size.height*0.015,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text('Genero',style: TextStyle(color: Colors.white),),

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
                      prefixIcon: Icons.circle_outlined,

                    ),
                  ],
                ),
            SizedBox(
              height: size.height*0.015,
            ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text('Fecha de nacimiento',style: TextStyle(color: Colors.white),),

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
                                    context.read<MyProfileBloc>().add(
                                        BirthDateChanged(_birthDateController.text));

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
                      errorMessage: state.birthDateInputValidator.errorMessage,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height*0.015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text('Pais',style: TextStyle(color: Colors.white),),

                          TextInput(
                            verticalPadding: 15,

                            controller: _countryController,
                            readOnly: true,
                            onTap: () {
                              context
                                  .read<MyProfileBloc>()
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
                                        .read<MyProfileBloc>()
                                        .add(CountryChanged(_countryController.text));
                                  });
                            },

                            prefixIcon: Icons.flag,
                            label: 'Pais',
                            errorMessage: state.countryInputValidator.errorMessage,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ciudad',style: TextStyle(color: Colors.white),),

                          TextInput(
                            verticalPadding: 15,
                            controller: _cityController,

                            prefixIcon: Icons.location_on,
                            label: 'Ciudad',
                            onChanged: (city) =>
                                context.read<MyProfileBloc>().add(CityChanged(city)),
                            errorMessage: state.cityInputValidator.errorMessage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


                SizedBox(
                  height: size.height*0.06,
                ),
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: hasChanged() && myProfileBloc.state.isValid ?
                          () async{
                      final userRepository = GetIt.instance<UserAriaRepository>();
                       // final response = await userRepository.updateUserData(userLogged.user.id.toString(),_nameController.text,_lastNameController.text,_nicknameController.text,_genderController.text,_birthDateController.text,_countryController.text,_cityController.text);
                      print('entreeeeeeeeeeeee');

                      print(_birthDateController.text);

                      _birthDateController.clear();
                        _genderController.clear();
                        _countryController.clear();
                        _nameController.clear();
                        _lastNameController.clear();
                        _nicknameController.clear();
                        _cityController.clear();
                            // if(response == 'Email sent sucessfully'){

                        //  Navigator.push(context, MaterialPageRoute(builder: (context) =>  VerifyCode(email: email.value.trim(),verify: 'Verificar y Registrarse', isResetPassword: false,user: user)));

                       // }else{
                        //  ScaffoldMessenger.of(context)
                            //  .showSnackBar(errorSnackBar)
                              //.closed;
                       // }

                      } : null,
                      text: 'Guardar Cambios ', width: 0.8,))


              ],
            ),
        ),

      ),
      );
  },
);
  }
}
