import 'package:flutter/widgets.dart';

enum CustomIcon {
  iconA('assets/icons/iconA.png'),
  iconB('assets/icons/iconB.png'),
  iconC('assets/icons/iconC.png');

  final String path;

  const CustomIcon(this.path);

  ImageIcon get({double size = 24.0, Color? color}) {
    return ImageIcon(
      AssetImage(path),
      size: size,
      color: color,
    );
  }
}
