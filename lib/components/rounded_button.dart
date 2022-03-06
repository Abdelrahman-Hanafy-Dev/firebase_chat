import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  late final Widget child;
  late final Color color;
  late final VoidCallback onButtonPressed;

  RoundedButton(
      {required this.child,
      required this.color,
      required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            onButtonPressed();
          },
          minWidth: 200.0,
          height: 42.0,
          child: child,
        ),
      ),
    );
  }
}
