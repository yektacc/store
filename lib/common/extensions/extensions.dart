import 'package:flutter/material.dart';
import 'package:store/common/widgets/form_fields.dart';

extension FormText on TextEditingController {
  makeWidget(String title, IconData icon, {bool validator = true, Key key}) {
    return FormFields.text(title, this, icon: icon);
  }
}
