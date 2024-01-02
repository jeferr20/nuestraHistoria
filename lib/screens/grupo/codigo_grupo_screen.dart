import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/controller/pareja_controller.dart';
import 'package:nuestra_historia/screens/utils/codigo_grupo.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/dialog.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';

class CodigoGrupoScreen extends StatefulWidget {
  const CodigoGrupoScreen({super.key});

  @override
  State<CodigoGrupoScreen> createState() => _CodigoGrupoScreenState();
}

class _CodigoGrupoScreenState extends State<CodigoGrupoScreen> {
  RxBool haveCode = false.obs;
  RxBool shareCode = false.obs;
  String generatedCode = "";
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  final parejaController = Get.put(ParejaController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButtonColor(
                buttonText: "Generar un código",
                color: Colors.orange,
                onPressed: () async {
                  setState(() {
                    haveCode.value = false;
                    shareCode.value = true;
                  });
                  if (await parejaController.verificarUserCodigo() == false) {
                    setState(() {
                      generatedCode = generarCodigo();
                    });
                    await parejaController.saveCodePareja(generatedCode);
                  } else {
                    customDialogFailed(
                        'Error', 'Ya tienes un codigo pendiente');
                  }
                },
              ),
              CustomButtonColor(
                buttonText: "Tengo un código",
                color: Colors.orange,
                onPressed: () async {
                  setState(() {
                    haveCode.value = true;
                    shareCode.value = false;
                  });
                },
              ),
              Visibility(
                visible: shareCode.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      generatedCode.length,
                      (index) => SizedBox(
                            width: Get.width * 0.13,
                            height: Get.width * 0.20,
                            child: CustomTextField(
                              maxLength: 1,
                              text: generatedCode[index],
                              enableInput: false,
                            ),
                          )),
                ),
              ),
              Visibility(
                visible: haveCode.value,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          controllers.length,
                          (index) => SizedBox(
                                width: Get.width * 0.13,
                                height: Get.width * 0.20,
                                child: CustomTextField(
                                  text: "",
                                  maxLength: 1,
                                  controller: controllers[index],
                                  onChanged: (value) {
                                    if (value.length == 1 &&
                                        index < controllers.length - 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              )),
                    ),
                    CustomButtonColor(
                      buttonText: "Buscar",
                      color: Colors.brown,
                      onPressed: () async {
                        String code = controllers
                            .map((controller) => controller.text)
                            .join();
                        if (await parejaController.verificarUserCodigo() ==
                            false) {
                          await parejaController.entrarRelacion(code);
                        } else {
                          customDialogFailed(
                              'Error', 'Ya tienes un codigo pendiente');
                        }
                      },
                    )
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
