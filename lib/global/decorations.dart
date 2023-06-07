import 'package:flutter/material.dart';

mydecoration({color, double? radius}) {
  color ??= Colors.white;
  radius ??= 30;
  return BoxDecoration(
    boxShadow: const [
      BoxShadow(
        blurRadius: 10.0,
        color: Color.fromARGB(255, 212, 212, 212),
        offset: Offset(0.0, 0.0),
      )
    ],
    color: color,
    borderRadius: BorderRadius.circular(radius),
  );
}
