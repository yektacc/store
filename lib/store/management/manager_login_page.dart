import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/management/management_bloc.dart';
import 'package:store/store/management/management_event_state.dart';
import 'package:store/store/management/service/service_management_page.dart';
import 'package:store/store/management/shop/shop_management_page.dart';

class ManagerLoginPage extends StatefulWidget {
  @override
  _ManagerLoginPageState createState() => _ManagerLoginPageState();
}

class _ManagerLoginPageState extends State<ManagerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  ManagementBloc _managementBloc;
  bool error = false;

  /*final*/
  String phoneController = /*TextEditingController()*/ '';
  final passController = TextEditingController();
  var loggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (_managementBloc == null) {
      _managementBloc = Provider.of<ManagementBloc>(context);
    }

    _managementBloc.state.listen((state) {
      print('management login state: $state $loggedIn');
      if (state is SMDataLoaded && !loggedIn) {
        loggedIn = true;

        if (state.services.isNotEmpty) {
          Navigator.of(context)
              .popAndPushNamed(ServiceManagementPage.routeName);
        } else if (state.shops.isNotEmpty) {
          Navigator.of(context).popAndPushNamed(ShopManagementPage.routeName);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ورود فروشندگان',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: new Container(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: new Center(
            child: new Container(
              color: Colors.grey[300],
              child: Container(
                child: new Form(
                  key: _formKey,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          color: Colors.white,
                          child: TextFormField(
                            onChanged: (newText) {
                              phoneController = newText;
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  size: 22,
                                ),
                                hintStyle: TextStyle(fontSize: 13),
                                hintText: "نام کاربری"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'نام کاربری وارد نشده است';
                              }
                              return null;
                            },
                          ),
                          padding:
                              EdgeInsets.only(left: 50, right: 20, top: 14)),
                      Container(
                        color: Colors.white,
                        child: TextFormField(
                          obscureText: true,
                          controller: passController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              size: 22,
                            ),
                            hintText: "رمز عبور",
                            hintStyle: TextStyle(fontSize: 13),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'رمز عبور وارد نشده است';
                            }
                            return null;
                          },
                        ),
                        padding: EdgeInsets.only(left: 50, right: 20, top: 12),
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 18.0, bottom: 18),
                        child: Center(
                          child: FlatButton(
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _managementBloc.dispatch(ShopManagerLogin(
                                    phoneController,
                                    passController.text.toString()));
                                /*  loginSeller(phoneController,
                                        )
                                    .then((List<ShopIdentifier> response) {
                                  if (response.isEmpty) {
                                    setState(() {
                                      error = true;
                                      phoneController = '';
                                      passController.text = '';
                                    });
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SellersListPage(response)));
                                  }
                                });*/
                              }
                            },
                            child: Container(
                              height: 34,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.main_color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Text(
                                'ورود',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 70),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 25),
                        child: Center(
                            child: error
                                ? Text(
                                    "نام کاربری یا کلمه عبور صحیح نمی باشد!",
                                    style: TextStyle(
                                        color: AppColors.main_color,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Container()),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
