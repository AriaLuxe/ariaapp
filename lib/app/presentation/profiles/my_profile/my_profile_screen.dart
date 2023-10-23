import 'dart:ui';

import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/widgets/my_profile_option.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../security/user_logged.dart';
import 'update_information/update_information.dart';

class MyProfileScreen extends StatelessWidget {
   MyProfileScreen({super.key});

  final userLogged = GetIt.instance<UserLogged>();

  @override
  Widget build(BuildContext context)  {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04),
              const Text('Mi perfil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21)),
              Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: screenWidth * 0.01,
                  ),
                ),
                child: CircleAvatar(
                  radius: screenHeight * 0.06,
                  backgroundImage: NetworkImage('${BaseUrlConfig.baseUrlImage}9fb85006-81d9-41d9-929b-bd430d31bbe0_profile-lito.jpg'),
                ),
              ),
              Text('${userLogged.user.nameUser} ${userLogged.user.lastName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21)),
              Text('${userLogged.user.email}', style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: screenWidth*.8,
                height: screenHeight*0.1,

                child: ListTile(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  tileColor: const  Color(0xFFebebeb).withOpacity(0.26),
                  textColor: Colors.white,
                  title: userLogged.user.state!.isEmpty ? const Text(
                    textAlign: TextAlign.center,
                    'Agrega un estado',style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),):Text(userLogged.user.state.toString()),
                  trailing: const Icon(Icons.arrow_forward_ios,color: Colors.white,),
                  onTap: (){
                    context.go("/my_profile/update_state");

                  },
                ),
              ),
             /* Container(
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenHeight * 0.025),
                  color: Color(0xFFebebeb).withOpacity(0.26),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.5,
                          child: Text(
                            maxLines: 3,
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputa...',
                            style: TextStyle(

                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),*/
              SizedBox(height: screenHeight * 0.02),


                        SizedBox(
                          width: screenWidth*.8,

                          child:  MyProfileOption(icon: Icons.person_search, title: 'Mi informacion', onTap: () {
                            context.go("/my_profile/my_information");

                          },)
                        ),
              SizedBox(height: screenHeight * 0.02),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*.8,
                          child:  MyProfileOption(icon: Icons.lock, title: 'Cambiar contraseña', onTap: () {
                            context.go("/my_profile/update_password");

                          },)
                        ),
              SizedBox(height: screenHeight * 0.02),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*.8,

                          child: MyProfileOption(icon: Icons.person_search, title: 'Cambiar correo', onTap: () {
                            context.go("/my_profile/update_email");

                          },)
                        ),
              SizedBox(height: screenHeight * 0.03),

              Container(
                          width: MediaQuery.of(context).size.width*.8,
                          decoration: BoxDecoration(
                          color: Color(0xFF5368d6),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          child: const Center(
                            child: Text(
                              'Cerrar sesión',
                              style:  TextStyle(
                                color:  Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
              SizedBox(height: screenHeight * 0.03),


            ],
                    ),
                  ),
                ),


    );
  }
}

