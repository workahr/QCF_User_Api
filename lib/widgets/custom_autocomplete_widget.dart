import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';
import '../services/comFuncService.dart';

class CustomAutoCompleteWidget extends StatelessWidget {
  var valArr;
  var onChanged;
  String labelText;
  var labelField;
  var selectedItem;
  double? width;
  double? height;
  TextInputType? keyboardType;
  String? inputType;
  List<TextInputFormatter>? inputFormaters;
  String? Function(dynamic)? validator;

  CustomAutoCompleteWidget({
    super.key,
    required this.valArr,
    required this.onChanged,
    required this.labelText,
    this.validator,
    this.labelField,
    this.selectedItem,
    this.width,
    this.height,
    this.keyboardType,
    this.inputType,
    this.inputFormaters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      height: height ?? null,
      width: width ?? 201,
      child: DropdownSearch<dynamic>(
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            keyboardType: keyboardType,
            inputFormatters: inputType == 'number'
                ? [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^-?(\d+)?\.?\d{0,11}'))
                  ]
                : inputFormaters,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(8.0), // Reduced border radius here
              ),
            ),
          ),
          itemBuilder: (context, item, isSelected) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                labelField(item),
                style: const TextStyle(fontSize: 14),
              ),
            );
          },
          fit: FlexFit.tight,
        ),
        items: valArr.toList(),
        itemAsString: (item) => labelField(item),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            floatingLabelStyle:
                const TextStyle(fontSize: 14.0, color: AppColors.primary),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Reduced border radius here
              borderSide: BorderSide(width: 1.5, color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Reduced border radius here
              borderSide: BorderSide(width: 1.5, color: AppColors.primary),
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Reduced border radius here
              borderSide: BorderSide(width: 1.5, color: AppColors.lightGrey),
            ),
            labelText: labelText,
          ),
        ),
        validator: validator,
        onChanged: onChanged,
        selectedItem: selectedItem,
      ),
    );
  }
}





// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';

// import '../constants/constants.dart';
// import '../services/comFuncService.dart';

// class CustomAutoCompleteWidget extends StatelessWidget {
//   var valArr;
//   var onChanged;
//   String labelText;
//   var labelField;
//   var selectedItem;

//   String? Function(dynamic)? validator;

//   CustomAutoCompleteWidget(
//       {super.key,
//       required this.valArr,
//       required this.onChanged,
//       required this.labelText,
//       this.validator,
//       this.labelField,
//       this.selectedItem});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
//       width: MediaQuery.of(context).size.width - 10.0,
//       child: DropdownSearch<dynamic>(
//         popupProps: const PopupProps.menu(
//           showSearchBox: true,
//         ),
//         items: valArr.toList(),
//         itemAsString: (item) => labelField(item),
//         dropdownDecoratorProps: DropDownDecoratorProps(
//           dropdownSearchDecoration: InputDecoration(
//             floatingLabelStyle:
//                 const TextStyle(fontSize: 14.0, color: AppColors.primary),
//             enabledBorder: idleBorder(),
//             focusedBorder: defaultBorder(),
//             border: idleBorder(),
//             labelText: labelText,
//           ),
//         ),
//         validator: validator,
//         onChanged: onChanged,
//         selectedItem: selectedItem,
//       ),
//     );
//   }
// }
