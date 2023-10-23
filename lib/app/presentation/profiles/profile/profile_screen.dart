import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../config/base_url_config.dart';
import '../../../config/styles.dart';
import '../../../domain/entities/user_aria.dart';
import '../widgets/settings_option.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen( this.user, {super.key});
  final UserAria? user;
  //final userLogged = GetIt.instance<UserLogged>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              //alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("${BaseUrlConfig.baseUrlImage}${user?.imgProfile}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00000000), // Transparente en la parte superior
                              Color(0xFF151F42), // Color 0xFF151F42 en la parte inferior
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration:  BoxDecoration(
                                  border: Border.all(color: Colors.black,),
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
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),

                                decoration:  BoxDecoration(
                                  border: Border.all(color: Colors.black,),
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFFFFFF).withOpacity(0.52),
                                ),
                                child: const Icon(
                                  Icons.favorite_border_outlined,

                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height*0.35,
                        width: MediaQuery.of(context).size.width*0.6,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(32)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),

                          child: Image.network(
                            '${BaseUrlConfig.baseUrlImage}${user?.imgProfile}',
                            fit: BoxFit.cover, // Puedes usar BoxFit.fill si prefieres llenar el contenedor sin recortar
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      Text('${user?.nameUser} ${user?.lastName}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 21),),

                      Text('${user?.nickname}',style: TextStyle(color: Colors.white,fontSize: 18),),
                      SizedBox(height: 10,),
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
                          subtitle: Text('${user?.country}'),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFFebebeb).withOpacity(0.26)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF354271).withOpacity(0.97),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: ListTile(
                                  title: const Text('Empezar a chatear', style: TextStyle(color: Colors.green)),
                                  trailing: const Icon(Icons.send, color: Colors.green),
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF354271).withOpacity(0.97),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: ListTile(
                                  title: const Text('Bloquear usuario', style: TextStyle(color: Colors.red)),
                                  trailing: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onTap: () {},
                                ),
                              ),

                            ],
                          ),

                        )
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),


      ),
    );
  }
}
