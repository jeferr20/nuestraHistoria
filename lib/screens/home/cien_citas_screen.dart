import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/controller/citas_controller.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/models/cita_model.dart';
import 'package:nuestra_historia/screens/grupo/cita_dato_screen.dart';
import 'package:nuestra_historia/screens/widgets/widgets.dart';

class CienCitasScreen extends StatefulWidget {
  const CienCitasScreen({super.key});

  @override
  State<CienCitasScreen> createState() => _CienCitasScreenState();
}

class _CienCitasScreenState extends State<CienCitasScreen> {
  PageController pageController = PageController();
  final citasController = Get.put(CitasController());
  final mMasterSession = Get.find<MasterSessionController>();
  List<CategoriaCitas> citaxcategoria = [];
  List<String> citasRealizadasIDS = [];
  RxInt estado = 0.obs;

  @override
  void initState() {
    super.initState();
    ever(mMasterSession.currentRelacion, (callback) => loadCitasData());
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> loadCitasData() async {
    try {
      List<Cita> citas = await citasController.getListadoCita();
      citasRealizadasIDS = await citasController.getCitasRealizadas();

      Map<String, List<Cita>> citasPorCategoria = {};

      for (Cita cita in citas) {
        if (!citasPorCategoria.containsKey(cita.categoria)) {
          citasPorCategoria[cita.categoria] = [];
        }
        citasPorCategoria[cita.categoria]!.add(cita);
      }
      List<String> categoriasOrdenadas = citasPorCategoria.keys.toList()
        ..sort();

      setState(() {
        citaxcategoria = categoriasOrdenadas.map((categoria) {
          List<Cita> citasCategoria = citasPorCategoria[categoria]!;

          return CategoriaCitas(
            categoria: categoria,
            citas: citasCategoria,
          );
        }).toList();
      });
    } catch (error) {
      rethrow;
    }
  }

  bool isCitaRealizada(Cita cita) {
    return citasRealizadasIDS.contains(cita.id);
  }

  List<Cita> obtenerCitasMostrar() {
    if (estado.value == 0) {
      // Mostrar todas las citas
      return citaxcategoria.expand((item) => item.citas).toList();
    } else if (estado.value == 1) {
      // Mostrar citas realizadas
      return citaxcategoria
          .expand((item) => item.citas.where((cita) => isCitaRealizada(cita)))
          .toList();
    } else {
      // Mostrar citas pendientes
      return citaxcategoria
          .expand((item) => item.citas.where((cita) => !isCitaRealizada(cita)))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const Text("Nuestras citas"),
              const Text("Categorias: "),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: citaxcategoria.map((CategoriaCitas item) {
                    return ItemCategoriaCita(
                      onTap: () {
                        pageController.animateToPage(
                          citaxcategoria.indexOf(item),
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      texto: item.categoria,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ItemFiltroCita(
                    texto: 'Todos',
                    onTap: () {
                      estado.value = 0;
                    },
                  ),
                  ItemFiltroCita(
                    texto: 'Realizados',
                    onTap: () {
                      estado.value = 1;
                    },
                  ),
                  ItemFiltroCita(
                    texto: 'Pendientes',
                    onTap: () {
                      estado.value = 2;
                    },
                  ),
                ],
              ),
              Obx(() => Expanded(
                    child: PageView(
                      controller: pageController,
                      children: citaxcategoria.map((CategoriaCitas item) {
                        if(estado.value==0){
                          return SingleChildScrollView(
                          child: Column(
                            children: item.citas
                                .map((e) => ItemCita(
                                      showCheck: isCitaRealizada(e),
                                      cita: e,
                                      onTap: () {
                                        mMasterSession.currentCita.value = e;
                                        Get.to(() => RegistrarCitaScreen(
                                              isChecked: isCitaRealizada(e),
                                            ));
                                      },
                                    ))
                                .toList(),
                          ),
                        );
                        }else if(estado.value==1){
return SingleChildScrollView(
                          child: Column(
                            children: item.citas
                                .map((e) => ItemCita(
                                      showCheck: isCitaRealizada(e),
                                      cita: e,
                                      onTap: () {
                                        mMasterSession.currentCita.value = e;
                                        Get.to(() => RegistrarCitaScreen(
                                              isChecked: isCitaRealizada(e),
                                            ));
                                      },
                                    ))
                                .toList(),
                          ),
                        );
                        }else{
return SingleChildScrollView(
                          child: Column(
                            children: item.citas
                                .map((e) => ItemCita(
                                      showCheck: isCitaRealizada(e),
                                      cita: e,
                                      onTap: () {
                                        mMasterSession.currentCita.value = e;
                                        Get.to(() => RegistrarCitaScreen(
                                              isChecked: isCitaRealizada(e),
                                            ));
                                      },
                                    ))
                                .toList(),
                          ),
                        );
                        }
                        
                      }).toList(),
                    ),
                  ))
              //   Expanded(
              //     child: SingleChildScrollView(
              //       child: ExpansionPanelList(
              //         elevation: 0,
              //         expansionCallback: (int panelIndex, bool isExpanded) {
              //           setState(() {
              //             citaxcategoria[panelIndex].isExpanded = isExpanded;
              //           });
              //         },
              //         children: citaxcategoria
              //             .map<ExpansionPanel>((CategoriaCitas item) {
              //           return ExpansionPanel(
              //               headerBuilder: (context, isExpanded) {
              //                 return ListTile(
              //                   title: Text(item.categoria),
              //                 );
              //               },
              //               body: Column(
              //                 children: item.citas
              //                     .map((e) => ItemCita(
              //                           showCheck: isCitaRealizada(e),
              //                           cita: e,
              //                           onTap: () {
              //                             mMasterSession.currentCita.value = e;
              //                             Get.to(() => RegistrarCitaScreen(
              //                                   isChecked: isCitaRealizada(e),
              //                                 ));
              //                           },
              //                         ))
              //                     .toList(),
              //               ),
              //               isExpanded: item.isExpanded);
              //         }).toList(),
              //       ),
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
