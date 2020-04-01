import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/common/widgets/form_fields.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/store/location/provinces/model.dart';

import 'address_bloc.dart';
import 'address_bloc_event.dart';
import 'model.dart';

class AddressAddEditPage extends StatefulWidget {
  final bool edit;
  final Address address;
  final int sessionId;

  AddressAddEditPage(this.edit, {this.address, this.sessionId});

  @override
  _AddressAddEditPageState createState() => _AddressAddEditPageState();
}

class _AddressAddEditPageState extends State<AddressAddEditPage> {
  final _formKey = GlobalKey<FormState>();

  final addressController = TextEditingController();
  final fullNameController = TextEditingController();
  final postalCodeController = TextEditingController();
  final phoneController = TextEditingController();

  City currentCity;
  Province currentProvince;

  bool cityErr = false;

  @override
  Widget build(BuildContext context) {
    if (widget.edit) {
      if (fullNameController.text.isEmpty) {
        fullNameController.text = widget.address.fullName;
      }

      if (addressController.text.isEmpty) {
        addressController.text = widget.address.address;
      }

      if (phoneController.text.isEmpty) {
        phoneController.text = widget.address.phone;
      }

      if (postalCodeController.text.isEmpty) {
        postalCodeController.text = widget.address.postalCode;
      }

      if (currentCity == null) {
        currentProvince = Provider.of<ProvinceRepository>(context)
            .getProvinceCity(widget.address.provinceId, widget.address.cityId)
            .province;

        print('getting initial prov ones: $currentProvince');
      }

      if (currentCity == null) {
        currentCity = Provider.of<ProvinceRepository>(context)
            .getProvinceCity(widget.address.provinceId, widget.address.cityId)
            .city;
        print('getting initial city ones: $currentCity');
      }
    }

    return new Scaffold(
        appBar: CustomAppBar(
          titleText: widget.edit ? 'ویرایش آدرس' : 'ایجاد آدرس',
        ),
        body: Container(
          color: Colors.grey[200],
          child: new Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 70),
                ),
                new Container(
                  color: Colors.grey[50],
                  child: FormFields.text('نام', fullNameController,
                      icon: Icons
                          .person) /*TextFormField(
                    style: TextStyle(fontSize: 13),
                    controller: fullNameController,
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
                  )*/
                  ,
                ),
                new Container(
                  color: Colors.grey[50],
                  child: FormFields.phone(controller: phoneController),
                ),
                new Container(
                  color: Colors.grey[50],
                  child: FormFields.text('کد پستی', postalCodeController,
                      icon: Icons.local_post_office),
                ),
                new Container(
                  color: Colors.grey[50],
                  child: ProvinceCitySelectionRow(
                    (province, city) {
                      currentCity = city;
                      currentProvince = province;
                    },
                    initialCity: currentCity,
                    initialProvince: currentProvince,
                  ),
                ),
                cityErr
                    ? Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 60),
                        height: 30,
                        child: Text(
                          "شهر و استان را انتخاب کنید",
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      )
                    : Container(),
                new Container(
                  color: Colors.grey[100],
                  child: FormFields.big('آدرس',
                      addressController) /*TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: 13),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: addressController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        icon: Icon(Icons.location_on),
                        hintText: "آدرس",
                        hintStyle: TextStyle(fontSize: 13)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'لطفا این فیلد را تکمیل کنید';
                      }
                      return null;
                    },
                  )*/
                  ,
                ),
                new Container(
                  color: Colors.grey[50],
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 18.0, bottom: 14),
                  child: Center(
                    child: FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (widget.edit) {
                            Provider.of<AddressBloc>(context).dispatch(
                                EditAddress(
                                    Address(
                                        widget.address.id,
                                        addressController.text,
                                        currentCity.name,
                                        currentCity.id,
                                        currentProvince.id,
                                        fullNameController.text,
                                        phoneController.text,
                                        postalCodeController.text,
                                        true),
                                    1));
                            Navigator.pop(context);
                          } else {
                            Provider.of<AddressBloc>(context).dispatch(
                                AddAddress(
                                    AddAddressItem(
                                        postalCodeController.text,
                                        addressController.text,
                                        currentCity.id,
                                        fullNameController.text,
                                        phoneController.text),
                                    widget.sessionId));
                            Navigator.pop(context);
                          }

                          /* Provider.of<AddressBloc>(context).dispatch(
                              FetchAddresses(widget.sessionId,
                                  forceUpdate: true));*/
                        }

                        if (currentProvince == null || currentCity == null) {
                          cityErr = true;
                          setState(() {});
                        }

                        if (currentProvince != null && currentCity != null) {
                          cityErr = false;
                          setState(() {});
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
                          widget.edit ? 'ثبت تغییرات' : 'ثبت آدرس',
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

/*class CitySelection extends StatefulWidget {
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
        */ /*bloc.dispatch(FetchProvinces());
        bloc.state.listen((newState) =>
        newState is ProvincesLoaded ? widget.provinces = newState.provinces)*/ /*
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
            items: (<Province>[UnknownProvince()] */ /* + widget.provinces*/ /*)
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
            items: (<City>[UnknownCity()] */ /*+ provinceValue.cities*/ /*)
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
}*/
