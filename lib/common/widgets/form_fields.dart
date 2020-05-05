import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store/common/constants.dart';

class FormFields {
  static double _labelFontSize = 14;

  static Widget outlinedTextWithIcon(
      TextEditingController controller, IconData iconData, String hint,
      {Color color = AppColors.main_color}) {
    return Container(
      padding: EdgeInsets.only(right: 8),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: color)),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: hint,
            icon: Icon(
              iconData,
              color: color,
            ),
            border: InputBorder.none),
        controller: controller,
      ),
    );
  }

  static Widget text(String title, TextEditingController controller,
      {IconData icon,
      bool validateOnSubmit = true,
      TextInputType keyboardType = TextInputType.text,
      Key key,
      String Function(String) validator,
      bool noBorder = false,
      bool noIcon = false,
      Function(String) onChange}) {
    if (icon == null) {
      noIcon = true;
    }

    return Padding(
        padding: AppDimensions.defaultFormPadding,
        child: TextFormField(
          validator: validateOnSubmit
              ? (validator ??
                  (value) {
                    if (value.isEmpty) {
                      return 'این فیلد نباید خالی باشد';
                    } else {
                      return null;
                    }
                  })
              : null,
          controller: controller,
          onChanged: onChange,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              enabledBorder: noBorder
                  ? null
                  : OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.main_color)),
              border: noBorder ? null : OutlineInputBorder(),
              labelText: title,
              prefixIcon: noIcon ? null : Icon(icon),
              labelStyle: TextStyle(fontSize: _labelFontSize)),
        ));
  }

  static Widget password(String title, TextEditingController controller,
      {IconData icon,
        TextInputType keyboardType = TextInputType.text,
        Key key,
        String Function(String) validator,
        bool noBorder = false,
        bool noIcon = false,
        Function(String) onChange}) {
    return Padding(
        padding: AppDimensions.defaultFormPadding,
        child: TextFormField(
          obscureText: true,
          controller: controller,
          textAlign: TextAlign.center,
          validator: (value) {
            if (value.isEmpty) {
              return 'رمز عبور وارد نشده است';
            }
            return null;
          },
          decoration: InputDecoration(
              enabledBorder: noBorder
                  ? null
                  : OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main_color)),
              border: noBorder ? null : OutlineInputBorder(),
              labelText: title,

              hintText: "رمز عبور",
              hintStyle: TextStyle(fontSize: 13,),
              prefixIcon: noIcon ? null : Icon(
                Icons.lock,
                size: 22,
              ),
              labelStyle: TextStyle(fontSize: _labelFontSize)),
        ));
  }

  static Widget phone(
      {String title = "شماره موبایل",
      IconData icon = Icons.phone,
      TextEditingController controller,
      bool validator = true,
      Key key,
      bool noBorder = false}) {
//    assert(validator == false || key != null);

    return Padding(
      padding: AppDimensions.defaultFormPadding,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.phone,
        validator: validator
            ? (value) {
                if (value.isEmpty) {
                  return 'شماره موبایل وارد نشده است';
                } else if (!(value.startsWith("09") && value.length == 11 ||
                    value.startsWith("+989") && value.length == 13 ||
                    value.startsWith("00989") && value.length == 14)) {
                  return 'شماره موبایل وارد شده صحیح نمی باشد';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
            border: noBorder ? null : OutlineInputBorder(),
            enabledBorder: noBorder
                ? null
                : OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main_color)),
            labelText: title,
            prefixIcon: Icon(icon),
            labelStyle: TextStyle(fontSize: _labelFontSize)),
      ),

      /*TextFormField(
                      style: TextStyle(fontSize: 13),
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          icon: Icon(Icons.phone),
                          hintText: "شماره موبایل",
                          hintStyle: TextStyle(fontSize: 13)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'شماره موبایل وارد نشده است';
                        } else if (!(value.startsWith("09") &&
                                value.length == 11 ||
                            value.startsWith("+989") && value.length == 13 ||
                            value.startsWith("00989") && value.length == 14)) {
                          return 'شماره موبایل وارد شده صحیح نمی باشد';
                        }
                        return null;
                      },
                    )*/
    );
  }

  static Widget big(String title, TextEditingController controller,
      {bool validator = true, Key key, int maxLines = 5}) {
//    assert(validator == false || key != null);
    return Padding(
      padding: AppDimensions.defaultFormPadding,
      child: TextFormField(
        minLines: maxLines,
        maxLines: maxLines,
        controller: controller,
        validator: validator
            ? (value) {
                if (value.isEmpty) {
                  return 'این فیلد نباید خالی باشد';
                } else {
                  return null;
                }
              }
            : null,
        decoration: InputDecoration(
            labelText: title,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.main_color)),
            border: OutlineInputBorder(),
            labelStyle: TextStyle(fontSize: _labelFontSize)),
      ),
    );
  }
}
