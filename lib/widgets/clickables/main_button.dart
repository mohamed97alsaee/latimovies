import 'package:flutter/material.dart';
import 'package:latimovies/helpers/consts.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.btnColor = blueColor,
      this.txtColor = Colors.white,
      this.horizontalPadding = 32,
      this.inProgress = false});
  final String label;
  final Function onPressed;
  final Color btnColor;
  final Color txtColor;
  final double horizontalPadding;
  final bool inProgress;
  @override
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(btnColor),
        ),
        onPressed: () {
          onPressed();
        },
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: inProgress
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                    strokeWidth: 2,
                  ))
              : Text(
                  label,
                  style: TextStyle(color: txtColor),
                ),
        ));
  }
}
