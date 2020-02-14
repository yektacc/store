import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/location/provinces/model.dart';
import 'package:store/store/payment/zarin_pal/client.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lost_pets_bloc.dart';
import 'lost_pets_event_state.dart';
import 'lost_pets_page.dart';
import 'lost_pets_repository.dart';
import 'model.dart';

class FCRequestPage extends StatefulWidget {
  final bool isAdoption;

  FCRequestPage(this.isAdoption);

  @override
  _FCRequestPageState createState() => _FCRequestPageState();
}

class _FCRequestPageState extends State<FCRequestPage> {
  LostPetReqType currentType;
  List<AnimalType> allTypes;

  LostPetsBloc _bloc;

  //fields
  AnimalType currentAnimalType;
  City currentCity;
  Province currentProvince;
  int currentGender;
  DateTime currentTime;
  int currentAge;
  String currentLocation;
  String currentPhone;
  String currentName;
  String currentDescription;
  int currentCost;

  PersianDatePickerWidget persianDatePicker;

  final TextEditingController dateController = TextEditingController();

  List<LostPetReqType> requestTypes;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    persianDatePicker = PersianDatePicker(
      controller: dateController,
    ).init();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = Provider.of<LostPetsBloc>(context);
    }

    requestTypes = !widget.isAdoption
        ? [
            LostPetReqType(2, "پیدا شده ها", "", 20000),
            LostPetReqType(1, "گمشده ها", "", 10000),
          ]
        : [
            LostPetReqType(3, "واگذاری سرپرستی", "", 10000),
            LostPetReqType(4, "برعهده گیری سرپرستی", "", 20000),
          ];

    return Scaffold(
        backgroundColor: Colors.grey[100],
        /*     floatingActionButton: currentType != null
            ? FloatingActionButton(
                onPressed: () {},
                child: Text("ثبت"),
              )
            : null,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,*/
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              "ثبت درخواست جدید",
              style: TextStyle(fontSize: 16, color: AppColors.main_color),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.grey[100],
          iconTheme: IconThemeData(color: AppColors.main_color),
        ),
        body: currentType == null
            ? Container(
                margin: EdgeInsets.only(top: 80, right: 14, left: 14),
                child: ListView(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(70),
                          color: Colors.grey[200]),
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      child: FlatButton(
                        child: Text(
                          requestTypes[0].name,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        onPressed: () {
                          setState(() {
                            currentType = requestTypes[0];
                          });
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(70),
                          color: Colors.grey[200]),
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      child: FlatButton(
                        child: Text(requestTypes[1].name,
                            style: TextStyle(color: Colors.grey[600])),
                        onPressed: () {
                          setState(() {
                            currentType = requestTypes[1];
                          });
                        },
                      ),
                    ),
                  ],
                ))
            : new FormBuilder(
                key: _formKey,
                initialValue: {
                  'accept_terms': false,
                },
                child: new Container(
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  child: new ListView(
                    children: <Widget>[
                      new Container(
                        color: Colors.grey[100],
                        margin: EdgeInsets.only(top: 14),
                        child: Container(
                          child: new Column(
                            children: <Widget>[
                              new FutureBuilder(
                                future: Provider.of<LostPetsRepository>(context)
                                    .getAnimalTypes(),
                                builder: (context,
                                    AsyncSnapshot<List<AnimalType>> snapshot) {
                                  if (snapshot.data != null &&
                                      snapshot.data.isNotEmpty) {
                                    List<AnimalType> types = [];

                                    if (allTypes != null &&
                                        allTypes.isNotEmpty) {
                                      types = allTypes;
                                    } else if (snapshot.data != null &&
                                        snapshot.data.isNotEmpty) {
                                      types = snapshot.data;
                                      allTypes = types;
                                    }

                                    return new FormBuilderDropdown(
                                      attribute: "type",
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Colors.white,
                                          filled: true),
                                      // initialValue: 'Male',
                                      hint: Center(
                                        child: Text(
                                          'نوع حیوان: ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[800]),
                                        ),
                                      ),
                                      validators: [
                                        FormBuilderValidators.required()
                                      ],
                                      onChanged: (type) {
                                        currentAnimalType =
                                            (type as AnimalType);
                                      },
                                      items: types
                                          .map((type) => DropdownMenuItem(
                                              value: type,
                                              child: Center(
                                                child: Text(
                                                  "${type.title}",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.main_color),
                                                ),
                                              )))
                                          .toList(),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, right: 16, left: 18),
                                child: new ProvinceCitySelectionRow((p, c) {
                                  currentProvince = p;
                                  currentCity = c;
                                }),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: FormBuilderTextField(
                                  onChanged: (text) {
                                    currentLocation = text;
                                  },
                                  attribute: "age",
                                  decoration: InputDecoration(
                                      labelText: "محلِ گم شدن / پیدا شدن",
                                      hintStyle: TextStyle(fontSize: 13),
                                      labelStyle: TextStyle(fontSize: 13)),
                                  validators: [
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.max(70),
                                  ],
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  children: <Widget>[
                                    Text("جنسیت: "),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: RadioButtonGroup(
                                          orientation: GroupedButtonsOrientation
                                              .HORIZONTAL,
                                          labels: [
                                            "     نمی دانم     ",
                                            "      ماده      ",
                                            "        نر        ",
                                          ],
                                          onSelected: (selected) {
                                            switch (selected) {
                                              case "     نمی دانم     ":
                                                currentGender = 0;
                                                break;

                                              case "      ماده      ":
                                                currentGender = 2;
                                                break;

                                              case "        نر        ":
                                                currentGender = 1;
                                                break;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      !widget.isAdoption
                          ? Column(
                              children: <Widget>[
                                new Container(
                                  color: Colors.grey[300],
                                  width: double.infinity,
                                  child: Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 70),
                                    child: FormBuilderDateTimePicker(
                                      attribute: "time",
                                      inputType: InputType.time,
                                      onChanged: (dateTime) {
                                        currentTime = dateTime;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: "زمان:",
                                          icon: Icon(
                                            Icons.access_time,
                                            color: AppColors.main_color,
                                            size: 18,
                                          )),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  color: Colors.grey[200],
                                  padding: EdgeInsets.symmetric(horizontal: 70),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          Icons.date_range,
                                          size: 18,
                                          color: AppColors.main_color,
                                        ),
                                        hintText: 'تاریخ'),
                                    enableInteractiveSelection: false,
                                    // *** this is important to prevent user interactive selection ***
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(
                                          new FocusNode()); // to prevent opening default keyboard
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return persianDatePicker;
                                          });
                                    },
                                    controller: dateController,
                                  ),
                                )
                              ],
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: FormBuilderTextField(
                                onChanged: (text) {
                                  currentPhone = text;
                                },
                                attribute: "ag",
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: "وضعیت عقیم سازی",
                                    hintStyle: TextStyle(fontSize: 13),
                                    labelStyle: TextStyle(fontSize: 13)),
                                validators: [
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.max(70),
                                ],
                              ),
                            ),
                      new Container(
                        margin: EdgeInsets.only(top: 30, bottom: 40),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: FormBuilderTextField(
                                  onChanged: (text) {
                                    currentAge = text;
                                  },
                                  attribute: "age",
                                  decoration: InputDecoration(
                                      labelText: "سن",
                                      hintStyle: TextStyle(fontSize: 13),
                                      labelStyle: TextStyle(fontSize: 13)),
                                  validators: [
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.max(70),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: FormBuilderTextField(
                                onChanged: (text) {
                                  currentName = text;
                                },
                                attribute: "name",
                                decoration: InputDecoration(
                                    labelText: "نام حیوان",
                                    hintStyle: TextStyle(fontSize: 13),
                                    labelStyle: TextStyle(fontSize: 13)),
                                validators: [
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.max(70),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                      new Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.main_color),
                            borderRadius: BorderRadius.circular(5)),
                        height: 100,
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 9),
                        child: TextField(
                          onChanged: (text) {
                            currentDescription = text;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          minLines: 3,
                          decoration: InputDecoration(
                              labelText: "توضیحات",
                              labelStyle: TextStyle(fontSize: 12)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: FormBuilderTextField(
                          onChanged: (text) {
                            currentPhone = text;
                          },
                          attribute: "phone",
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.phone,
                                color: Colors.grey[300],
                              ),
                              labelText: "شماره تلفن",
                              hintStyle: TextStyle(fontSize: 13),
                              labelStyle: TextStyle(fontSize: 13)),
                          validators: [
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(70),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: FormBuilderTextField(
                          onChanged: (text) {
                            currentCost = text;
                          },
                          attribute: "phone",
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: "مقدار مژدگانی؟",
                              hintStyle: TextStyle(fontSize: 13),
                              labelStyle: TextStyle(fontSize: 13)),
                          validators: [
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(70),
                          ],
                        ),
                      ),
                      /*new Container(
                        height: 100,
                        color: Colors.grey[200],
                        child: new Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text("نوع آگهی: "),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: RadioButtonGroup(
                                  orientation:
                                      GroupedButtonsOrientation.VERTICAL,
                                  labels: [
                                    "نوع اول (توضیحات)",
                                    "نوع دوم (توضیحات)",
                                  ],
                                  onSelected: (selected) {
                                    switch (selected) {
                                      case "نوع اول (توضیحات)":
                                        print(selected);
                                        break;

                                      case "نوع دوم (توضیحات)":
                                        print(selected);
                                        break;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                      RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("اعمال بدون پرداخت (تستی)"),
                        color: Colors.blue,
                        onPressed: () {
                          print("date:" + dateController.text);

                          /* PersianDate pDate =
                              PersianDate();*/

                          /*    PersianDate pDate = PersianDate();

                          print("Now ${pDate.getDate}");

                          var gDate = pDate.jalaliToGregorian("${pDate.now}");*/

//                          print(gDate);

                          PersianDateTime persianDT = PersianDateTime(jalaaliDateTime: dateController.text);
                          String finalDate =  persianDT.toGregorian() + " ${currentTime.hour}:${currentTime.minute}:${currentTime.second}";
                          print('final date: ' + finalDate);

                          _bloc.dispatch(RegisterLostPet(LostPet(
                              city: currentCity,
                              lostDate: finalDate ,
                              name: currentName,
                              age: currentAge.toString(),
                              reqType: currentType,
                              animalType: currentAnimalType,
                              description: currentDescription,
                              gender: currentGender,
                              phone: currentPhone,
                              province: currentProvince,
                              location: currentLocation)));
                        },
                      ),
                      new Container(
                        height: 70,
                        child: GestureDetector(
                          onTap: () {
                            ZarinPalClient()
                                .getPaymentURL(
                                    ZPPaymentRequest((20000).toString()))
                                .then((res) {
                              if (res is ZPPaymentSuccessResponse) {
                                launch(res.getURL());
                                ZarinPalClient()
                                    .verifyPayment(ZPVerifyRequest(
                                        res.authority, "200000"))
                                    .then((zpresponse) {
                                  if (zpresponse is ZPVerifySuccessResponse) {
                                    ///success
                                  } else {
                                    ///failure
                                  }
                                });
                              } else {}
                            });
                          },
                          child: Card(
                            elevation: 8,
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 8),
                            color: Colors.greenAccent[200],
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 14),
                                  child: Icon(Icons.check),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child:
                                        Text("پرداخت ۲۰،۰۰۰ تومان و ثبت آگهی"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}

/*class RequestItem {
  final int id;
  final String name;

  RequestItem(this.name, this.id);
}*/

/*
class DatePickerA extends StatefulWidget {
  String date = '';

  @override
  _State createState() => new _State();
}
*/

/*
class _State extends State<DatePickerA> {
*/
/*
  PersianDate persianDate = PersianDate();
  String _format = 'yyyy-mm-dd';
  String _value = '';
  String _valuePiker = '';
*/ /*


  */
/*Future _selectDate() async {
    String picked = await jalaliCalendarPicker(context: context);
    if (picked != null) setState(() => _value = picked.toString());
  }*/ /*


  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.grey[200],
      width: double.infinity,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 70),
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: _showDatePicker,
                child: Container(
                  height: 70,
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.date_range),
                      Padding(
                        child: Text(
                          'تاریخ:',
                          style: TextStyle(fontSize: 15),
                        ),
                        padding: EdgeInsets.only(right: 10),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(widget.date),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Display date picker.
  void _showDatePicker() {
    final bool showTitleActions = false;
    */
/* DatePicker.showDatePicker(context,
        minYear: 1395,
        maxYear: 1400,
*/ /*
 */
/*      initialYear: 1368,
      initialMonth: 05,
      initialDay: 30,*/ /*
 */
/*
        confirm: Text(
          'تایید',
          style: TextStyle(color: Colors.red),
        ),
        cancel: Text(
          'لغو',
          style: TextStyle(color: Colors.cyan),
        ),
        dateFormat: _format, onChanged: (year, month, day) {
      if (!showTitleActions) {
        _changeDatetime(year, month, day);
      }
    }, onConfirm: (year, month, day) {
      _changeDatetime(year, month, day);
      _valuePiker =
          " تاریخ ترکیبی : ${widget.date}  \n سال : $year \n  ماه :   $month \n  روز :  $day";
    });*/ /*

  }

  void _changeDatetime(int year, int month, int day) {
    setState(() {
      widget.date = '$year-$month-$day';
    });
  }
}
*/
