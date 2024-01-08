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

String obtenerSignoZodiacal(DateTime fecha) {
  if ((fecha.month == 3 && fecha.day >= 21) ||
      (fecha.month == 4 && fecha.day <= 19)) {
    return 'Aries';
  } else if ((fecha.month == 4 && fecha.day >= 20) ||
      (fecha.month == 5 && fecha.day <= 20)) {
    return 'Tauro';
  } else if ((fecha.month == 5 && fecha.day >= 21) ||
      (fecha.month == 6 && fecha.day <= 20)) {
    return 'Géminis';
  } else if ((fecha.month == 6 && fecha.day >= 21) ||
      (fecha.month == 7 && fecha.day <= 22)) {
    return 'Cáncer';
  } else if ((fecha.month == 7 && fecha.day >= 23) ||
      (fecha.month == 8 && fecha.day <= 22)) {
    return 'Leo';
  } else if ((fecha.month == 8 && fecha.day >= 23) ||
      (fecha.month == 9 && fecha.day <= 22)) {
    return 'Virgo';
  } else if ((fecha.month == 9 && fecha.day >= 23) ||
      (fecha.month == 10 && fecha.day <= 22)) {
    return 'Libra';
  } else if ((fecha.month == 10 && fecha.day >= 23) ||
      (fecha.month == 11 && fecha.day <= 21)) {
    return 'Escorpio';
  } else if ((fecha.month == 11 && fecha.day >= 22) ||
      (fecha.month == 12 && fecha.day <= 21)) {
    return 'Sagitario';
  } else if ((fecha.month == 12 && fecha.day >= 22) ||
      (fecha.month == 1 && fecha.day <= 19)) {
    return 'Capricornio';
  } else if ((fecha.month == 1 && fecha.day >= 20) ||
      (fecha.month == 2 && fecha.day <= 18)) {
    return 'Acuario';
  } else {
    return 'Piscis';
  }
}
