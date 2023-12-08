import 'package:ariapp/app/presentation/widgets/header.dart';
import 'package:ariapp/app/security/user_logged.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/repositories/user_aria_repository.dart';
import '../../../sign_in/widgets/text_input.dart';
import '../../../widgets/custom_button.dart';
import '../update_information/bloc/my_profile_bloc.dart';




class MyInformation extends StatefulWidget {
  const MyInformation({super.key});

  @override
  State<MyInformation> createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  final usersRepository = GetIt.instance<UserAriaRepository>();

  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();


  @override
  void initState()  {
    loadUserData();
    super.initState();
  }

  void loadUserData()  {
    final userLogged = GetIt.instance<UserLogged>();

    _birthDateController.text = '${userLogged.user.dateBirth?.year}-${userLogged.user.dateBirth?.month}-${userLogged.user.dateBirth?.day}';
    _genderController.text = userLogged.user.gender;
    _countryController.text = userLogged.user.country;
    _nameController.text = userLogged.user.nameUser;
    _lastNameController.text = userLogged.user.lastName;
    _nicknameController.text = userLogged.user.nickname;
    _cityController.text = userLogged.user.city;
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



    Size size = MediaQuery.of(context).size;


        return Scaffold(
          body: SingleChildScrollView(
            child:  SafeArea(
              child: Center(
                child: SizedBox(
                  width: size.width*0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height*0.02,
                      ),
                      Header(title: 'Mi información',onTap: (){
                        Navigator.pop(context);
                      },),

                      SizedBox(
                        height: size.height*0.06,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text('Nombres',style: TextStyle(color: Colors.white),),
                          TextInput(
                            readOnly: true,
                            controller: _nameController,
                            verticalPadding: 15,
                            prefixIcon: Icons.person,
                            label: 'Ingresa tus nombres',

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
                            readOnly: true,

                            controller: _lastNameController,

                            verticalPadding: 15,

                            prefixIcon: Icons.person,
                            label: 'Ingresa tus apellidos',

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
                            readOnly: true,
                            controller: _nicknameController,

                            verticalPadding: 15,

                            prefixIcon: Icons.verified_user,
                            label: 'Ingresa tu nickname',

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

                            enabled: true,
                            label: 'Fecha de nacimiento',
                            prefixIcon: Icons.calendar_month,
                            isAnimated: FloatingLabelBehavior.never,
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


                                  prefixIcon: Icons.flag,
                                  label: 'Pais',
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
                                  readOnly: true,
                                  verticalPadding: 15,
                                  controller: _cityController,

                                  prefixIcon: Icons.location_on,
                                  label: 'Ciudad',

                                ),
                              ],
                            ),
                          ),
                        ],
                      ),


                      SizedBox(
                        height: size.height*0.04,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressed: //signUpBloc.state.isValid
                                () {
                                  context.go("/my_profile/update_information");
                              /*  final emailValidation = EmailValidationDataProvider();
                            final response = await emailValidation.sendEmailToRegisterUser(email.value);
                            if(response == 'Email sent sucessfully'){
                              final user = UserAria(
                                  nameUser: nameUser.value.trim(),
                                  lastName: lastName.value.trim(),
                                  email: email.value.trim(),
                                  password: password.value,
                                  gender: _genderController.text.trim(),
                                  country: _countryController.text.trim(),
                                  city: country.value.trim(),
                                  nickname: nickname.value.trim(),
                                  dateBirth: DateTime.parse(DateFormat('yyyy-MM-dd')
                                      .format(DateTime.parse(birthDate.value))),
                                  role: 'USER'
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  VerifyCode(email: email.value.trim(),verify: 'Verificar y Registrarse', isResetPassword: false,user: user)));

                            }else{
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(errorSnackBar)
                                  .closed;
                            }
*/
                            },
                            //: null,
                            text: 'Actualizar', width: 0.8,))


                    ],
                  ),
                ),
              ),
            ),

          ),
        );

  }
}
