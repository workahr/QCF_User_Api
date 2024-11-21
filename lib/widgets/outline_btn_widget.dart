import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'sub_heading_widget.dart';

class OutlineBtnWidget extends StatelessWidget {
  final Color? borderColor;
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final Color? titleColor;
  final double? width;
  final double? height;
  final void Function()? onTap;
  const OutlineBtnWidget(
      {super.key,
      this.borderColor,
      this.icon,
      required this.title,
      this.titleColor,
      this.iconColor,
      this.onTap,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: width ?? MediaQuery.of(context).size.width - 30.0,
          height: height ?? 10.0,
          child: DottedBorder(
            dashPattern: [6, 6, 6, 6],
            color: borderColor ?? AppColors.primary,
            borderType: BorderType.RRect,
            radius: Radius.circular(10.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon ?? Icons.add_circle,
                      size: 18.0,
                      color: iconColor ?? AppColors.primary,
                    ),
                  SizedBox(
                    width: 5.0,
                  ),
                  SubHeadingWidget(
                    title: title,
                    fontSize: 16.0,
                    color: titleColor ?? AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
