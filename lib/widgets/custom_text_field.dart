import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomeTextField extends StatelessWidget {
  CustomeTextField({
    Key? key,
    this.hint,
    this.width,
    this.margin,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.type,
    this.control,
    this.errMsg,
    this.onChanged,
    this.validator,
    this.readOnly,
    this.focusNode,
    this.inputFormaters,
    this.initialValue,
    this.lines,
    this.textAlign,
    this.inputType,
    this.contentPadding,
    this.onTap,
    this.height,
    this.borderColor,
    this.focusBorderColor,
    this.labelColor,
    this.borderRadius,
    this.boxColor,
    this.boxRadius,
    this.hintColor,
    this.prefixText,
  }) : super(key: key);

  final String? hint;
  final double? width;
  final double? height;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? prefixText; // Declare prefixText
  var margin;
  var control;
  var initialValue;
  var type;
  TextAlign? textAlign;
  String? inputType;
  var errMsg;
  var obscureText;
  var onChanged;
  var validator;
  final bool? readOnly;
  var focusNode;
  var inputFormaters;
  var lines;
  Color? borderColor;
  Color? boxColor;
  Color? hintColor;
  Color? focusBorderColor;
  Color? labelColor;
  BorderRadius? borderRadius;
  BorderRadius? boxRadius;
  final Function()? onTap;
  EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      width: width ?? 201,
      height: height,
      decoration: BoxDecoration(
        color: boxColor ?? Colors.white,
        borderRadius: boxRadius,
      ),
      child: TextFormField(
        onTap: onTap,
        initialValue: initialValue,
        textAlign: textAlign ?? TextAlign.start,
        controller: control,
        obscureText: obscureText ?? false,
        keyboardType: inputType == 'number'
            ? const TextInputType.numberWithOptions()
            : type,
        inputFormatters: inputType == 'number'
            ? [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^-?(\d+)?\.?\d{0,11}')),
              ]
            : inputFormaters,
        maxLines: lines ?? 1,
        validator: validator,
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        focusNode: focusNode,
        cursorColor: labelColor ?? Colors.black,
        decoration: InputDecoration(
          hintText: hint,
          labelText: labelText,
          prefixText: prefixText, // Set prefixText here
          prefixStyle: TextStyle(
            fontSize: 14.0,
            color: labelColor ?? Colors.black,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          iconColor: Colors.black,
          floatingLabelStyle:
              TextStyle(fontSize: 14.0, color: labelColor ?? Colors.red),
          hintStyle: TextStyle(fontSize: 14.0, color: hintColor ?? Colors.grey),
          labelStyle:
              TextStyle(fontSize: 14.0, color: hintColor ?? Colors.grey),
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          border: OutlineInputBorder(
            borderRadius:
                borderRadius ?? BorderRadius.all(Radius.circular(12.0)),
            borderSide:
                BorderSide(width: 1.5, color: borderColor ?? Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                borderRadius ?? BorderRadius.all(Radius.circular(12.0)),
            borderSide:
                BorderSide(width: 1.5, color: borderColor ?? Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                borderRadius ?? BorderRadius.all(Radius.circular(12.0)),
            borderSide:
                BorderSide(width: 1.5, color: focusBorderColor ?? Colors.red),
          ),
        ),
      ),
    );
  }
}










// import 'package:flutter/services.dart';

// import '../constants/constants.dart';
// import 'package:flutter/material.dart';

// class CustomeTextField extends StatelessWidget {
//   CustomeTextField(
//       {Key? key,
//       this.hint,
//       this.width,
//       this.margin,
//       this.labelText,
//       this.prefixIcon,
//       this.suffixIcon,
//       this.obscureText,
//       this.type,
//       this.control,
//       this.errMsg,
//       this.onChanged,
//       this.validator,
//       this.readOnly,
//       this.focusNode,
//       this.inputFormaters,
//       this.initialValue,
//       this.lines,
//       this.textAlign,
//       this.inputType,
//       this.contentPadding,
//       this.onTap,
//       this.height,
//       this.borderColor,
//       this.focusBorderColor,
//       this.labelColor,
//       this.borderRadius,
//       this.boxColor,
//       this.boxRadius,
//       this.hintColor})
//       : super(key: key);

//   final String? hint;
//   final double? width;
//   final double? height;

//   final String? labelText;
//   final Widget? suffixIcon;
//   final Widget? prefixIcon;
//   var margin;
//   var control;
//   var initialValue;
//   var type;
//   TextAlign? textAlign;
//   String? inputType;
//   var errMsg;
//   var obscureText;
//   var onChanged;
//   var validator;
//   final bool? readOnly;
//   var focusNode;
//   var inputFormaters;
//   var lines;
//   Color? borderColor;
//   Color? boxColor;
//   Color? hintColor;
//   Color? focusBorderColor;
//   Color? labelColor;
//   BorderRadius? borderRadius;
//   BorderRadius? boxRadius;
//   final Function()? onTap;
//   EdgeInsetsGeometry? contentPadding;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: margin ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
//       width: width ?? 201,
//       height: height ?? null,
//       decoration: BoxDecoration(
//         color: boxColor ?? AppColors.light,
//         borderRadius: boxRadius ?? null,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               onTap: onTap,
//               initialValue: initialValue,
//               // textAlign: textAlign!,
//               // textAlign: textAlign || type == null ? TextAlign.start : TextAlign.end,
//               textAlign: inputType == 'number'
//                   ? textAlign == null
//                       ? TextAlign.end
//                       : TextAlign.start
//                   : textAlign ?? TextAlign.start,
//               controller: control,
//               obscureText: obscureText == true
//                   ? obscureText
//                       ? true
//                       : false
//                   : false,
//               keyboardType: inputType == 'number'
//                   ? const TextInputType.numberWithOptions()
//                   : type,
//               inputFormatters: inputType == 'number'
//                   ? [
//                       FilteringTextInputFormatter.allow(
//                           RegExp(r'^-?(\d+)?\.?\d{0,11}'))
//                     ]
//                   : inputFormaters,
//               maxLines: lines ?? 1,
//               validator: validator,
//               readOnly: readOnly ?? false,
//               onChanged: onChanged,
//               focusNode: focusNode,
//               cursorColor: labelColor ?? AppColors.primary,
//               decoration: InputDecoration(
//                 hintText: hint,
//                 labelText: labelText,
//                 prefixIcon: prefixIcon,
//                 suffixIcon: suffixIcon,
//                 iconColor: AppColors.primary,
//                 floatingLabelStyle: TextStyle(
//                     fontSize: 14.0, color: labelColor ?? AppColors.red),
//                 hintStyle: TextStyle(
//                     fontSize: 14.0, color: hintColor ?? AppColors.lightGrey),
//                 labelStyle: TextStyle(
//                     fontSize: 14.0, color: hintColor ?? AppColors.lightGrey),
//                 // labelStyle: TextStyle(
//                 //     fontSize: 16, color: const Color(0xff6A707C).withOpacity(0.48)),
//                 // contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                 // contentPadding: contentPadding,
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                 border: OutlineInputBorder(
//                   borderRadius:
//                       borderRadius ?? BorderRadius.all(Radius.circular(12.0)),
//                   borderSide: BorderSide(
//                       width: 1.5, color: borderColor ?? AppColors.lightGrey),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius:
//                       borderRadius ?? BorderRadius.all(Radius.circular(12.0)),
//                   borderSide: BorderSide(
//                       width: 1.5, color: borderColor ?? AppColors.lightGrey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius:
//                       borderRadius ?? BorderRadius.all(Radius.circular(12.0)),
//                   borderSide: BorderSide(
//                       width: 1.5, color: focusBorderColor ?? AppColors.red),
//                 ),
//               ),
//               // )
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
