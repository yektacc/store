import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store/common/constants.dart';

class CreditCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('کارت بانکی'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 190,
            child: Card(
              elevation: 7,
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 40),
              child: Container(
                  height: 180,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Text("شماره کارت بانکی شما برای ..."),
                        ),
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "شماره کارت"),
                      ),
                    ],
                  )),
            ),
          ),
          RaisedButton(
            onPressed: () {},
            color: AppColors.main_color,
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 100,
              child: Text(
                "ثبت",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
