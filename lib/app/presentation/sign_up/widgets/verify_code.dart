import 'package:ariapp/app/infrastructure/data_sources/email_validation_data_provider.dart';
import 'package:ariapp/app/presentation/sign_in/sing_in_screen.dart';
import 'package:ariapp/app/presentation/sign_up/widgets/reset_password.dart';
import 'package:ariapp/app/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../../../domain/entities/user_aria.dart';
import '../../../infrastructure/repositories/user_aria_repository.dart';
import '../../widgets/code_input.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({Key? key, required this.email,required this.verify, required this.isResetPassword, this.user}) : super(key: key);
  final String email;
  final String verify;
  final bool isResetPassword;
  final UserAria? user;
  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  late int countdown;
  late Timer timer;
  bool isResendButtonEnabled = false;
  bool isCountdownVisible = true;
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    countdown = 120;
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          isResendButtonEnabled = true;
          isCountdownVisible = false;
        });
      }
    });
  }

  void resetCountdown() {
    setState(() {
      countdown = 120;
      isResendButtonEnabled = false;
      isCountdownVisible = true;
    });
    startCountdown();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatCountdown(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  final usersRepository = GetIt.instance<UserAriaRepository>();

  final  noMatchSnackBar = const SnackBar(
      backgroundColor: Colors.red,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error,size: 60,),
            Column(
              children: [
                Text('Error verifique su codigo', style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),

              ],
            ),
          ],
        ),
      )

  );
  final  successSnackBar = const SnackBar(
      backgroundColor: Colors.green,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user,size: 60,),
            Column(
              children: [
                Text('Estas verificado y registrado', style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),

              ],
            ),
          ],
        ),
      )

  );

  final  notCodeSnackBar = const SnackBar(
      backgroundColor: Colors.orange,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning,size: 60,),
            Column(
              children: [
                Text('Reenvie codigo', style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),
                Text('Tiempo superado', style: TextStyle(color: Colors.white,fontSize: 16,),),
              ],
            ),
          ],
        ),
      )

  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF354271),
                    ),
                    child: const Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading)
              const LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>( Color(0xFF151F42)),
              ),

            SizedBox(
              width: double.infinity,
              height: size.height * 0.08,
              child: Image.asset(
                'assets/images/logo-aia.jpg',
                key: const ValueKey<String>('assets/images/logo-aia.jpg'),
              ),
            ),
            const Spacer(),
            const Text('Verificar código', style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold
            ),),
            const Spacer(),
            SizedBox(
              width: size.width * 0.6,
              child:  const Text(
                'Por favor, ingresar el código de 6 dígitos que se ha enviado a su correo electrónico',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontSize: 14
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: size.width * 0.8,
              child:  CodeInput(label: 'Código OTP',controller: _controller,),
            ),
            const Spacer(),
            if (isCountdownVisible)
              Text('El código vence en ${formatCountdown(countdown)}', style: const TextStyle(color: Colors.white)),
            TextButton(
              onPressed: isResendButtonEnabled ? () async{
                resetCountdown();
                final emailValidation = EmailValidationDataProvider();

                if(widget.isResetPassword){
                  print('enviado');
                  await emailValidation.sendEmailToResetPassword(widget.email);
                }else {
                  print('enviado1');
                  await emailValidation.sendEmailToRegisterUser(widget.email);

                }
              } : null,
              child: Text(
                'Reenviar código',
                style: TextStyle(
                  color: isResendButtonEnabled ? const Color(0xFF5368D6) : const   Color(0xFFC0C0C0),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const Spacer(flex: 3,),
            SizedBox(
                width: size.width*0.8,
                child: CustomButton(text: widget.verify, onPressed: isLoading ? null : ()async{
                  print(widget.isResetPassword);
                  if(widget.isResetPassword){

                    final emailValidation = EmailValidationDataProvider();
                    //otro
                    print(widget.email);
                    final response = await emailValidation.verifyCodeToResetPassword(widget.email, _controller.text);

                    if(response == 'Code valid'){
                      setState(()  {
                        isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      setState(()  {
                        isLoading = false;
                      });
                      //context.pushNamed('/reset_password',pathParameters: {'email':widget.email.trim() });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword(email: widget.email.trim(),)));
                      setState(() {
                        isLoading = false;
                      });

                    }else if(response == 'No match code'){
                      setState(()  {
                        isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      setState(()  {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(noMatchSnackBar)
                          .closed;
                    }else if(response == 'There is no code with this email'){
                      setState(()  {
                        isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));

                      setState(()  {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(notCodeSnackBar)
                          .closed;
                    }


                  }else {

                    final emailValidation = EmailValidationDataProvider();
                    final response = await emailValidation.verifyCodeWithEmailToRegisterUser(widget.email, _controller.text);


                    if(response == 'Code valid')
                    {
                      setState(()  {
                        isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      setState(()  {
                        isLoading = false;
                      });

                      final user = UserAria(
                        nameUser: widget.user!.nameUser,
                        lastName: widget.user!.lastName,
                        email: widget.user!.email,
                        password: widget.user!.password,
                        gender: widget.user!.gender,
                        country:widget.user!.country,
                        city: widget.user!.city,
                        nickname: widget.user!.nickname,
                        dateBirth: widget.user!.dateBirth,
                        role: widget.user!.role
                      );
                      await usersRepository.signUpUser(user);
                      print('register');

                      ScaffoldMessenger.of(context)
                          .showSnackBar(successSnackBar)
                          .closed;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    } else if(response == 'No match code'){
                      setState(()  {
                        isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      setState(()  {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(noMatchSnackBar)
                          .closed;
                    }else if(response == 'There is no code with this email'){
                      setState(()  {
                        isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));

                      setState(()  {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(notCodeSnackBar)
                          .closed;
                      setState(() {
                        isLoading = false;
                      });
                    }


                  }


                }, width: 0.5)),


            const Spacer(flex: 5,),
          ],
        ),
      ),
    );
  }
}
