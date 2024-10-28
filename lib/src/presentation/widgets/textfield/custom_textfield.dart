import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final Widget? sulfixIcon;
  final Widget? prefixIcon;
  final String hintText;
  final TextInputFormatter? formatter;
  final bool obscureText;
  final TextEditingController? controller;
  final void Function(String? value)? onChanged;
  final TextInputType? keyboardType;
  const CustomTextField(
      {super.key,
      this.prefixIcon,
      this.sulfixIcon,
      this.controller,
      this.formatter,
      this.obscureText = false,
      this.onChanged,
      this.keyboardType,
      this.hintText = 'Hint Text'});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Center(
        child: TextFormField(
          keyboardType: widget.keyboardType,
          controller: widget.controller ?? TextEditingController(),
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          inputFormatters:
              (widget.formatter == null) ? null : [widget.formatter!],
          decoration: InputDecoration(
            labelText: widget.hintText,
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            prefixIcon: widget.prefixIcon ??
                Icon(
                  Icons.mail_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
            suffixIcon: widget.sulfixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10).r,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10).r,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            fillColor: Theme.of(context).colorScheme.surface,
            filled: true,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10).r,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
