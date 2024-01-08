import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuestra_historia/controller/auth_controller.dart';
import 'package:nuestra_historia/controller/mastersession_controller.dart';
import 'package:nuestra_historia/screens/login/listas.dart';
import 'package:nuestra_historia/utils/calendar_util.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/dropdows.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';
import 'package:intl/intl.dart';

class RegisterDataScreen extends StatefulWidget {
  const RegisterDataScreen({super.key});

  @override
  State<RegisterDataScreen> createState() => _RegisterDataScreenState();
}

class _RegisterDataScreenState extends State<RegisterDataScreen> {
  final fechaController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final edadController = TextEditingController();
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final celularController = TextEditingController();
  final mMasterSession = Get.find<MasterSessionController>();
  final authController = Get.find<AuthController>();
  String? genero;

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                    colorFondo: Colors.black38,
                    fuente: Colors.white,
                    text: "Nombres",
                    controller: nombresController),
                CustomTextField(
                    colorFondo: Colors.black38,
                    fuente: Colors.white,
                    text: "Apellidos",
                    controller: apellidosController),
                CustomTextField(
                    colorFondo: Colors.black38,
                    fuente: Colors.white,
                    text: "Celular",
                    controller: celularController),
                CustomTextField(
                  colorFondo: Colors.black38,
                  fuente: Colors.white,
                  text: "Fecha Nacimiento",
                  controller: fechaController,
                  enableInput: false,
                  onTap: () {
                    showCalendario(context);
                  },
                ),
                CustomTextField(
                  colorFondo: Colors.black38,
                  fuente: Colors.white,
                  text: "Edad",
                  controller: edadController,
                  enableInput: false,
                ),
                CustomDropdown<String>(
                  items: Listas.generos,
                  selectedValue: genero,
                  onChanged: (value) {
                    setState(() {
                      genero = value;
                    });
                  },
                ),
                SizedBox(
                  width: Get.width * 0.7,
                  child: CustomButton(
                    text: 'GUARDAR',
                    onPressed: () async {
                      mMasterSession.currentUsuarioTemp.update((val) {
                        val?.nombres = nombresController.text.toString();
                        val?.apellidos = apellidosController.text.toString();
                        val?.celular = celularController.text.toString();
                        val?.fechaNacimiento = fechaController.text.toString();
                        val?.edad = calcularEdad(selectedDate);
                        val?.signoz = obtenerSignoZodiacal(selectedDate);
                        val?.genero = genero!;
                      });
                      // Get.to(() => VerificationScreen());
                      await authController.registrarUsuario(
                          mMasterSession.currentUsuarioTemp.value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
