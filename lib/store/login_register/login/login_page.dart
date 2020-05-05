import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/app.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_bloc.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_event_state.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_page.dart';

import 'login_bloc.dart';
import 'login_event_state.dart';

class LoginPage extends StatefulWidget {
  LoginBloc _bloc;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void login(String phone, String password) {
    widget._bloc.dispatch(AttemptLogin(phone, password));
  }

  @override
  Widget build(BuildContext context) {
    if (widget._bloc == null) {
      widget._bloc = Provider.of<LoginBloc>(context);
    }

    return Scaffold(
        appBar: CustomAppBar(
          titleText: 'ورود',
          elevation: 0,
        ),
        body: new Container(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: new Center(
              child: new Container(
                color: AppColors.main_color,
                child: new BlocBuilder(
                  bloc: widget._bloc,
                  builder: (context, LoginState state) {
                    if (state is LoginFailed) {
                      return Container(
                        child: new Form(
                          key: _formKey,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  color: Colors.white,
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: phoneController,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.phone,
                                          size: 22,
                                        ),
                                        hintStyle: TextStyle(fontSize: 13),
                                        hintText: "شماره موبایل"),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'شماره موبایل وارد نشده است';
                                      }
                                      return null;
                                    },
                                  ),
                                  padding: EdgeInsets.only(
                                      left: 50, right: 20, top: 14)),
                              Container(
                                color: Colors.white,
                                child: TextFormField(
                                  textDirection: TextDirection.ltr,
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
                                padding: EdgeInsets.only(
                                    left: 50, right: 20, top: 12),
                              ),
                              Container(
                                color: Colors.white,
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    top: 18.0, bottom: 18),
                                child: Center(
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        login(phoneController.text,
                                            passController.text);
                                      }
                                    },
                                    child: Container(
                                      height: 34,
                                      width: 100,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.main_color),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Text(
                                        'ورود',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.main_color),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey[100],
                                child: Center(
                                  child: FlatButton(
                                    onPressed: () {
                                      Provider.of<ForgetPassBloc>(context)
                                          .dispatch(ResetForgetPass());
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgetPassPage()));
                                    },
                                    child: Text(
                                      'فراموشی رمز عبور',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Center(
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          AppRoutes.registerPage(context));
                                    },
                                    child: Text(
                                      'ثبت نام',
                                      style: TextStyle(fontSize: 13),
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
                                    child: Text(
                                      state.getErrorText(),
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )
                            ],
                          ),
                        ),
                      );
                    } else if (state is LoadingLoginAttempt) {
                      return Center(
                        child: new Center(child: LightLoadingIndicator()),
                      );
                    } else if (state is LoginSuccessful) {
                      Navigator.of(context).pop();
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
