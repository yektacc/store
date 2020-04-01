import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/store/management/management_login_bloc.dart';
import 'package:store/store/management/management_login_event_state.dart';

import 'management_home_page.dart';

class ManagerLoginPage extends StatefulWidget {
  @override
  _ManagerLoginPageState createState() => _ManagerLoginPageState();
}

class _ManagerLoginPageState extends State<ManagerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  ManagerLoginBloc _managerLoginBloc;
  bool error = false;

  /*final*/
  String phoneController = /*TextEditingController()*/ '';
  final passController = TextEditingController();
  var loggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (_managerLoginBloc == null) {
      _managerLoginBloc = Provider.of<ManagerLoginBloc>(context);
    }

    _managerLoginBloc.state.listen((state) {
      print('management login state: $state $loggedIn');
      if (state is ManagerLoggedIn && !loggedIn) {
        loggedIn = true;

        print(
            'manager logged in state, identifiers: ${state.user
                .centerIdentifiers}');

        Navigator.of(context).popAndPushNamed(ManagementHomePage.routeName);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'ورود فروشندگان',
        backgroundColor: AppColors.second_color,
        elevation: 0,
      ),
      body: new Container(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: new Center(
            child: new Container(
              color: AppColors.second_color,
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
                                _managerLoginBloc.dispatch(ShopManagerLogin(
                                    phoneController,
                                    passController.text.toString()));
                              }
                            },
                            child: Container(
                              height: 34,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.second_color,
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
                                        color: AppColors.second_color,
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
