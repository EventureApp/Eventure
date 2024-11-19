import 'package:flutter/material.dart';

import '../models/custom_icons.dart';

class IconPicker extends StatelessWidget {
  final IconData selectedIcon;
  final Function(IconData) onIconSelected;

  IconPicker({
    required this.selectedIcon,
    required this.onIconSelected,
  });

  final List<IconData> availableIcons = [
    CustomIcons.armchair,
    CustomIcons.beer2,
    CustomIcons.chess,
    CustomIcons.gamingcontroller,
    CustomIcons.veer,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: availableIcons.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        IconData icon = availableIcons[index];
        return GestureDetector(
          onTap: () => onIconSelected(icon),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: icon == selectedIcon ? Colors.blue : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 32,
                color: icon == selectedIcon ? Colors.blue : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
