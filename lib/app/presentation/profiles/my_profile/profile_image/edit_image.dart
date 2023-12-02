import 'dart:io';
import 'dart:math';

import 'package:ariapp/app/infrastructure/data_sources/users_data_provider.dart';
import 'package:ariapp/app/presentation/widgets/custom_button.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../config/styles.dart';
import '../../../widgets/custom_button_blue.dart';
import '../bloc/profile_bloc.dart';

class EditImage extends StatefulWidget {
  const EditImage({super.key, required this.photoPath});
  final String photoPath;

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  late CustomImageCropController controller;
  CustomCropShape _currentShape = CustomCropShape.Square;
  CustomImageFit _imageFit = CustomImageFit.fitVisibleSpace;
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  double _width = 16;
  double _height = 9;
  double _radius = 4;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _changeCropShape(CustomCropShape newShape) {
    setState(() {
      _currentShape = newShape;
    });
  }

  void _changeImageFit(CustomImageFit imageFit) {
    setState(() {
      _imageFit = imageFit;
    });
  }

  void _updateRatio() {
    setState(() {
      if (_widthController.text.isNotEmpty) {
        _width = double.tryParse(_widthController.text) ?? 16;
      }
      if (_heightController.text.isNotEmpty) {
        _height = double.tryParse(_heightController.text) ?? 9;
      }
      if (_radiusController.text.isNotEmpty) {
        _radius = double.tryParse(_radiusController.text) ?? 4;
      }
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.7,
                child: CustomImageCrop(
                  backgroundColor: Styles.primaryColor,
                  cropController: controller,
                  image:  FileImage(
                      File(widget.photoPath)),
                  shape: _currentShape,
                  ratio: _currentShape == CustomCropShape.Ratio
                      ? Ratio(width: _width, height: _height)
                      : null,
                  canRotate: true,
                  canMove: true,
                  canScale: true,
                  borderRadius:
                  _currentShape == CustomCropShape.Ratio ? _radius : 0,
                  customProgressIndicator: const CupertinoActivityIndicator(),
                  imageFit: _imageFit,
                  pathPaint: Paint()
                    ..color = Colors.transparent
                    ..strokeWidth = 4.0
                    ..style = PaintingStyle.stroke
                    ..strokeJoin = StrokeJoin.round,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.4,
                    child: CustomButtonBlue(
                        text: 'Cancelar', onPressed: (){
                          Navigator.pop(context);
                    }, width: 0.8,),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.4,
                    child: CustomButtonBlue(
                      text: 'Guardar', onPressed: _saveCroppedImage, width: 0.8,),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _saveCroppedImage() async {
    final croppedImage = await controller.onCropImage();
    if (croppedImage != null) {
      final bytes = croppedImage.bytes;
      final userId = await SharedPreferencesManager.getUserId();
      final directory = await getTemporaryDirectory();
      final fileName = 'imgProfile-$userId.png';

      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);


      final userDataProvider = UsersDataProvider();
      final response = await userDataProvider.updateUserImageProfile(userId!,file);
      if (response == 'imgProfile is updated') {
        print('nice');
       context.read<ProfileBloc>().fetchDataProfile(userId);
        context.go('/my_profile');
      } else {
        print('error');
      }
    }
  }



  Widget getShapeIcon(CustomCropShape shape) {
    switch (shape) {
      case CustomCropShape.Circle:
        return const Icon(Icons.circle_outlined);
      case CustomCropShape.Square:
        return const Icon(Icons.square_outlined);
      case CustomCropShape.Ratio:
        return const Icon(Icons.crop_16_9_outlined);
    }
  }
}

extension CustomImageFitExtension on CustomImageFit {
  String get label {
    switch (this) {
      case CustomImageFit.fillCropSpace:
        return 'Fill crop space';
      case CustomImageFit.fitCropSpace:
        return 'Fit crop space';
      case CustomImageFit.fillCropHeight:
        return 'Fill crop height';
      case CustomImageFit.fillCropWidth:
        return 'Fill crop width';
      case CustomImageFit.fillVisibleSpace:
        return 'Fill visible space';
      case CustomImageFit.fitVisibleSpace:
        return 'Fit visible space';
      case CustomImageFit.fillVisibleHeight:
        return 'Fill visible height';
      case CustomImageFit.fillVisibleWidth:
        return 'Fill visible width';
    }
  }
}
