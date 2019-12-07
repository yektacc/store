import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'constants.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCube(
      color: AppColors.loading_indicator_color,
      size: 50.0,
    );
  }
}
