import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime?> showCalendar(
    BuildContext context, DateTime initialDate) async {
  return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 110, 204,
                255), // Color de la barra superior y botones principales
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(
                  255, 110, 204, 255), // Color de fondo del día seleccionado
              onPrimary: Colors.white, // Color del texto en el día seleccionado
            ),
            buttonTheme: const ButtonThemeData(
              textTheme:
                  ButtonTextTheme.primary, // Estilo del texto en los botones
            ),
          ),
          child: child!,
        );
      });
}

int calcularEdad(DateTime fechaNacimiento) {
  final ahora = DateTime.now();
  int edad = ahora.year - fechaNacimiento.year;

  if (ahora.month < fechaNacimiento.month ||
      (ahora.month == fechaNacimiento.month &&
          ahora.day < fechaNacimiento.day)) {
    edad--;
  }

  return edad;
}

int calcularDiasTranscurridos(String fechaString) {
  DateTime fecha = DateFormat('dd/MM/yyyy').parse(fechaString);
  DateTime fechaHoy = DateTime.now();
  Duration diferencia = fechaHoy.difference(fecha);
  return diferencia.inDays;
}
