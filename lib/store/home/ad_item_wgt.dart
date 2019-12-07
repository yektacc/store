import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/ads/ads_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class AdItemWgt extends StatelessWidget {
  final Ad _ad;

  AdItemWgt(this._ad);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launch(_ad.url);
      },
      child: Card(
        color: AppColors.main_color,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 30,
              child: Text(_ad.title,style: TextStyle(color: Colors.white),),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4))),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Helpers.image(_ad.imgUrl),
              ),
            )
          ],
        ),
      ),
    );
  }
}
