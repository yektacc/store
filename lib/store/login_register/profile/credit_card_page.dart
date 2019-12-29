import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/common/constants.dart';

class CreditCardPage extends StatefulWidget {
  @override
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  final prefKey = 'CREDIT_CARD';

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

  String mergedNumbers;


  /*@override
  void initState() {
    SharedPreferences.getInstance().then((pref) {
      pref.remove(prefKey);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((pref) {
      if (pref.containsKey(prefKey)) {
        setState(() {
          mergedNumbers = pref.getString(prefKey);
        });
      }
    });

    if (mergedNumbers != null) {
      controller1.text = mergedNumbers.substring(0, 4);
      controller2.text = mergedNumbers.substring(4, 8);
      controller3.text = mergedNumbers.substring(8, 12);
      controller4.text = mergedNumbers.substring(12, 16);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('کارت بانکی'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Card(
              elevation: 7,
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 40),
              child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        child: Center(
                          child: Text(
                            " شماره کارت بانکی جهت بازگشت وجه",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(4)),
                          color: mergedNumbers == null
                              ? Colors.grey[100]
                              : Colors.green[100],
                        ),
                        height: 80,
                        child: Form(
                          child: Row(
                            textDirection: TextDirection.ltr,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: controller1,
                                  maxLength: 4,
                                  autofocus: true,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(counterText: ''),
                                  /*  onFieldSubmitted: (v) {
                                },*/
                                  onChanged: (newText) {
                                    if (newText.length == 4) {
                                      FocusScope.of(context).requestFocus(
                                          focus1);
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: controller2,
                                  focusNode: focus1,
                                  maxLength: 4,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(counterText: ''),
                                  onChanged: (newText) {
                                    if (newText.length == 4) {
                                      FocusScope.of(context).requestFocus(
                                          focus2);
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: controller3,
                                  focusNode: focus2,
                                  maxLength: 4,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(counterText: ''),
                                  onChanged: (newText) {
                                    if (newText.length == 4) {
                                      FocusScope.of(context).requestFocus(
                                          focus3);
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: controller4,
                                  focusNode: focus3,
                                  maxLength: 4,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(counterText: ''),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          RaisedButton(
            onPressed: () async {
              var merged = controller1.text +
                  controller2.text +
                  controller3.text +
                  controller4.text;
              print(merged);
              if (merged.length == 16 && double.parse(merged) != null) {
                var pref = await SharedPreferences.getInstance();

                pref.setString(prefKey, merged).then((success) {
                  if (success) {
                    Helpers.showToast('اطلاعات کارت شما ثبت شد');
                    setState(() {
                      mergedNumbers = merged;
                    });
                  } else {
                    Helpers.showDefaultErr();
                  }
                });
              } else {
                Helpers.showToast('شماره کارت صحیح نمی‌باشد');
              }
            },
            color: AppColors.main_color,
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 100,
              child: Text(mergedNumbers == null ?
              "ثبت" : 'تغییر',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
