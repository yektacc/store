import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/common/widgets/form_fields.dart';
import 'package:store/data_layer/management/seller_request_repository.dart';
import 'package:store/store/location/provinces/model.dart';

class SellerRequestPage extends StatefulWidget {
  final int appUserId;

  const SellerRequestPage(this.appUserId);

  @override
  _SellerRequestPageState createState() => _SellerRequestPageState();
}

class _SellerRequestPageState extends State<SellerRequestPage> {
  final _formKey = GlobalKey<FormState>();

  SellerRequestRepository _sellerRequestRepository;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final jobInfoController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final extraInfoController = TextEditingController();
  City currentCity;
  Province currentProvince;
  final BehaviorSubject<bool> cityProvinceRequired =
      BehaviorSubject.seeded(false);

  @override
  void dispose() {
    cityProvinceRequired.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sellerRequestRepository == null) {
      _sellerRequestRepository = Provider.of<SellerRequestRepository>(context);
    }

    return Scaffold(
        appBar: CustomAppBar(
          titleText: 'ثبت درخواست فروشندگی',
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              FormFields.text('نام', firstNameController,
                  icon: Icons.person, key: _formKey),
              FormFields.text('نام خانوادگی', lastNameController,
                  icon: Icons.person_outline, key: _formKey),
              FormFields.text('توضیح شغل', jobInfoController,
                  icon: Icons.work, key: _formKey),
              FormFields.phone(
                  title: 'شماره تماس:',
                  controller: phoneController,
                  key: _formKey),
              FormFields.big('آدرس', addressController, key: _formKey),
              FormFields.text('اطلاعات دیگر', extraInfoController,
                  icon: Icons.add, key: _formKey),
              Padding(
                padding: EdgeInsets.only(right: 10, left: 8, top: 15),
                child: ProvinceCitySelectionRow((p, c) {
                  currentCity = c;
                  currentProvince = p;
                  setState(() {});
                }, required: cityProvinceRequired),
              ),
              Container(
                padding: EdgeInsets.all(30),
                alignment: Alignment.center,
                child: RaisedButton(
                  color: Colors.grey[100],
                  child: Container(
                    child: Text(
                      'ثبت درخواست',
                      style: TextStyle(color: AppColors.main_color),
                    ),
                  ),
                  onPressed: () async {
                    cityProvinceRequired.add(true);
                    if (_formKey.currentState.validate()) {
                      if (currentProvince != null && currentCity != null) {
                        bool success =
                            await _sellerRequestRepository.sendRequest(
                                widget.appUserId,
                                firstNameController.text,
                                lastNameController.text,
                                currentProvince.id,
                                currentCity.id,
                                jobInfoController.text,
                                phoneController.text,
                                addressController.text,
                                extraInfoController.text);
                        if (success) {
                          Helpers.showToast('درخواست شما با موفقیت ثبت شد');
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        } else {
                          Helpers.errorToast();
                        }
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
