import 'package:flutter/material.dart';
import 'package:nuestra_historia/screens/home/calendario_screen.dart';
import 'package:nuestra_historia/screens/home/screen1%20copy%202.dart';
import 'package:nuestra_historia/screens/home/screen1%20copy.dart';
import 'package:nuestra_historia/screens/home/cien_citas_screen.dart';
import 'package:nuestra_historia/screens/widgets/navegation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedItemPosition = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: CustomNavegationBar(
        selectedItemPosition: selectedItemPosition,
        onTap: (index) {
          setState(() {
            selectedItemPosition = index;
          });
        },
      ),
      body: Center(
          child: IndexedStack(
        index: selectedItemPosition,
        children: [CienCitasScreen(), Page2(), Page3(), CalendarioScreen()],
      )),
    );
  }
}
