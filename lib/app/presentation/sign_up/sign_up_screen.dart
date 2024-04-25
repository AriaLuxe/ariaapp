import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/sign_up_bloc.dart';
import 'widgets/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SizedBox(
              width: size.width * 0.9,
              child: const SafeArea(
                  child: SingleChildScrollView(child: SignUpForm())),
            ),
          ),
        ),
      ),
    );
  }
}
