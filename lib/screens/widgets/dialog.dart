import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';

Future<void> showLoadingDialog() async {
  return showDialog<void>(
    context: Get.overlayContext!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Future<void> hideLoadingDialog() async {
  Navigator.of(Get.overlayContext!).pop();
}

void customDialogFailed(String titulo, String descripcion) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        alignment: Alignment.center,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(titulo,
                  style: GoogleFonts.roboto(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF15249))),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/icons/cancelar.png',
                width: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(descripcion,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Get.width * 0.5,
                child: CustomButtonColor(
                    color: Color(0xFFF15249),
                    buttonText: 'Aceptar',
                    onPressed: () {
                      Get.back();
                    }),
              )
            ],
          ),
        ),
      );
    },
  );
}

void customDialogEmail(String titulo, String descripcion, Function()? onPressed,
    Function()? onPressed2) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        alignment: Alignment.center,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(titulo,
                  style: GoogleFonts.roboto(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF15249))),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/icons/cancelar.png',
                width: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(descripcion,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Get.width * 0.5,
                child: CustomButtonColor(
                    color: Color(0xFFF15249),
                    buttonText: 'Ya verifique',
                    onPressed: onPressed),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Get.width * 0.5,
                child: CustomButtonColor(
                    color: Color(0xFFF15249),
                    buttonText: 'Aceptar',
                    onPressed: onPressed2),
              )
            ],
          ),
        ),
      );
    },
  );
}
