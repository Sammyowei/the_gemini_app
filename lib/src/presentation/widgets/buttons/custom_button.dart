import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;

  final Color? color;

  final Widget? widget;

  final Color? outlineColor;

  final String? description;

  final Color? textColor;
  final Size size;
  const CustomButton(
      {super.key,
      this.widget,
      this.color,
      this.textColor,
      this.description,
      this.onTap,
      this.outlineColor,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: size.height.h,
        width: size.width.w,
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10).r,
              side: BorderSide(
                  color: outlineColor ?? const Color(0xff000000), width: 1),
            ),
            color: color),
        child: Center(
          child: widget ??
              Text(
                description ?? 'Hell nah',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
              ),
        ),
      ),
    );
  }
}
