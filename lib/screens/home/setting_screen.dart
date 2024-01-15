import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nuestra_historia/controller/auth_controller.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/models/usuario_model.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/dialog.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';
import 'package:nuestra_historia/services/images_services.dart';
import 'package:nuestra_historia/styles/colors.dart';
import 'package:nuestra_historia/utils/calendar_util.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final celularController = TextEditingController();
  final correoController = TextEditingController();
  final edadController = TextEditingController();
  final fechaController = TextEditingController();
  late DateTime selectedDate;
  late String urlImagen;
  final mMasterSession = Get.find<MasterSessionController>();
  final authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    // urlImagen="https://scontent.ftru7-1.fna.fbcdn.net/v/t1.6435-9/169088340_2942315422664488_3185983285365936719_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=be3454&_nc_ohc=GAU9GfvySFcAX-bOuY8&_nc_ht=scontent.ftru7-1.fna&oh=00_AfBqmcQhiZEjOo7PHe5qCE8SuA5DSTjcdaNTW-a_hdaIvg&oe=65CACAFB";
    urlImagen = mMasterSession.currentUsuario.value.urlPerfil!;
    nombreController.text = mMasterSession.currentUsuario.value.nombres;
    apellidoController.text = mMasterSession.currentUsuario.value.apellidos;
    celularController.text = mMasterSession.currentUsuario.value.celular;
    correoController.text = mMasterSession.currentUsuario.value.correo;
    fechaController.text = mMasterSession.currentUsuario.value.fechaNacimiento;
    List<String> partesFecha =
        mMasterSession.currentUsuario.value.fechaNacimiento.split("/");
    int dia = int.parse(partesFecha[0]);
    int mes = int.parse(partesFecha[1]);
    int anio = int.parse(partesFecha[2]);

    selectedDate = DateTime(anio, mes, dia);
    edadController.text = "${mMasterSession.currentUsuario.value.edad} años";
  }

  Future<void> showCalendario(BuildContext context) async {
    final DateTime? picked = await showCalendar(context, selectedDate);
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        int edad = calcularEdad(selectedDate);
        fechaController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        edadController.text = "$edad Años";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.colorFondo,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              SizedBox(
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    urlImagen.isNotEmpty || urlImagen != null
                        ? CircleAvatar(
                            radius: 80,
                            backgroundImage: urlImagen.startsWith('http')
                                ? NetworkImage(urlImagen)
                                : Image.file(File(urlImagen)).image,
                          )
                        : const CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.lightGreenAccent,
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final image = await pickImage();
                        if (image != null) {
                          urlImagen = image.path;
                          setState(() {});
                        }
                      },
                      child: Text(
                        "CAMBIAR FOTO DE PERFIL",
                        style: GoogleFonts.roboto(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Información General",
                      style: GoogleFonts.roboto(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Nombres",
                      style: GoogleFonts.roboto(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextField(
                        controller: nombreController,
                        text: "Ingrese sus nombres",
                        colorFondo: Colors.white,
                        fuente: Colors.black),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Apellidos",
                      style: GoogleFonts.roboto(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextField(
                        controller: apellidoController,
                        text: "Ingrese sus apellidos",
                        colorFondo: Colors.white,
                        fuente: Colors.black),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Celular",
                      style: GoogleFonts.roboto(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextField(
                        controller: celularController,
                        text: "Ingrese su celular",
                        colorFondo: Colors.white,
                        fuente: Colors.black),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Correo",
                      style: GoogleFonts.roboto(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextField(
                        controller: correoController,
                        text: "Ingrese su correo electrónico",
                        enableInput: false,
                        colorFondo: Colors.white,
                        fuente: Colors.black),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Fecha de nacimiento",
                      style: GoogleFonts.roboto(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextField(
                      controller: fechaController,
                      text: "Ingrese su fecha de nacimiento",
                      colorFondo: Colors.white,
                      enableInput: false,
                      fuente: Colors.black,
                      onTap: () {
                        showCalendario(context);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Edad",
                      style: GoogleFonts.roboto(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextField(
                        controller: edadController,
                        text: "Ingrese su edad",
                        enableInput: false,
                        colorFondo: Colors.white,
                        fuente: Colors.black),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                        width: Get.width,
                        child: CustomButton(
                          text: "Actualizar",
                          onPressed: () async {
                            showLoadingDialog();
                            try {
                              final Usuario user = Usuario(
                                nombres: nombreController.text,
                                apellidos: apellidoController.text,
                                celular: celularController.text,
                                fechaNacimiento: fechaController.text,
                                edad: calcularEdad(selectedDate),
                              );
                              await authController.actualizarDatosUsuario(
                                  user, urlImagen);
                              hideLoadingDialog();
                              customDialogExito(
                                  "Éxito",
                                  "Se ha actualizado la información correctamente",
                                  () => {Get.back()});
                            } catch (e) {
                              hideLoadingDialog();
                              customDialogFailed(
                                  'Error',
                                  'Hubo un error al crear el usuario: $e',
                                  () => {Get.back()});
                            }
                          },
                        ))
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
