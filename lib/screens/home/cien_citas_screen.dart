import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuestra_historia/controller/citas_controller.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/models/cita_model.dart';
import 'package:nuestra_historia/screens/grupo/cita_dato_screen.dart';
import 'package:nuestra_historia/screens/widgets/widgets.dart';
import 'package:nuestra_historia/styles/colors.dart';

class CienCitasScreen extends StatefulWidget {
  const CienCitasScreen({super.key});

  @override
  State<CienCitasScreen> createState() => _CienCitasScreenState();
}

class _CienCitasScreenState extends State<CienCitasScreen> {
  final citasController = Get.put(CitasController());
  final mMasterSession = Get.find<MasterSessionController>();
  RxList<Cita> allCitas = <Cita>[].obs;
  RxList<Cita> citasFiltradas = <Cita>[].obs;
  List<String> categorias = [];
  RxInt estado = 0.obs;
  RxString categoriaSeleccionada = "Todas".obs;
  RxString mensajeError = "".obs;

  @override
  void initState() {
    super.initState();
    ever(mMasterSession.currentRelacion, (callback) => {loadCitasData()});
  }

  Future<void> loadCitasData() async {
    try {
      allCitas.value = await citasController.getListadoCita();

      categorias = await obtenerCategoriasUnicas(allCitas);
      categorias.insert(0, "Todas");
      List<String> citasRealizadasIDS =
          await citasController.getCitasRealizadas();
      for (var cita in allCitas) {
        cita.estado = citasRealizadasIDS.contains(cita.id);
      }
      if (estado.value == 0 && categoriaSeleccionada.value == "") {
        citasFiltradas.assignAll(allCitas);
      } else {
        filtrarPorCategoria(categoriaSeleccionada.value, estado.value);
      }
      setState(() {});
    } catch (error) {
      rethrow;
    }
  }

  void filtrarPorCategoria(String categoria, int estado) {
    if (categoria == "Todas") {
      if (estado == 0) {
        citasFiltradas.assignAll(allCitas
            .where((cita) => cita.estado == true || cita.estado == false)
            .toList());
      } else if (estado == 1) {
        citasFiltradas
            .assignAll(allCitas.where((cita) => cita.estado == true).toList());
      } else if (estado == 2) {
        citasFiltradas
            .assignAll(allCitas.where((cita) => cita.estado == false).toList());
      }
    } else {
      if (estado == 0) {
        citasFiltradas.assignAll(
            allCitas.where((cita) => cita.categoria == categoria).toList());
      } else if (estado == 1) {
        citasFiltradas.assignAll(allCitas
            .where((cita) => cita.categoria == categoria && cita.estado == true)
            .toList());
      } else if (estado == 2) {
        citasFiltradas.assignAll(allCitas
            .where(
                (cita) => cita.categoria == categoria && cita.estado == false)
            .toList());
      }
    }
    if (categoria == "Todas") {
      if (estado == 1) {
        mensajeError.value = "No haz completado ninguna cita";
      } else if (estado == 2) {
        mensajeError.value = "Ya haz completado todas las citas";
      }
    } else {
      if (estado == 1) {
        mensajeError.value =
            "Aun no haz realizado ninguna cita de la categoría: $categoria";
      } else if (estado == 2) {
        mensajeError.value =
            "Ya has realizado todas las citas de la categoría: $categoria";
      }
    }
  }

  Future<List<String>> obtenerCategoriasUnicas(List<Cita> citas) async {
    Set<String> categoriasUnicas = <String>{};
    for (Cita cita in citas) {
      categoriasUnicas.add(cita.categoria);
    }
    return categoriasUnicas.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.colorFondo,
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.only(bottom: 70),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Text(
                "Mis Citas",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categorias.map((String categoria) {
                    return Obx(() => ItemCategoriaCita(
                          isPressed: categoria == categoriaSeleccionada.value,
                          texto: categoria,
                          onTap: () {
                            categoriaSeleccionada.value = categoria;
                            filtrarPorCategoria(
                                categoriaSeleccionada.value, estado.value);
                            setState(() {});
                          },
                        ));
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => ItemFiltroCita(
                      texto: 'Todos',
                      isPressed: estado.value == 0,
                      onTap: () {
                        estado.value = 0;
                        filtrarPorCategoria(
                            categoriaSeleccionada.value, estado.value);
                      },
                    ),
                  ),
                  Obx(
                    () => ItemFiltroCita(
                      isPressed: estado.value == 1,
                      texto: 'Realizados',
                      onTap: () {
                        estado.value = 1;
                        filtrarPorCategoria(
                            categoriaSeleccionada.value, estado.value);
                      },
                    ),
                  ),
                  Obx(
                    () => ItemFiltroCita(
                      isPressed: estado.value == 2,
                      texto: 'Pendientes',
                      onTap: () {
                        estado.value = 2;
                        filtrarPorCategoria(
                            categoriaSeleccionada.value, estado.value);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Obx(() => Expanded(
                    child: citasFiltradas.isEmpty
                        ? Center(
                            child: Text(mensajeError.value),
                          )
                        : SingleChildScrollView(
                            child: Column(
                                children: citasFiltradas.map((element) {
                              return ItemCita(
                                cita: element,
                                showCheck: element.estado!,
                                onTap: () {
                                  mMasterSession.currentCita.value = element;
                                  Get.to(() => RegistrarCitaScreen(
                                        isChecked: element.estado!,
                                      ));
                                },
                              );
                            }).toList()),
                          ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
