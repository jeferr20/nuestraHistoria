import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String text;
  final IconData? prefixIcon;
  final Function()? onTap;
  final Function(String)? onChanged;
  final bool enableInput;
  final int? maxLength;
  final Color colorFondo;
  final Color fuente;
  const CustomTextField({
    super.key,
    required this.text,
    this.prefixIcon,
    this.controller,
    this.onTap,
    this.enableInput = true,
    this.onChanged,
    this.maxLength,
    required this.colorFondo,
    required this.fuente,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: !enableInput,
        child: TextField(
          maxLength: maxLength,
          onChanged: onChanged,
          controller: controller,
          textAlign: maxLength == 1 ? TextAlign.center : TextAlign.justify,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            counterText: '',
            hintText: text,
            contentPadding: EdgeInsets.all(maxLength != 1 ? 20 : 10),
            hintStyle: GoogleFonts.roboto(
              fontSize: 15,
              color: fuente,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            prefixIconColor: fuente,
            fillColor: colorFondo,
            filled: true,
          ),
          style: GoogleFonts.roboto(
            fontSize: 15,
            color: fuente,
          ),
        ),
      ),
    );
  }
}

class CustomPasswordTextField extends StatefulWidget {
  final String text;
  final IconData prefixIcon;
  final TextEditingController controller;
  final Function(String)? onchange;
  const CustomPasswordTextField({
    super.key,
    required this.text,
    required this.prefixIcon,
    required this.controller,
    this.onchange,
  });

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (widget.onchange != null) {
          widget
              .onchange!(value); // Llama a la función onchange si está definida
        }
      },
      controller: widget.controller,
      obscureText: passwordVisible,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        hintText: widget.text,
        contentPadding: const EdgeInsets.all(20),
        hintStyle: GoogleFonts.roboto(
          fontSize: 15,
          color: Colors.white,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        prefixIcon: Icon(widget.prefixIcon),
        prefixIconColor: Colors.white,
        fillColor: Colors.white.withOpacity(0.3),
        filled: true,
        suffixIcon: IconButton(
          color: Colors.white,
          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
        alignLabelWithHint: false,
      ),
      style: GoogleFonts.roboto(
        fontSize: 15,
        color: Colors.white,
      ),
    );
  }
}
