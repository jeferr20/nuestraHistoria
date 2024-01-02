import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/controller/auth_controller.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/widgets.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final mMasterSession = Get.find<MasterSessionController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => CardHeader(usuario: mMasterSession.currentUsuario.value),
            ),
            CustomButton(
              text: 'Cerrar',
              onPressed: () {
                authController.logOut();
              },
            ),
          ],
        )),
      ),
    );
  }
}
