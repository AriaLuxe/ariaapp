import 'package:ariapp/app/presentation/profiles/my_profile/update_email/bloc/update_email_bloc.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/repositories/user_aria_repository.dart';
import '../../../sign_in/widgets/text_input.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/header.dart';
import '../bloc/profile_bloc.dart';

class UpdateEmail extends StatelessWidget {
  const UpdateEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
  create: (context) => UpdateEmailBloc(),
  child: Center(
    child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: UpdateEmailForm()),
  ),
);
  }
}

class UpdateEmailForm extends StatelessWidget {
   UpdateEmailForm({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   final  incorrectPasswordSnackBar = const SnackBar(
       backgroundColor: Colors.red,
       content: Center(
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.error,size: 60,),
             Column(
               children: [

                 Text('Contraseña incorrecta', style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),
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
             Icon(Icons.error,size: 60,),
             Column(
               children: [

                 Text('Correo actualizado', style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),
               ],
             ),
           ],
         ),
       )

   );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final updateEmailBloc = context.watch<UpdateEmailBloc>();

    return BlocBuilder<UpdateEmailBloc, UpdateEmailState>(
  builder: (context, state) {
    return Scaffold(
      body: SingleChildScrollView(
        child:  SafeArea(
          child: Column(

            children: [
               Header(title: 'Cambiar correo', onTap: (){
                 Navigator.pop(context);

               },),

              SizedBox(
                height: size.height*0.06,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text('Nuevo Correo',style: TextStyle(color: Colors.white),),
                  TextInput(
                    controller: _emailController,
                    verticalPadding: 15,
                    prefixIcon: Icons.email,
                    label: 'Ingresa tu nuevo correo',
                    onChanged: (email) =>
                        context.read<UpdateEmailBloc>().add(EmailChanged(email)),
                    errorMessage: state.emailInputValidator.errorMessage,
                  ),
                ],
              ),
              SizedBox(
                height: size.height*0.05,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text('Contraseña',style: TextStyle(color: Colors.white),),

                  TextInput(
                    controller: _passwordController,

                    verticalPadding: 15,

                    prefixIcon: Icons.lock,
                      label: 'Ingresa tu contraseña',
                    onChanged: (password) =>
                        context.read<UpdateEmailBloc>().add(PasswordChanged(password)),
                    errorMessage: state.passwordInputValidator.errorMessage,
                  ),
                ],
              ),
              SizedBox(
                height: size.height*0.1,
              ),




              SizedBox(
                height: size.height*0.06,
              ),
              SizedBox(
                  width: size.width*0.6,
                  child: CustomButton(
                    onPressed:  updateEmailBloc.state.isValid ?
                        () async{
                      final userRepository = GetIt.instance<UserAriaRepository>();
                      final userId = await SharedPreferencesManager.getUserId();
                      final response = await userRepository.updateEmail(userId!, _emailController.text.trim(), _passwordController.text.trim());
                      // final response = await userRepository.updateUserData(userLogged.user.id.toString(),_nameController.text,_lastNameController.text,_nicknameController.text,_genderController.text,_birthDateController.text,_countryController.text,_cityController.text);
                      print(response);

                      _emailController.clear();
                      _passwordController.clear();

                      if(response == 'Email is updated'){
                        context.read<ProfileBloc>().fetchDataProfile(userId);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(successSnackBar)
                            .closed;
                        context.go("/my_profile");

                        //  Navigator.push(context, MaterialPageRoute(builder: (context) =>  VerifyCode(email: email.value.trim(),verify: 'Verificar y Registrarse', isResetPassword: false,user: user)));

                      // }else{
                      //  ScaffoldMessenger.of(context)
                      //  .showSnackBar(errorSnackBar)
                      //.closed;
                       }
                      if(response == 'Incorrect password'){

                          ScaffoldMessenger.of(context)
                          .showSnackBar(incorrectPasswordSnackBar)
                        .closed;
                      }
                      else {

                      }
                    } : null,
                    text: 'Guardar', width: 0.8,))


            ],
          ),
        ),

      ),
    );
  },
);
  }
}
