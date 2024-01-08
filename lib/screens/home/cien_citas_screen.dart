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
  final citasController = Get.put(CitasController());
  final mMasterSession = Get.find<MasterSessionController>();
  List<CategoriaCitas> citaxcategoria = [];
  List<String> citasRealizadasIDS = [];
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    ever(mMasterSession.currentRelacion, (callback) => loadCitasData());
  }

  @override
  void dispose() {
    _isMounted = false;
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
          int index = categoriasOrdenadas.indexOf(categoria);

          return CategoriaCitas(
            categoria: categoria,
            citas: citasCategoria,
            isExpanded: index == 0,
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
              const Text("Clasico"),
              const Text("Nuestras citas"),
              const Text("Clasico"),
              Expanded(
                child: SingleChildScrollView(
                  child: ExpansionPanelList(
                    elevation: 0,
                    expansionCallback: (int panelIndex, bool isExpanded) {
                      setState(() {
                        citaxcategoria[panelIndex].isExpanded = isExpanded;
                      });
                    },
                    children: citaxcategoria
                        .map<ExpansionPanel>((CategoriaCitas item) {
                      return ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text(item.categoria),
                            );
                          },
                          body: Column(
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
                          isExpanded: item.isExpanded);
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
