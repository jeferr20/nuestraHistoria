import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nuestra_historia/utils/calendar_util.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';

class DatosRelacionScreen extends StatefulWidget {
  const DatosRelacionScreen({super.key});

  @override
  State<DatosRelacionScreen> createState() => _DatosRelacionScreenState();
}

class _DatosRelacionScreenState extends State<DatosRelacionScreen> {
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
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Cuentanos de tu relación"),
              Text("¿Cuando se conocieron?"),
              CustomTextField(
                colorFondo: Colors.black38,
                fuente: Colors.white,
                text: '',
                controller: fechaController,
                enableInput: false,
                onTap: () {
                  showCalendario(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
