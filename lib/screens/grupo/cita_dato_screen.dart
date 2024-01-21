import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nuestra_historia/controller/citas_controller.dart';
import 'package:nuestra_historia/models/datoRptaCita_model.dart';
import 'package:nuestra_historia/screens/widgets/widgets.dart';
import 'package:nuestra_historia/styles/colors.dart';
import 'package:nuestra_historia/utils/calendar_util.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/dialog.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';
import 'package:nuestra_historia/services/images_services.dart';

import '../../controller/mastersession_controller.dart';

class RegistrarCitaScreen extends StatefulWidget {
  final bool isChecked;
  const RegistrarCitaScreen({super.key, required this.isChecked});

  @override
  State<RegistrarCitaScreen> createState() => _RegistrarCitaScreenState();
}

class _RegistrarCitaScreenState extends State<RegistrarCitaScreen> {
  List<RxBool> heartColors = [
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs
  ];
  List<RxBool> starColors = [
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs
  ];

  int nCorazonesUsuario = 0;
  int intCorazonesPrevios = 0;

  int nEstrellasUsuario = 0;
  int intEstrellasPrevios = 0;

  String rptaId = "";
  DateTime selectedDate = DateTime.now();
  final rptaController = TextEditingController();
  final fechaController = TextEditingController();
  final citasController = Get.put(CitasController());
  final mMasterSession = Get.find<MasterSessionController>();
  DatosRptaCita? rptaPrevia;
  RxList<String> listaFotosString = <String>[].obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    if (widget.isChecked) {
      getCita();
    } else {
      rptaController.text = "";
      fechaController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    }
  }

  Future<void> getCita() async {
    try {
      isLoading.value = true;
      rptaPrevia = await citasController.getDatosRptaCita();
      if (mounted) {
        if (rptaPrevia != null) {
          listaFotosString.value = rptaPrevia!.mediaUrl!;
          fechaController.text = rptaPrevia!.fecha;
          rptaController.text = rptaPrevia!.userRpta;
          intCorazonesPrevios = rptaPrevia!.corazones;
          intEstrellasPrevios = rptaPrevia!.estrellas;
          rptaId = rptaPrevia!.id;
          for (int i = 0; i < intCorazonesPrevios; i++) {
            heartColors[i].value = true;
          }
          for (int i = 0; i < intEstrellasPrevios; i++) {
            starColors[i].value = true;
          }
          nCorazonesUsuario = intCorazonesPrevios;
          nEstrellasUsuario = intEstrellasPrevios;
        }
      }
    } catch (error) {
      rethrow;
    } finally {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 10), () {
          isLoading.value = false;
        });
      }
    }
  }

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
    return Scaffold(
      backgroundColor: Colores.colorFondo,
      body: SafeArea(
          child: Obx(() => Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            height: 150,
                            child: Obx(
                              () => Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  if (listaFotosString.isEmpty) {
                                    return ItemAddImagen(
                                      onTap: () async {
                                        List<XFile>? selectedImages;
                                        final images = await pickImages();
                                        if (images != null) {
                                          selectedImages = images;
                                          listaFotosString.addAll(selectedImages
                                              .map((xFile) => xFile.path));
                                          setState(() {});
                                        }
                                      },
                                    );
                                  } else {
                                    String imagePath = listaFotosString[index];
                                    return ItemImagenCita(
                                      imagePath: imagePath,
                                    );
                                  }
                                },
                                itemCount: listaFotosString.isEmpty
                                    ? 1
                                    : listaFotosString.length,
                                viewportFraction: 0.5,
                                scale: 0.8,
                                pagination: const SwiperPagination(),
                                control:
                                    const SwiperControl(color: Colors.white),
                              ),
                            )),
                        Text(
                            "¿Como se sintieron ${mMasterSession.currentUsuario.value.nombres.split(" ").first} y ${mMasterSession.currentUsuarioPareja.value.nombres.split(" ").first}?",
                            style: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        CustomTextField(
                          text: "Opinion",
                          colorFondo: Colors.red,
                          fuente: Colors.white,
                          controller: rptaController,
                        ),
                        Text(
                          "Fecha:",
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        CustomTextField(
                          colorFondo: Colors.black38,
                          fuente: Colors.white,
                          text: "Fecha",
                          controller: fechaController,
                          enableInput: false,
                          onTap: () {
                            showCalendario(context);
                          },
                        ),
                        Text(
                          "¿Qué tan romántico les pareció?",
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (int i = 0; i <= index; i++) {
                                      heartColors[i].value = true;
                                    }
                                    for (int i = index + 1;
                                        i < heartColors.length;
                                        i++) {
                                      heartColors[i].value = false;
                                    }
                                    nCorazonesUsuario = index + 1;
                                  });
                                },
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset(
                                    'assets/icons/heart.png',
                                    color: heartColors[index].value
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Text(
                          "¿Qué tal les pareció la cita?",
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (int i = 0; i <= index; i++) {
                                      starColors[i].value = true;
                                    }
                                    for (int i = index + 1;
                                        i < starColors.length;
                                        i++) {
                                      starColors[i].value = false;
                                    }
                                    nEstrellasUsuario = index + 1;
                                  });
                                },
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset(
                                    'assets/icons/star.png',
                                    color: starColors[index].value
                                        ? Colors.amber
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        CustomButton(
                            text: "Guardar",
                            onPressed: () async {
                              if (widget.isChecked) {
                                try {
                                  final rptaActualizar = DatosRptaCita(
                                      fecha: fechaController.text.toString(),
                                      id: rptaId,
                                      estrellas: nEstrellasUsuario,
                                      corazones: nCorazonesUsuario,
                                      relacionId: mMasterSession
                                          .currentRelacion.value.id,
                                      citaID:
                                          mMasterSession.currentCita.value.id,
                                      userRpta: rptaController.text.toString());
                                  await citasController
                                      .actualizarDatosCita(rptaActualizar);
                                  customDialogExito(
                                      "Éxito",
                                      "Se ha actualizado correctamente",
                                      () => {Get.back(), Get.back()});
                                } catch (error) {
                                  customDialogFailed(
                                      "Error",
                                      "Ha surgido un error al actualizar la información: $error",
                                      () => {Get.back()});
                                }
                              } else {
                                try {
                                  showLoadingDialog();
                                  final rptaGuardar = DatosRptaCita(
                                      fecha: fechaController.text.toString(),
                                      estrellas: nEstrellasUsuario,
                                      corazones: nCorazonesUsuario,
                                      relacionId: mMasterSession
                                          .currentRelacion.value.id,
                                      citaID:
                                          mMasterSession.currentCita.value.id,
                                      user1ID: mMasterSession
                                          .currentUsuario.value.id,
                                      user2ID: mMasterSession
                                          .currentUsuarioPareja.value.id,
                                      userRpta: rptaController.text.toString());
                                  await citasController.guardarDatosCita(
                                      rptaGuardar, listaFotosString);
                                  hideLoadingDialog();
                                  customDialogExito(
                                      "Éxito",
                                      "Se ha guardado correctamente",
                                      () => {Get.back(), Get.back()});
                                } catch (error) {
                                  hideLoadingDialog();
                                  customDialogFailed(
                                      "Error",
                                      "Ha surgido un error al guardar la información: $error",
                                      () => {Get.back()});
                                }
                              }
                            })
                      ],
                    ),
                  ),
                  if (isLoading.value)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ))),
    );
  }
}
