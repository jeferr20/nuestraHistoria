import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  const CustomButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.roboto(
            fontSize: 20,
            color: const Color(0xffdd5e89),
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

class CustomRoundedIconButtonGoogle extends StatelessWidget {
  final Function()? onPressed;
  const CustomRoundedIconButtonGoogle({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(8),
          shape: const CircleBorder()),
      onPressed: onPressed,
      child: Image.asset("assets/google.png"),
    );
  }
}

class CustomRoundedIconButtonFacebook extends StatelessWidget {
  final Function()? onPressed;
  const CustomRoundedIconButtonFacebook({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(8),
          shape: const CircleBorder()),
      onPressed: onPressed,
      child: Image.asset(
        "assets/facebook.png",
        color: const Color.fromARGB(255, 1, 102, 225),
      ),
    );
  }
}

class CustomRoundedIconButtonApple extends StatelessWidget {
  final Function()? onPressed;
  const CustomRoundedIconButtonApple({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(8),
          shape: const CircleBorder()),
      onPressed: onPressed,
      child: Image.asset(
        "assets/apple-logo.png",
        color: Colors.black,
      ),
    );
  }
}

class CustomButtonColor extends StatelessWidget {
  final String buttonText;
  final Function()? onPressed;
  final Color color;
  const CustomButtonColor(
      {super.key,
      this.onPressed,
      required this.buttonText,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: GoogleFonts.roboto(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
