import 'package:flutter/material.dart';
import '../../sign_in/sing_in_screen.dart';
import '../../widgets/custom_button.dart';

class GetStarted4 extends StatefulWidget {
  const GetStarted4({Key? key, this.onPress, this.onBack});
final dynamic onPress;
  final dynamic onBack;

  @override
  State<GetStarted4> createState() => _GetStarted4State();
}

class _GetStarted4State extends State<GetStarted4> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Inicia la animación cuando se carga el widget
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

    return  Scaffold(
      body: Container(
        width: size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/start-3.jpg'),
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
                              'Chatea con tu personaje favorito',
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
                              '¡Escucha su voz en tiempo real!',
                              style: TextStyle(
                                fontSize: 24,
                              ),
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
                                      decoration:  BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFFFFFFF).withOpacity(0.52),                                      ),
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
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 4
// Color del borde blanco
                                        ),
                                        borderRadius: BorderRadius.circular(30.0), // Bordes circulares
                                      ),
                                      child: CustomButton(text: 'Comenzar', onPressed: (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => const SignInScreen()));

                                      }, width: 0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Resto de tu contenido
                          ],
                        ),
                      ),),

            ],
          ),
        ),
      ),
    );
  }
}




