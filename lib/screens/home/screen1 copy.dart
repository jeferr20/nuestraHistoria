import 'package:flutter/material.dart';
import 'package:nuestra_historia/screens/widgets/textfield.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(child: CustomTextField(text: 'Hola3')),
    );
  }
}
