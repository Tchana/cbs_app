import 'package:flutter/material.dart';

class CbsButton extends StatelessWidget {
  CbsButton({
    super.key,
    this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.radius,
    this.bgColor,
    this.borderColor,
  });

  double? width, height, radius;
  final void Function()? onPressed;
  final Widget child;
  MaterialColor? bgColor;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? Colors.transparent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          elevation: 0,
          side: bgColor != null
              ? null
              : BorderSide(
                  width: 1.0,
                  color: borderColor ?? Colors.transparent,
                ),
        ),
        child: child,
      ),
    );
  }
}
