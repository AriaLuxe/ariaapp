import 'dart:io';
import 'dart:typed_data';

import 'package:ariapp/app/infrastructure/services/camera_gallery_service.dart';
import 'package:ariapp/app/infrastructure/services/camera_gallery_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../infrastructure/data_sources/users_data_provider.dart';
import '../../../../security/shared_preferences_manager.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/header.dart';
import '../bloc/profile_bloc.dart';
import 'edit_image.dart';

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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: size.width*1,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  SizedBox(
                    width: size.width * 0.9,
                    child: Header(title: 'Foto de Perfil',onTap: (){
                      //context.go("/my_profile");
                     // context.go("/my_profile/profile_image");
                      context.go('/my_profile');
                      },),
                  ),
                  SizedBox(
                    height: size.height*0.1,
                  ),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.45,
                    child: Image.network(
                      widget.urlPhoto,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  Container(
                    width: screenWidth*.7,

                    decoration: BoxDecoration(
                      color: const  Color(0xFFebebeb).withOpacity(0.26),
                      borderRadius: BorderRadius.circular(20)
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 17.0),
                      child: Column(
                        children: [
                           Container(
                             width: screenWidth*.6,
                            height: 60,
                             decoration: BoxDecoration(
                                  color: const Color(0xFF354271).withOpacity(0.97),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: ListTile(

                                  title: const Text('Tomar foto', style: TextStyle(color: Colors.white)),
                                  trailing: const Icon(Icons.add_a_photo, color: Colors.white),
                                  onTap: () async {
                                    final photoPath = await CameraGalleryServiceImpl().takePhoto();
                                    if(photoPath == null){
                                      return;
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditImage(photoPath: photoPath)));
                                    photoPath;
                                    //_imgFromCamera();
                                    //Navigator.pop(context);
                                  },
                                ),
                              ),
                            SizedBox(height: screenHeight * 0.015),
                          Container(
                            width: screenWidth*.6,

                            decoration: BoxDecoration(
                                color: const Color(0xFF354271).withOpacity(0.97),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                title: const Text('Seleccionar Foto', style: TextStyle(color: Colors.white)),
                                trailing: const Icon(Icons.photo_library, color: Colors.white),
                                onTap: () async {
                                 // Map<Permission, PermissionStatus> statuses = await [
                                  //Permission.storage, Permission.camera,
                                 // ].request();
                                  //if(statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted){
                                    //_imgFromGallery();
                                    //Navigator.pop(context);                                  } else {
                                 // print('no permission provided');
                                 final photoPath = await CameraGalleryServiceImpl().selectPhoto();
                                  if(photoPath == null){
                                  return;
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditImage(photoPath: photoPath)));
                                  photoPath;


                                },
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.015),
                           Container(
                             width: screenWidth*.6,

                             decoration: BoxDecoration(
                                color: const Color(0xFF354271).withOpacity(0.97),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                title: const Text('Eliminar foto', style: TextStyle(color: Colors.red)),
                                trailing: const Icon(Icons.delete, color: Colors.red),
                                onTap:() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                        text: '¿Estás seguro que desea eliminar foto?',
                                        onOk: () {
                                          _defaultImage();
                                          Navigator.of(context).pop();
                                        },
                                        onCancel: () {
                                          // Lógica para el botón "No"
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  );
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
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                          child: Column(
                            children: const [
                              Icon(Icons.image, size: 60.0,),
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
                          child: SizedBox(
                            child: Column(
                              children: const [
                                Icon(Icons.camera_alt, size: 60.0,),
                                SizedBox(height: 12.0),
                                Text(
                                  "Camera",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
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
        }
    );
  }

  _imgFromGallery() async {
    await  picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    ).then((value){
      if(value != null){
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    ).then((value){
      if(value != null){
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
        ] : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [AndroidUiSettings(
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

    final assetImagePath = 'assets/images/profile-default.png';

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    String targetPath = '$tempPath/image-profile.png';

    await copyAssetToFile(assetImagePath, targetPath);

    final userDataProvider = UsersDataProvider();
    final response = await userDataProvider.updateUserImageProfile(userId!, File(targetPath));

    if (response == 'imgProfile is updated') {
      context.read<ProfileBloc>().fetchDataProfile(userId);
      context.go('/my_profile');
    } else {
      print('Error al establecer la imagen predeterminada');
    }
  }

}




