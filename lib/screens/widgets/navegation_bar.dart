import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class CustomNavegationBar extends StatefulWidget {
  final int selectedItemPosition;
  final void Function(int) onTap;
  const CustomNavegationBar(
      {super.key, required this.selectedItemPosition, required this.onTap});

  @override
  State<CustomNavegationBar> createState() => _CustomNavegationBarState();
}

class _CustomNavegationBarState extends State<CustomNavegationBar> {
  SnakeShape snakeShape = SnakeShape.circle;
  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(12);
  Color selectedColor = Colors.pink;
  Color unselectedColor = Colors.blue;
  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;
  @override
  Widget build(BuildContext context) {
    return SnakeNavigationBar.color(
      elevation: 6,
      backgroundColor: Colors.white,
      behaviour: snakeBarStyle,
      snakeShape: snakeShape,
      shape: bottomBarShape,
      padding: padding,
      snakeViewColor: selectedColor,
      selectedItemColor:
          snakeShape == SnakeShape.indicator ? selectedColor : null,
      unselectedItemColor: unselectedColor,
      showUnselectedLabels: showUnselectedLabels,
      showSelectedLabels: showSelectedLabels,
      currentIndex: widget.selectedItemPosition,
      onTap: widget.onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.book)),
        BottomNavigationBarItem(icon: Icon(Icons.home)),
        BottomNavigationBarItem(icon: Icon(Icons.settings))
      ],
      selectedLabelStyle: const TextStyle(fontSize: 14),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
    );
  }
}
