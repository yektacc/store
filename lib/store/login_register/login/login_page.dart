import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/app.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_bloc.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_event_state.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_page.dart';

import 'login_bloc.dart';
import 'login_event_state.dart';
import 'login_interactor.dart';

class LoginPage extends StatefulWidget {
  LoginBloc _bloc;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

/*  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
*/ /*
    Provider.of<LoginBloc>(context).dispatch(Reset());
*/ /*
  }*/

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

/*
    widget._bloc.event.listen((event) {
      print("loginevent: $event");
    });*/

    return Scaffold(
        appBar: AppBar(elevation: 0,),
        body: new Container(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: new Center(
              child: new Container(
                color: AppColors.second_color,
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
                                              color: AppColors.second_color),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Text(
                                        'ورود',
                                        style: TextStyle(fontSize: 13,
                                            color: AppColors.second_color),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey[100],
                                child: Center(
                                  child: FlatButton(
                                    textColor: Colors.blueGrey,
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
                                    textColor: Colors.blueGrey,
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
                                    child: state.error ==
                                            LoginError.CREDENTIALS_MISMATCH
                                        ? Text(
                                            "نام کاربری یا کلمه عبور صحیح نمی باشد!",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : Container()),
                              )
                            ],
                          ),
                        ),
                      );
                    } else if (state is LoadingLoginAttempt) {
                      return Center(
                        child: new Center(child: LoadingIndicator()),
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
