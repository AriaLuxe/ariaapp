import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';

class GetStarted1 extends StatelessWidget {
  const GetStarted1({Key? key, required this.onPress,}) : super(key: key);
  final dynamic onPress;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.1,
                  child: Image.asset(
                    'assets/images/logo-aia.jpg',
                    key: const ValueKey<String>('assets/images/logo-aia.jpg'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.08,
                  child: Image.asset(
                    'assets/images/aia.jpg',
                    key: const ValueKey<String>('assets/images/aia.jpg'),
                  ),
                ),
              ],
            ),
          ),

        SizedBox(
            width: size.width*0.8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: CustomButton(text: 'Comenzar', onPressed: onPress, width: 0.8),
            )),

        ],
      ),
    );
  }
}
