import 'package:flutter/material.dart';
import 'package:nuestra_historia/screens/home/calendario_screen.dart';
import 'package:nuestra_historia/screens/home/home_screen.dart';
import 'package:nuestra_historia/screens/home/setting_screen.dart';
import 'package:nuestra_historia/screens/home/cien_citas_screen.dart';
import 'package:nuestra_historia/screens/widgets/navegation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        children: const [
          CienCitasScreen(),
          HomeScreen(),
          SettingScreen(),
          CalendarioScreen()
        ],
      )),
    );
  }
}
