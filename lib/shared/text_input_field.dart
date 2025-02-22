import 'package:center_for_biblical_studies/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? label;
  final String? errorText;
  final int? minLines;
  final int? maxLines;
  final double? padding;
  final double? height;
  final bool? expand;
  final bool? obscure;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? autofocus;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  const TextInputField({
    super.key,
    required this.hintText,
    this.label,
    this.errorText,
    this.controller,
    this.minLines,
    this.padding,
    this.maxLines = 1,
    this.height,
    this.expand,
    this.obscure = false,
    this.readOnly = false,
    this.suffixIcon,
    this.onSubmitted,
    this.validator,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.autofocus,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) Text(widget.label!, style: smallBodyStyle),
          if (widget.label != null)
            const SizedBox(
              height: 10,
            ),
          SizedBox(
            height: widget.height ?? (widget.errorText == null ? 40 : 55),
            child: TextField(
              style: smallBodyStyle,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              controller: widget.controller,
              onSubmitted: widget.onSubmitted,
              readOnly: widget.readOnly!,
              autofocus: widget.autofocus ?? false,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                hintText: widget.hintText,
                hintStyle: smallBodyStyle.copyWith(
                    color: Colors.black.withValues(alpha: 0.3)),
                suffixIcon: widget.suffixIcon,
                prefixIcon: widget.prefixIcon,
                errorText: widget.errorText,
              ),
              obscureText: widget.obscure!,
            ),
          ),
        ],
      ),
    );
  }
}
