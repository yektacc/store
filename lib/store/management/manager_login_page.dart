import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/common/widgets/form_fields.dart';
import 'package:store/store/management/management_login_event_state.dart';
import 'package:store/store/management/manager_login_bloc.dart';

import 'management_home_page.dart';

class ManagerLoginPage extends StatefulWidget {
  static const String routeName = 'managerlogin';

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 50),
                          color: Colors.white,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  child: FormFields.text('نام کاربری', null,
                                      noBorder: true,
                                      icon: Icons.person, onChange: (newText) {
                                        phoneController = newText;
                                      }, validator: (value) {
                                        if (value.isEmpty) {
                                          return 'نام کاربری وارد نشده است';
                                        }
                                        return null;
                                      }),
                                  padding: EdgeInsets.only(top: 14)),
                              Container(
                                child: FormFields.password(
                                    'رمز عبور', passController,
                                    noBorder: true),
                                padding: EdgeInsets.only(),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    top: 18.0, bottom: 18),
                                child: Center(
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _managerLoginBloc.dispatch(
                                            ShopManagerLogin(
                                                phoneController,
                                                passController.text
                                                    .toString()));
                                      }
                                    },
                                    child: Container(
                                      height: 34,
                                      width: 100,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.second_color,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Text(
                                        'ورود',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
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
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
