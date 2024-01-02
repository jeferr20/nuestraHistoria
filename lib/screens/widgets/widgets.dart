import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuestra_historia/models/usuario_model.dart';

class CardHeader extends StatefulWidget {
  final Usuario usuario;
  final Usuario? pareja;
  const CardHeader({
    super.key,
    required this.usuario,
    this.pareja,
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
                  '100 dias',
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
                Text(
                  'Aniversario',
                  style: GoogleFonts.roboto(fontSize: 15),
                ),
                Text(
                  '10/09/2002',
                  style: GoogleFonts.roboto(fontSize: 17),
                )
              ],
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * 0.25,
                  height: Get.width * 0.25,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100)),
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
