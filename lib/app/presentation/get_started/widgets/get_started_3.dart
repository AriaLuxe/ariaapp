import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';

class GetStarted3 extends StatefulWidget {
  const GetStarted3({Key? key, this.onPress, this.onBack}) : super(key: key);

  final dynamic onPress;
  final dynamic onBack;

  @override
  State<GetStarted3> createState() => _GetStarted3State();
}

class _GetStarted3State extends State<GetStarted3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/start-2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.77),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      const Text(
                        'Imagina Controla y Transforma el mundo!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'El futuro es ahora',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: widget.onBack,
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      const Color(0xFFFFFFFF).withOpacity(0.52),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 4
                                          // Color del borde blanco
                                          ),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: CustomButton(
                                    text: 'Siguiente',
                                    onPressed: widget.onPress,
                                    width: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Resto de tu contenido
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
