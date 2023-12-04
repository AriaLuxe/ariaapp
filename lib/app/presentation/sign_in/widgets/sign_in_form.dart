import 'package:ariapp/app/infrastructure/data_sources/email_validation_data_provider.dart';
import 'package:ariapp/app/presentation/get_started/get_started_screen.dart';
import 'package:ariapp/app/presentation/sign_up/widgets/verify_code.dart';
import 'package:ariapp/app/presentation/widgets/arrow_back.dart';
import 'package:ariapp/app/presentation/widgets/custom_button.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:ariapp/app/security/sign_in_service.dart';
import 'package:ariapp/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../infrastructure/repositories/user_aria_repository.dart';
import '../../sign_up/sign_up_screen.dart';
import '../bloc/sign_in_bloc.dart';
import 'text_input.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  final usersRepository = GetIt.instance<UserAriaRepository>();


  bool isLoadingSignIn = false;
  bool _obscureText = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final signInBloc = context.watch<SignInBloc>();
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            children: [

               Padding(
                padding:  const EdgeInsets.symmetric( horizontal: 20.0, vertical: 0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ArrowBack(onTap: ()async{
                    await  SharedPreferencesManager.saveHasSeenGetStarted(false);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const GetStartedScreen()));
                  },),
                ),
              ),
              Image.asset(
                'assets/images/tree_oficial.png',
                width: MediaQuery.of(context).size.height * 0.1,
              ),
              SizedBox(
                height: size.height*0.03,
              ),
               Image.asset(
                  'assets/images/aia.png',
                  width: MediaQuery.of(context).size.height * 0.15,
                ),
              SizedBox(
                height: size.height*0.03,
              ),
              const Text(
                'Bienvenido',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40
                ),
              ),
               SizedBox(
                height: size.height*0.03,
              ),
              SizedBox(
                width: size.width*0.85,
                child: TextInput(
                  verticalPadding: 20,

                  controller: email,
                  textInputType: TextInputType.emailAddress,
                  label: 'Correo',
                  prefixIcon: Icons.email,
                  onChanged: (email) =>
                      context.read<SignInBloc>().add(EmailChanged(email)),
                  errorMessage: state.emailInputValidator.errorMessage,
                ),
              ),
              SizedBox(
                height: size.height*0.03,
              ),
              SizedBox(
                width: size.width*0.85,
                child: Column(
                  children: [
                    TextInput(
                      verticalPadding: 20,

                      controller: password,
                      obscureText: _obscureText,
                      label: 'Contraseña',
                      prefixIcon: Icons.lock,
                      onChanged: (password) =>
                          context.read<SignInBloc>().add(PasswordChanged(password)),
                      errorMessage: state.passwordInputValidator.errorMessage,
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
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: /*context.read<SignInBloc>().state.emailInputValidator.isValid ? */() async {
                          final emailValidation = EmailValidationDataProvider();
                          final response = await emailValidation.sendEmailToResetPassword(email.text.trim());
                          print(response);
                          if(response == 'Email sent sucessfully'){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  VerifyCode(email: email.text.trim(), verify: 'Verificar código', isResetPassword: true)),
                            );
                          }else if(response == 'A code has already been sent'){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VerifyCode(email: email.text.trim(), verify: 'Verificar código', isResetPassword: true)),
                            );
                          }else if(response == 'Does not exist an account with this email'){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogAccept(
                                  text: 'No existe una cuenta con este correo, por favor, ingrese nuevamente',
                                  onAccept: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          }
                          else{
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogAccept(
                                  text: 'Ingrese correo electrónico',
                                  onAccept: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          }
                        },
                        child:  Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: /*context.read<SignInBloc>().state.emailInputValidator.isValid ? Colors.white :*/ Colors.white),
                        ),
                      ),

                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height*0.05,
              ),
              SizedBox(
                width: size.width * 0.8,
                child: isLoadingSignIn? const Center(child: CircularProgressIndicator(),)
                    :CustomButton(
                  onPressed: signInBloc.state.isValid
                      ? () async {
                    setState(() {
                      isLoadingSignIn = true;
                    });

                    final signInService = SignInService();
                    final response = await signInService.signIn(email.text, password.text);

                    if (response.containsKey('token')) {
                      final token = response['token'];
                      final decodedToken = JwtDecoder.decode(token);
                      await SharedPreferencesManager.saveToken(token);
                      await SharedPreferencesManager.saveUserId(decodedToken['idUser']);
                      await SharedPreferencesManager.saveEmail(decodedToken['email']);
                      final userId = await SharedPreferencesManager.getUserId();
//                      final userRepository = GetIt.instance<UserAriaRepository>();
                      final user = await usersRepository.getUserById(userId!);
                      userLogged(user);
                      setState(() {
                        isLoadingSignIn = false;
                      });
                      context.go('/chats');

                       } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialogAccept(
                            text: 'Credenciales incorrectos',
                            onAccept: () {
                              setState(() {
                                isLoadingSignIn = false;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                      setState(() {
                        isLoadingSignIn = false;
                      });
                    }
                  }
                      : null,
                  text: 'Iniciar Sesión',
                  width: 0.8,
                ),
              ),

              SizedBox(
                height: size.height*0.1,
              ),
              SizedBox(
                  width: size.width*0.7,
                  child: CustomButton(
                     text: 'Crear cuenta', onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                      builder: (context) => const SignUpScreen()));
          }, width: 0.8,),
                ),


            ],
          ),
        );
      },
    );
  }
}
