import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuestra_historia/screens/login/register_correo_screen.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';

import '../../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();
    final authController = Get.find<AuthController>();
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: Get.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffbfe9ff), Color(0xffff6e7f)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: Get.width * 0.65,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Image.asset('assets/logo.png'),
              ),
              // const SizedBox(
              //   height: 32,
              // ),
              SizedBox(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: mailController,
                      text: 'Correo Electronico',
                      prefixIcon: Icons.mail,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomPasswordTextField(
                      controller: passwordController,
                      text: 'Contraseña',
                      prefixIcon: Icons.password_sharp,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            "Olvidé mi contraseña",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: Get.width * 0.7,
                      child: CustomButton(
                        text: 'INGRESAR',
                        onPressed: () {
                          authController.loginUsuario(
                              mailController.text.toString(),
                              passwordController.text.toString());
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: Get.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "O ingresa usando",
                            style: GoogleFonts.roboto(
                                fontSize: 15, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: CustomRoundedIconButtonGoogle(
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: CustomRoundedIconButtonFacebook(
                            onPressed: () {},
                          ),
                        ),
                        // if (GetPlatform.isIOS)
                        const SizedBox(
                          width: 10,
                        ),
                        // if (GetPlatform.isIOS)
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: CustomRoundedIconButtonApple(
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                        text: TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => const RegisterCorreoScreen());
                              },
                            text: '¿Aún no estas registrado? ',
                            style: GoogleFonts.roboto(
                                fontSize: 15, color: Colors.white),
                            children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const RegisterCorreoScreen());
                                },
                              text: ' Registrate aqui',
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700))
                        ]))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
