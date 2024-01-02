import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/screens/login/register_data_screen.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/dialog.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';

class RegisterPasswordScreen extends StatefulWidget {
  const RegisterPasswordScreen({super.key});

  @override
  State<RegisterPasswordScreen> createState() => _RegisterPasswordScreenState();
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  final mMasterSession = Get.find<MasterSessionController>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isEightCharacters = false.obs;
  final hasUppercaseLetter = false.obs;
  final hasSpecialCharacter = false.obs;
  final hasNumber = false.obs;
  @override
  Widget build(BuildContext context) {
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
            CustomPasswordTextField(
                controller: passwordController,
                text: 'Contraseña',
                prefixIcon: Icons.password,
                onchange: (value) {
                  isEightCharacters(value.length >= 8);
                  hasSpecialCharacter(
                    RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value),
                  );
                  hasNumber(
                    RegExp(r'[0-9]').hasMatch(value),
                  );
                  hasUppercaseLetter(
                    RegExp(r'[A-Z]').hasMatch(value),
                  );
                }),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Obx(() => Text(
                          "Mas de 8 caracteres",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: Colors.white,
                            decoration: isEightCharacters.value
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        )),
                    Obx(() => Text(
                          "Letra en mayúsculas",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: Colors.white,
                            decoration: hasUppercaseLetter.value
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Obx(
                      () => Text(
                        "Caracter especial",
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Colors.white,
                          decoration: hasSpecialCharacter.value
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    Obx(() => Text(
                          "Caracter numérico",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: Colors.white,
                            decoration: hasNumber.value
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ))
                  ],
                )
              ],
            ),
            CustomPasswordTextField(
              controller: confirmPasswordController,
              text: 'Confirma tu contraseña',
              prefixIcon: Icons.password,
            ),
            SizedBox(
              width: Get.width * 0.7,
              child: CustomButton(
                text: 'SIGUIENTE',
                onPressed: () {
                  if (passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    customDialogFailed(
                        "Error", "Todos los campos son obligatorios");
                  } else if (isEightCharacters.isFalse ||
                      hasNumber.isFalse ||
                      hasSpecialCharacter.isFalse ||
                      hasUppercaseLetter.isFalse) {
                    customDialogFailed("Error",
                        "La contraseña no cumple con los requisitos de seguridad");
                  } else if (passwordController.text !=
                      confirmPasswordController.text) {
                    customDialogFailed(
                        "Error", "Las contraseñas ingresadas no coinciden");
                  } else {
                    mMasterSession.currentUsuarioTemp.update((val) {
                      val?.password = passwordController.text.toString();
                      val?.confirmPassword =
                          confirmPasswordController.text.toString();
                    });
                    Get.to(() => RegisterDataScreen());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
