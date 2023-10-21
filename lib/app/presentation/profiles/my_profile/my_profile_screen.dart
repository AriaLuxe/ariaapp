import 'dart:ui';

import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../security/user_logged.dart';

class MyProfileScreen extends StatelessWidget {
   MyProfileScreen({super.key});

  final userLogged = GetIt.instance<UserLogged>();

  @override
  Widget build(BuildContext context)  {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: SizedBox(
              width: screenWidth,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Text('Mi perfil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21)),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: screenWidth * 0.01, // Ancho del borde
                      ),
                    ),
                    child: CircleAvatar(
                      radius: screenHeight * 0.1,
                      backgroundImage: NetworkImage('${BaseUrlConfig.baseUrlImage}9fb85006-81d9-41d9-929b-bd430d31bbe0_profile-lito.jpg'),
                    ),
                  ),
                  Text('Nilton Torres Rojas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21)),
                  Text('LITO', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('${userLogged.user.email}', style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
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
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputa... 🥥😎',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),


                            SizedBox(
                              width: screenWidth*.8,

                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                leading: Icon(Icons.people, color: Colors.white,size: 36,),
                                tileColor: const Color(0xFF354271).withOpacity(0.97),
                                textColor: Colors.white,
                                title: const Text('Suscritos'),
                                subtitle: Text('24k'),
                                trailing: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*.8,
                              child: ListTile(
                                shape: RoundedRectangleBorder( //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                leading: Icon(Icons.cake, color: Colors.white,size: 36,),
                                tileColor: const Color(0xFF354271).withOpacity(0.97),
                                textColor: Colors.white,
                                title: const Text('Cumpleaños'),
                                subtitle: Text('5 de agosto'),
                                trailing: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 24,),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*.8,

                              child: ListTile(
                                shape: RoundedRectangleBorder( //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                leading: Icon(Icons.flag, color: Colors.white,size: 36,),
                                tileColor: const Color(0xFF354271).withOpacity(0.97),
                                textColor: Colors.white,
                                title: const Text('Pais'),
                                subtitle: Text('${userLogged.user.country}'),
                                trailing: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                              ),
                            ),
                  SizedBox(height: screenHeight * 0.05),

                  Container(
                              width: MediaQuery.of(context).size.width*.8,
                              decoration: BoxDecoration(
                              color: Color(0xFF5368d6),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Center(
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
                  SizedBox(height: screenHeight * 0.05),


                ],
                        ),
                      ),
                    ),
                  ],
                ),


    );
  }
}

/*import 'dart:ui';
import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("${BaseUrlConfig.baseUrlImage}9fb85006-81d9-41d9-929b-bd430d31bbe0_profile-lito.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.transparent, Color(0xFF354271)],
                    stops: [0.0, 0.5, 0.5],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle,
                          color: Color(0xFFFFFFFF).withOpacity(0.52),
                        ),
                        child: const Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFFFFF).withOpacity(0.52),
                        ),
                        child: const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            color: const Color(0xFF354271), // Color sólido
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.65,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.network(
                        '${BaseUrlConfig.baseUrlImage}9fb85006-81d9-41d9-929b-bd430d31bbe0_profile-lito.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text('Nilton Torres Rojas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21)),
                  Text('LITO', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFFebebeb).withOpacity(0.26),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputa... 🥥😎',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  // Resto del contenido de la pantalla
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




Container(
                                width: MediaQuery.of(context).size.width*.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Color(0xFFebebeb).withOpacity(0.26)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(

                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputa... 🥥😎',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 35,
                              ),

                              SizedBox(
                                width: MediaQuery.of(context).size.width*.8,

                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  leading: Icon(Icons.people, color: Colors.white,size: 36,),
                                  tileColor: const Color(0xFF354271).withOpacity(0.97),
                                  textColor: Colors.white,
                                  title: const Text('Suscritos'),
                                  subtitle: Text('24k'),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*.8,
                                child: ListTile(
                                  shape: RoundedRectangleBorder( //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  leading: Icon(Icons.cake, color: Colors.white,size: 36,),
                                  tileColor: const Color(0xFF354271).withOpacity(0.97),
                                  textColor: Colors.white,
                                  title: const Text('Cumpleaños'),
                                  subtitle: Text('5 de agosto'),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*.8,

                                child: ListTile(
                                  shape: RoundedRectangleBorder( //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  leading: Icon(Icons.flag, color: Colors.white,size: 36,),
                                  tileColor: const Color(0xFF354271).withOpacity(0.97),
                                  textColor: Colors.white,
                                  title: const Text('Pais'),
                                  subtitle: Text('Perú'),
                                ),
                              ),
 */