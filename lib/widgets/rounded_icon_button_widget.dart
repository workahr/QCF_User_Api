import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'heading_widget.dart';

class RoundedIconButtonWidget extends StatelessWidget {
  const RoundedIconButtonWidget(
      {super.key,
      this.height,
      required this.title,
      this.onPressed,
      this.buttonColor});
  final double? height;
  final String title;
  final Color? buttonColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40.0,
      padding: EdgeInsets.all(0.0),
      child: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        foregroundColor: AppColors.light,
        backgroundColor: buttonColor ?? AppColors.primary2,
        elevation: 0.0,
        onPressed: onPressed,
        label: HeadingWidget(
          title: title,
          color: AppColors.light,
        ),
        icon: Container(
          height: 33.0,
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.light,
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: AppColors.warning2,
              size: 19.0,
            ),
          ),
        ),
      ),
    );
  }
}
