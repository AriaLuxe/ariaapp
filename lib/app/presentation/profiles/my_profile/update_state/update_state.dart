import 'package:ariapp/app/presentation/profiles/my_profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/repositories/user_aria_repository.dart';
import '../../../../security/shared_preferences_manager.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/header.dart';
import 'bloc/update_state_bloc.dart';

class UpdateState extends StatelessWidget {
  const UpdateState({super.key, required this.state});

  final String state;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => UpdateStateBloc(),
      child: Center(
        child: SizedBox(
            width: size.width * 0.9,
            child: UpdateStateForm(
              state: state,
            )),
      ),
    );
  }
}

class UpdateStateForm extends StatefulWidget {
  const UpdateStateForm({super.key, required this.state});

  final String state;

  @override
  State<UpdateStateForm> createState() => _UpdateStateFormState();
}

class _UpdateStateFormState extends State<UpdateStateForm> {
  final TextEditingController _stateController = TextEditingController();

  @override
  void initState() {
    _stateController.text = widget.state;

    super.initState();
  }

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
                  'Estado actualizado',
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
                  'Contraseña incorrecta',
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
    Size size = MediaQuery.of(context).size;
    final updateStateBloc = context.watch<UpdateStateBloc>();

    return BlocBuilder<UpdateStateBloc, UpdateStateState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Header(
                    title: 'Cambiar estado',
                    onTap: () {
                      context.go('/my_profile');
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  SizedBox(
                    height: size.height * 0.15,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      tileColor: const Color(0xFFebebeb).withOpacity(0.26),
                      textColor: Colors.white,
                      title: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _stateController,
                        onChanged: (stateString) => context
                            .read<UpdateStateBloc>()
                            .add(StateChanged(stateString)),
                        cursorColor: Colors.white,
                        maxLines: 4,
                        decoration: InputDecoration(
                          errorText: state.stateInputValidator.errorMessage,
                          border: InputBorder.none,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        context.go("/my_profile/update_state");
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  SizedBox(
                      width: size.width * 0.6,
                      child: CustomButton(
                        onPressed: updateStateBloc.state.isValid
                            ? () async {
                                final userRepository =
                                    GetIt.instance<UserAriaRepository>();
                                final userId =
                                    await SharedPreferencesManager.getUserId();
                                final response =
                                    await userRepository.updateUserState(
                                        userId!, _stateController.text.trim());

                                _stateController.clear();
                                context
                                    .read<ProfileBloc>()
                                    .fetchDataProfile(userId);
                                if (response == 'State is updated') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(successSnackBar)
                                      .closed;
                                  Navigator.pop(context);
                                  //context.go("/my_profile");
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(errorSnackBar)
                                      .closed;
                                }
                              }
                            : null,
                        text: 'Guardar',
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
