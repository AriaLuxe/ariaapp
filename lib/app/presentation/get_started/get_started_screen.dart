import 'package:ariapp/app/presentation/get_started/widgets/get_started_4.dart';
import 'package:flutter/material.dart';

import '../sign_in/sing_in_screen.dart';
import '../widgets/custom_button.dart';
import 'widgets/get_started_1.dart';
import 'widgets/get_started_2.dart';
import 'widgets/get_started_3.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();


  }

  @override
  void dispose() {
    _pageController.dispose();


    super.dispose();
  }
  void navigateToPage(int page) {
    _pageController.animateToPage(page, duration: const Duration(milliseconds: 500), curve: Curves.slowMiddle);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
allowImplicitScrolling: false,
          controller: _pageController,
        children: [

           GetStarted1(onPress: (){
              navigateToPage(1);
            }),

          GetStarted2(
              onBack:(){
                navigateToPage(0);
              },
              onPress: (){
            navigateToPage(2);
          }),
          GetStarted3(
              onBack:(){
                navigateToPage(1);
              },
              onPress: (){
            navigateToPage(3);
          }),
          GetStarted4(
              onBack:(){
                navigateToPage(2);
              },
              onPress: (){
          }())
        ]
      ),

    );
  }
}
