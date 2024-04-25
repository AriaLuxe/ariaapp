import 'dart:developer';
import 'dart:io';

import 'package:ariapp/app/config/helpers/custom_dialogs.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/infrastructure/services/camera_gallery_service_impl.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/bloc/profile_bloc.dart';
import 'package:ariapp/app/presentation/profiles/my_profile/profile_image/edit_image.dart';
import 'package:ariapp/app/presentation/widgets/header.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UpdateImage extends StatefulWidget {
  const UpdateImage({super.key, required this.urlPhoto});

  final String urlPhoto;

  @override
  State<UpdateImage> createState() => _UpdateImageState();
}

class _UpdateImageState extends State<UpdateImage> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: size.width * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.9,
                    child: Header(
                      title: 'Foto de Perfil',
                      onTap: () {
                        context.go('/my_profile');
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
                      widget.urlPhoto,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    width: size.width * .7,
                    decoration: BoxDecoration(
                        color: const Color(0xFFebebeb).withOpacity(0.26),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 17.0),
                      child: Column(
                        children: [
                          Container(
                            width: size.width * .6,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF354271).withOpacity(0.97),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ListTile(
                              title: const Text('Tomar foto',
                                  style: TextStyle(color: Colors.white)),
                              trailing: const Icon(Icons.add_a_photo,
                                  color: Colors.white),
                              onTap: () async {
                                final photoPath =
                                    await CameraGalleryServiceImpl()
                                        .takePhoto();
                                if (photoPath == null) {
                                  return;
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditImage(photoPath: photoPath)));
                                photoPath;
                                //_imgFromCamera();
                                //Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          Container(
                            width: size.width * .6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF354271).withOpacity(0.97),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ListTile(
                              title: const Text('Seleccionar Foto',
                                  style: TextStyle(color: Colors.white)),
                              trailing: const Icon(Icons.photo_library,
                                  color: Colors.white),
                              onTap: () async {
                                final photoPath =
                                    await CameraGalleryServiceImpl()
                                        .selectPhoto();
                                if (photoPath == null) {
                                  return;
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditImage(photoPath: photoPath)));
                                photoPath;
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          Container(
                            width: size.width * .6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF354271).withOpacity(0.97),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ListTile(
                              title: const Text('Eliminar foto',
                                  style: TextStyle(color: Colors.red)),
                              trailing:
                                  const Icon(Icons.delete, color: Colors.red),
                              onTap: () {
                                CustomDialogs().showCustomDialog(
                                    context: context,
                                    text:
                                        '¿Estás seguro que desea eliminar foto?',
                                    onOk: () {
                                      _defaultImage();
                                      Navigator.of(context).pop();
                                    },
                                    onCancel: () {
                                      Navigator.pop(context);
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: size.width,
                height: size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: const Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 60.0,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
      });
      // reload();
    }
  }

  Future<File> copyAssetToFile(String assetPath, String targetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    final File file = File(targetPath);
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _defaultImage() async {
    final userId = await SharedPreferencesManager.getUserId();

    const assetImagePath = 'assets/images/profile-default.png';

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    String targetPath = '$tempPath/image-profile.png';

    await copyAssetToFile(assetImagePath, targetPath);

    final usersRepository = GetIt.instance<UserAriaRepository>();
    final response =
        await usersRepository.updateUserImageProfile(userId!, File(targetPath));

    if (response == 'imgProfile is updated') {
      context.read<ProfileBloc>().fetchDataProfile(userId);
      context.go('/my_profile');
    } else {
      log('Error al establecer la imagen predeterminada');
    }
  }
}
