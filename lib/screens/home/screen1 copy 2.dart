import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nuestra_historia/controller/auth_controller.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/controller/pareja_controller.dart';
import 'package:nuestra_historia/screens/grupo/codigo_grupo_screen.dart';
import 'package:nuestra_historia/utils/calendar_util.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/dialog.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';
import 'package:nuestra_historia/screens/widgets/widgets.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final fechaController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Future<void> showCalendario(BuildContext context) async {
    final DateTime? picked = await showCalendar(context, selectedDate);
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        fechaController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final mMasterSession = Get.find<MasterSessionController>();
    final parejaController = Get.put(ParejaController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => CardHeader(
                usuario: mMasterSession.currentUsuario.value,
                pareja: mMasterSession.currentUsuarioPareja.value,
                relacion: mMasterSession.currentRelacion.value,
                ontap2: () {
                  if (mMasterSession.currentUsuarioPareja.value.id == "") {
                    Get.to(() => const CodigoGrupoScreen());
                  } else {
                    customDialogWidgtes(
                        "Aniversario", "Cuando es su aniverasrio ", [
                      CustomTextField(
                        colorFondo: Colors.white.withOpacity(0.3),
                        fuente: Colors.black,
                        text: DateFormat('dd/MM/yyyy').format(selectedDate),
                        controller: fechaController,
                        enableInput: false,
                        onTap: () {
                          showCalendario(context);
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomButton(
                        text: "GUARDAR",
                        onPressed: () {
                          parejaController.guardarAniversario(
                              mMasterSession.currentUsuario.value.relacionId!,
                              DateFormat('dd/MM/yyyy').format(selectedDate));
                        },
                      )
                    ]);
                  }
                },
              ),
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
