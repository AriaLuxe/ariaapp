import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/repositories/user_aria_repository.dart';
import '../../../../security/shared_preferences_manager.dart';
import '../../../sign_in/widgets/text_input.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/header.dart';
import 'bloc/update_state_bloc.dart';

class UpdateState extends StatelessWidget {
  const UpdateState({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) =>  UpdateStateBloc(),
      child: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: UpdateStateForm()),
      ),
    );
  }
}

class UpdateStateForm extends StatelessWidget {
  UpdateStateForm({super.key});
  final TextEditingController _stateController = TextEditingController();




  final  successSnackBar = const SnackBar(
      backgroundColor: Colors.green,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error,size: 60,),
            Column(
              children: [

                Text('Contraseña actualizada', style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),),
              ],
            ),
          ],
        ),
      )

  );
  final  errorSnackBar = const SnackBar(
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



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final updateStateBloc = context.watch<UpdateStateBloc>();

    return BlocBuilder<UpdateStateBloc, UpdateStateState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child:  SafeArea(
              child: Column(

                children: [
                  const Header(title: 'Cambiar estado'),

                  SizedBox(
                    height: size.height*0.06,
                  ),
                  /*TextInput(
                    controller: _stateController,
                    verticalPadding: 15,
                    prefixIcon: Icons.lock,
                    label: 'Ingresa tu contraseña',
                    onChanged: (stateString) =>
                        context.read<UpdateStateBloc>().add(StateChanged(stateString)),
                    errorMessage: state.stateInputValidator.errorMessage,
                  ),*/
                  SizedBox(
                    height: size.height*0.15,

                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      tileColor: const  Color(0xFFebebeb).withOpacity(0.26),
                      textColor: Colors.white,
                      title: TextFormField(
                        textAlign: TextAlign.center,

                        onChanged: (stateString) =>
                            context.read<UpdateStateBloc>().add(StateChanged(stateString)),
                        cursorColor: Colors.white,
                        maxLines: 4,
                        decoration:  InputDecoration(
                        errorText: state.stateInputValidator.errorMessage,
                          border: InputBorder.none,

                          labelStyle: const TextStyle(color: Colors.white), // Estilo de la etiqueta
                        ),
                        style: const TextStyle(color: Colors.white, ), // Estilo del texto dentro del TextField
                      ),
                      onTap: (){
                        context.go("/my_profile/update_state");

                      },
                    ),
                  ),

                  SizedBox(
                    height: size.height*0.1,
                  ),


                  SizedBox(
                      width: size.width*0.6,
                      child: CustomButton(
                        onPressed:  updateStateBloc.state.isValid ?
                            () async{
                          final userRepository = GetIt.instance<UserAriaRepository>();
                          final userId = await SharedPreferencesManager.getUserId();
                          final response = await userRepository.updateUserState(userId!, _stateController.text.trim());
                          // final response = await userRepository.updateUserData(userLogged.user.id.toString(),_nameController.text,_lastNameController.text,_nicknameController.text,_genderController.text,_birthDateController.text,_countryController.text,_cityController.text);
                          print(response);
                          _stateController.clear();


                          if(response == 'State is updated'){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(successSnackBar)
                                .closed;
                            context.go("/my_profile");


                          }

                          else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(errorSnackBar)
                                .closed;
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
