import 'package:ariapp/app/infrastructure/data_sources/email_validation_data_provider.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/presentation/sign_in/sing_in_screen.dart';
import 'package:ariapp/app/presentation/sign_up/widgets/verify_code.dart';
import 'package:ariapp/app/presentation/widgets/arrow_back.dart';
import 'package:ariapp/app/presentation/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
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
  final  errorSnackBar = const SnackBar(
      backgroundColor: Colors.red,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error,size: 60,),
            Column(
              children: [
                Text('Correo invalido', style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),

                Text('Verifique su correo', style: TextStyle(color: Colors.white,fontSize: 16,),),
              ],
            ),
          ],
        ),
      )

  );
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
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   ArrowBack(onTap: (){
                    bool o = Navigator.canPop(context);

                    if(o){
                      Navigator.pop(context);
                    }else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));

                      null;
                    }
                  },),
                  Image.asset('assets/images/logo-aia.jpg',width: 60,),
                ],
              ),
              const Text(
                'Crear cuenta',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white),
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
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
                    width: MediaQuery.of(context).size.width * 0.4,
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
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      onPressed: signUpBloc.state.isValid
                          ? () async{
                        final emailValidation = EmailValidationDataProvider();
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

                      }
                          : null,
                      text: 'Siguiente', width: 0.8,))
                      
                     
            ],
          ),
        );
      },
    );
  }
}
