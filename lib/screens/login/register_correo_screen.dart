import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/screens/login/register_password_screen.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/dialog.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';

class RegisterCorreoScreen extends StatelessWidget {
  const RegisterCorreoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final mMasterSession = Get.find<MasterSessionController>();
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
                CustomTextField(
                  controller: mailController,
                  text: 'Correo Electronico',
                  prefixIcon: Icons.mail,
                ),
                SizedBox(
                  width: Get.width * 0.7,
                  child: CustomButton(
                    text: 'SIGUIENTE',
                    onPressed: () async {
                      if (mailController.text.isEmpty) {
                        customDialogFailed("Error",
                            "El campo correo electrónico es obligatorio");
                      } else {
                        mMasterSession.currentUsuarioTemp.update((val) {
                          val?.correo = mailController.text.toString();
                        });
                        Get.to(() => RegisterPasswordScreen());
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    ));
  }
}
