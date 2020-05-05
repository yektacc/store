import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/store/location/provinces/model.dart';
import 'package:store/store/location/provinces/provinces_bloc.dart';
import 'package:store/store/location/provinces/provinces_bloc_event.dart';
import 'package:store/store/login_register/profile/profile_bloc_event_state.dart';
import 'package:store/store/login_register/profile/profile_repository.dart';

import 'model.dart';
import 'profile_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  final Profile profile;

/*
  final String sessionId;
*/

  ProfileEditPage(this.profile /*, this.sessionId*/);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nationalCodeController = TextEditingController();
  final creditCardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.profile.firstName;
    lastNameController.text = widget.profile.lastName;
    phoneController.text = widget.profile.phone;
    emailController.text = widget.profile.email;
    nationalCodeController.text = widget.profile.nationalCode;
    creditCardController.text = widget.profile.creditCardNo;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: CustomAppBar(
          elevation: 0,
          titleText: "ویرایش پروفایل",
        ),
        body: Container(
          color: AppColors.main_color,
          child: new Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  color: Colors.grey[50],
                  child: TextFormField(
                    style: TextStyle(fontSize: 13),
                    controller: firstNameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: "نام",
                        hintStyle: TextStyle(fontSize: 13)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'لطفا این فیلد را تکمیل کنید';
                      }
                      return null;
                    },
                  ),
                  padding: EdgeInsets.only(left: 50, right: 20, top: 12),
                ),
                new Container(
                  color: Colors.grey[50],
                  child: TextFormField(
                    style: TextStyle(fontSize: 13),
                    controller: lastNameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person_outline),
                        hintText: "نام خانوادگی",
                        hintStyle: TextStyle(fontSize: 13)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'لطفا این فیلد را تکمیل کنید';
                      }
                      return null;
                    },
                  ),
                  padding: EdgeInsets.only(left: 50, right: 20, top: 12),
                ),
/*                new Container(
                    color: Colors.grey[50],
                    child: TextFormField(
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
                          return null;
                        } else if (!(value.startsWith("09") &&
                                value.length == 11 ||
                            value.startsWith("+989") && value.length == 13 ||
                            value.startsWith("00989") && value.length == 14)) {
                          return 'شماره موبایل وارد شده صحیح نمی باشد';
                        }
                        return null;
                      },
                    ),
                    padding: EdgeInsets.only(left: 50, right: 20, top: 12)),*/
                new Container(
                    color: Colors.grey[50],
                    child: TextFormField(
                      style: TextStyle(fontSize: 13),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: "ایمیل",
                          hintStyle: TextStyle(fontSize: 13)),
                    ),
                    padding: EdgeInsets.only(left: 50, right: 20, top: 12)),
                new Container(
                    color: Colors.grey[50],
                    child: TextFormField(
                      style: TextStyle(fontSize: 13),
                      keyboardType: TextInputType.number,
                      controller: nationalCodeController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          icon: Icon(Icons.image_aspect_ratio),
                          hintText: " کد ملی جهت تحویل کالا (اختیاری)",
                          hintStyle: TextStyle(fontSize: 13)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return null;
                        } else if (value.length != 10) {
                          return 'کد ملی باید ۱۰ رقم باشد';
                        }
                        return null;
                      },
                    ),
                    padding: EdgeInsets.only(left: 50, right: 20, top: 12)),
                new Container(
                  color: Colors.grey[50],
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 18.0, bottom: 14),
                  child: Center(
                    child: FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Provider.of<ProfileBloc>(context).dispatch(
                              UpdateProfile(EditRequest(Profile(
                                  firstNameController.text,
                                  lastNameController.text,
                                  phoneController.text,
                                  creditCardController.text,
                                  emailController.text,
                                  nationalCodeController.text,
                                  widget.profile.sessionId))));

                          Navigator.pop(context);

                          /*  if (widget.edit) {
                            Provider.of<ProfileBloc>(context).dispatch(
                                EditProfile(
                                    Profile(
                                        widget.profile.id,
                                        lastNameController.text,
                                        UnknownCity(),
                                        firstNameController.text,
                                        phoneController.text),
                                    1));
                            Navigator.pop(context);
                          } else {
                            Provider.of<ProfileBloc>(context).dispatch(Profile(
                                Profile(
                                    0,
                                    lastNameController.text,
                                    UnknownCity(),
                                    firstNameController.text,
                                    phoneController.text),
                                widget.sessionId));
                            Navigator.pop(context);
                          }*/
                        }
                      },
                      child: Container(
                        height: 34,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: AppColors.main_color),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          'ثبت تغییرات',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.main_color),
                        ),
                      ),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 40),
                ),
              ],
            ),
          ),
        ));
  }
}

class CitySelection extends StatefulWidget {
  List<Province> provinces = [];

  CitySelection();

  @override
  _CitySelectionState createState() => _CitySelectionState();
}

class _CitySelectionState extends State<CitySelection> {
  Province provinceValue = UnknownProvince();
  City cityValue = UnknownCity();

  @override
  Widget build(BuildContext context) {
    if (widget.provinces.isEmpty) {
      ProvinceBloc bloc = Provider.of<ProvinceBloc>(context);
      ProvinceState state = bloc.currentState;

      if (state is ProvincesLoaded) {
        widget.provinces = state.provinces;
      } else {
        /*bloc.dispatch(FetchProvinces());
        bloc.state.listen((newState) =>
        newState is ProvincesLoaded ? widget.provinces = newState.provinces)*/
      }
    }

    return new Container(
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          DropdownButton<Province>(
            value: null,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: AppColors.main_color),
            underline: Container(height: 2, color: AppColors.main_color),
            onChanged: (Province newValue) {
              setState(() {
                provinceValue = newValue;
              });
            },
            items: (<Province>[UnknownProvince()] /* + widget.provinces*/)
                .map<DropdownMenuItem<Province>>((Province value) {
              return DropdownMenuItem<Province>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
          DropdownButton<City>(
            value: null,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: AppColors.main_color),
            underline: Container(height: 2, color: AppColors.main_color),
            onChanged: (City newValue) {
              setState(() {
                cityValue = newValue;
              });
            },
            items: (<City>[UnknownCity()] /*+ provinceValue.cities*/)
                .map<DropdownMenuItem<City>>((City value) {
              return DropdownMenuItem<City>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: 12, bottom: 12),
    );
  }
}
