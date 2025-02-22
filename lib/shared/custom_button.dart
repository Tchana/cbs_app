import 'package:center_for_biblical_studies/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? width, height, radius;
  final void Function()? onPressed;
  final Widget child;
  final Color? bgColor;
  final Color? borderColor;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.child,
    this.height = 40,
    this.width,
    this.radius = 5.0,
    this.bgColor = CustomColors.secondaryColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius!),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class CbsButton extends StatelessWidget {
  final double? width, height, radius;
  final void Function()? onPressed;
  final Widget child;
  final MaterialColor? bgColor;
  final Color? borderColor;

  const CbsButton({
    super.key,
    this.onPressed,
    required this.child,
    this.height = 20,
    this.width,
    this.radius,
    this.bgColor,
    this.borderColor,
  });

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
