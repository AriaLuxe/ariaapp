import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/futures/sign_in/bloc/sign_in_bloc.dart';
import 'package:ariapp/app/presentation/futures/sign_in/widgets/sign_in_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: BlocProvider(
        create: (context) => SignInBloc(),
        child: SafeArea(
            child: Column(
          children: [
            Image.asset(
              'assets/images/messi.jpg',
              width: 250,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: SignInForm(),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
