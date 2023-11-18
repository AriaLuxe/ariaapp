import 'package:ariapp/app/infrastructure/data_sources/email_validation_data_provider.dart';
import 'package:ariapp/app/presentation/chats/chats_screen.dart';
import 'package:ariapp/app/presentation/get_started/get_started_screen.dart';
import 'package:ariapp/app/presentation/sign_up/widgets/verify_code.dart';
import 'package:ariapp/app/presentation/widgets/arrow_back.dart';
import 'package:ariapp/app/presentation/widgets/custom_button.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:ariapp/app/security/sign_in_service.dart';
import 'package:ariapp/injections.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../config/styles.dart';
import '../../../infrastructure/repositories/user_aria_repository.dart';
import '../../layouts/layout.dart';
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



  bool _obscureText = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final  errorSnackBar = const SnackBar(
      backgroundColor: Colors.red,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error,size: 60,),
            Column(
              children: [

                Text('Verifique su correo', style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),
              ],
            ),
          ],
        ),
      )

  );

  final  credentialsSnackBar = const SnackBar(
      backgroundColor: Colors.red,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error,size: 60,),
            Column(
              children: [

                Text('Credenciales incorrectos', style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),
              ],
            ),
          ],
        ),
      )

  );

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
                  child: ArrowBack(onTap: (){
                    bool o = Navigator.canPop(context);

                    if(o){
                      Navigator.pop(context);
                      }else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GetStartedScreen()));

                      null;
                    }
                  },),
                ),
              ),

              Image.asset(
                'assets/images/logo-aia.jpg',
                width: MediaQuery.of(context).size.height * 0.1,
              ),
               Image.asset(
                  'assets/images/aia.jpg',
                  width: MediaQuery.of(context).size.height * 0.15,
                ),

              const Text(
                'Bienvenido',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40
                ),
              ),
               SizedBox(
                height: size.height*0.1,
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
                        onPressed: context.read<SignInBloc>().state.emailInputValidator.isValid ? () async {
                          final emailValidation = EmailValidationDataProvider();
                          final response = await emailValidation.sendEmailToResetPassword(email.text.trim());
                          print('response');
                          print(response);
                          if(response == 'Email sent sucessfully'){
                           // context.goNamed(
                              //  '/verify_code',pathParameters: {'email': email.text.trim(), 'verify': 'Verificar código', 'isResetPassword': 'true'
                               // });

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  VerifyCode(email: email.text.trim(), verify: 'Verificar código', isResetPassword: true)),
                            );
                          }else if(response == 'A code has already been sent'){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VerifyCode(email: email.text.trim(), verify: 'Verificar código', isResetPassword: true)),
                            );
                              //context.goNamed(
                              //  '/verify_code',pathParameters: {'email': email.text.trim(), 'verify': 'Verificar código', 'isResetPassword': 'true'
                            //});

                          }
                          else{
                            ScaffoldMessenger.of(context)
                                .showSnackBar(errorSnackBar)
                                .closed;
                          }

                        } : null,
                        child:  Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: context.read<SignInBloc>().state.emailInputValidator.isValid ? Colors.white : Colors.grey),
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
                child: CustomButton(
                  onPressed: signInBloc.state.isValid
                      ? () async {

                    final signInService = SignInService();
                    final response = await signInService.signIn(email.text, password.text);

                    print(response);

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
                      context.go('/chats');

                       } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(credentialsSnackBar)
                          .closed;
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
                    //context.push('/sign_up');

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
