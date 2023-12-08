import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import 'animated_text.dart';

class GetStarted2 extends StatelessWidget {
  const GetStarted2({super.key, required this.onPress, this.onBack});

  final dynamic onPress;
  final dynamic onBack;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/start-1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const AnimatedText(
                text:
                    'Explora un mundo donde tus personajes favoritos conversan',
                style: TextStyle(
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 20,
                    ),
                  ],
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: GestureDetector(
                        onTap: onBack,
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFFFFF).withOpacity(0.52),
                          ),
                          child: const Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 4
                              // Color del borde blanco
                              ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: CustomButton(
                            text: 'Descubrir', onPressed: onPress, width: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
