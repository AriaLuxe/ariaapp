import 'package:ariapp/app/presentation/profiles/my_profile/profile_image/update_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/custom_button_blue.dart';
import '../../../widgets/header.dart';
import '../bloc/profile_bloc.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: SizedBox(
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.9,
                        child: Header(
                          title: 'Foto de Perfil',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.45,
                        child: Image.network(
                          'https://uploadsaria.blob.core.windows.net/files/${state.urlProfile}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.13,
                      ),
                      SizedBox(
                          width: size.width * 0.6,
                          child: CustomButtonBlue(
                              text: 'Editar',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateImage(
                                              urlPhoto:
                                                  'https://uploadsaria.blob.core.windows.net/files/${state.urlProfile}',
                                            )));
                              },
                              width: 0.8))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} /**/
