import 'package:ariapp/app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/sign_in_bloc.dart';
import 'widgets/sign_in_form.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  int backButtonCounter = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Styles.primaryColor,
      body: BlocProvider(
        create: (context) => SignInBloc(),
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SizedBox(
              width: size.width * 1,
              child: const SingleChildScrollView(
                child: SignInForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
