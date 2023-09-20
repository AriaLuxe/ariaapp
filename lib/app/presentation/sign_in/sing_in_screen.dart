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
              width: MediaQuery.of(context).size.height * 0.2,
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
