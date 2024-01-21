import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuestra_historia/models/evento_model.dart';
import 'package:nuestra_historia/screens/widgets/buttons.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Evento>> eventos = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay!, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  Future<void> _mostrarSelectorHora(BuildContext context) async {
    // Obtén la hora actual como predeterminado
    TimeOfDay horaActual = TimeOfDay.now();

    // Muestra el selector de hora redondeado
    TimeOfDay? horaSeleccionada = await showRoundedTimePicker(
        negativeBtn: "CANCELAR",
        context: context,
        initialTime: horaActual,
        borderRadius: 20,
        theme: ThemeData(primarySwatch: Colors.orange),
        background: Colors.transparent);

    // Actualiza la hora seleccionada si el usuario la elige
    if (horaSeleccionada != null) {
      // Puedes utilizar la variable 'horaSeleccionada' para almacenar la hora seleccionada
      print("Hora seleccionada: $horaSeleccionada");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Ingrese la descripción',
                                style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                              CustomTextField(
                                  text: "",
                                  colorFondo: Colors.brown,
                                  fuente: Colors.black),
                              Text(
                                'Ingrese la hora',
                                style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                              CustomButton(
                                text: "GUARDAR",
                                onPressed: () {
                                  _mostrarSelectorHora(context);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ))
        ],
      ),
      body: SafeArea(
        child: TableCalendar(
          calendarFormat: _calendarFormat,
          locale: 'es_ES',
          firstDay: DateTime.utc(2010, 1, 1),
          lastDay: DateTime.utc(2030, 12, 30),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay!, day),
          onDaySelected: onDaySelected,
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            todayTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
        ),
      ),
    );
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }
}
