import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuestra_historia/models/cita_model.dart';
import 'package:nuestra_historia/models/relacion_model.dart';
import 'package:nuestra_historia/models/usuario_model.dart';
import 'package:nuestra_historia/utils/calendar_util.dart';
import 'package:nuestra_historia/styles/colors.dart';

class CardHeader extends StatefulWidget {
  final Usuario usuario;
  final Usuario? pareja;
  final Relacion? relacion;
  final Function()? ontap2;
  const CardHeader({
    super.key,
    required this.usuario,
    this.pareja,
    this.ontap2,
    this.relacion,
  });

  @override
  State<CardHeader> createState() => _CardHeaderState();
}

class _CardHeaderState extends State<CardHeader> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: Get.width,
        height: Get.height * 0.175,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * 0.25,
                  height: Get.width * 0.25,
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(100)),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.usuario.nombres,
                  style: GoogleFonts.roboto(fontSize: 15),
                ),
              ],
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${calcularDiasTranscurridos(widget.relacion!.aniversario)} dias",
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
                Text(
                  'Aniversario',
                  style: GoogleFonts.roboto(fontSize: 15),
                ),
                Text(
                  widget.relacion!.aniversario,
                  style: GoogleFonts.roboto(fontSize: 17),
                )
              ],
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: widget.ontap2,
                  child: Container(
                    width: Get.width * 0.25,
                    height: Get.width * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(widget.pareja == null ? "" : widget.pareja!.nombres,
                    style: GoogleFonts.roboto(fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCita extends StatelessWidget {
  final Cita cita;
  final Function()? onTap;
  final bool showCheck;
  const ItemCita({
    super.key,
    required this.cita,
    this.onTap,
    required this.showCheck,
  });

  @override
  Widget build(BuildContext context) {
    Color? color;
    String? imagen;
    switch (cita.categoria) {
      case "Citas clásicas":
        color = ColoresCitas.citasClasicas;
        imagen = 'assets/categories/reloj.png';
        break;
      case "Aventuras al aire libre":
        color = ColoresCitas.aventurasAireLibre;
        imagen = 'assets/categories/reloj.png';
        break;
      case "Citas culturales":
        color = ColoresCitas.citasCulturales;
        imagen = 'assets/categories/reloj.png';
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: color),
                child: Image.asset(
                  imagen!,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: SizedBox(
                  width: Get.width - 160,
                  child: Text(
                    cita.cita,
                    style: GoogleFonts.roboto(
                        fontSize: 15.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              if (showCheck) ...{
                const SizedBox(
                  width: 4,
                ),
                SizedBox(
                  height: 40,
                  width: 30,
                  child: Image.asset('assets/categories/check.png'),
                ),
                const SizedBox(
                  width: 8,
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
