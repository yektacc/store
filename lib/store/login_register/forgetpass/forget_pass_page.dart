import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_bloc.dart';
import 'package:store/store/login_register/login/login_bloc.dart';
import 'package:store/store/login_register/login/login_event_state.dart';

import 'forget_pass_event_state.dart';

class ForgetPassPage extends StatefulWidget {
  @override
  _ForgetPassPageState createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPassController = TextEditingController();

  ForgetPassBloc _bloc;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = Provider.of<ForgetPassBloc>(context);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: AppColors.second_color,
      body: Form(
          key: _formKey,
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, ForgetPassState state) {
              if (state is WaitingForOtp) {
                return _buildOtpEntry(state);
              } else if (state is OtpSuccessful) {
                return _buildNewPassEntry(state);
              } else if (state is PasswordChanged) {
                return _buildPasswordChanged(state);
              } else if (state is WaitingForPhone) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  alignment: Alignment.center,
                  child: _buildPhoneEntry(state),
                );
              } else if (state is ForgetPassFailed) {
                Helpers.showToast(
                    state.msg == '' ? 'خطا!، مجددا تلاش نمایید' : state.msg);
                return Container();
              } else if (state is LoadingForgetPass) {
                return LoadingIndicator();
              } else {
                return Container();
              }
            },
          )),
    );
  }

  Widget _buildPhoneEntry(WaitingForPhone state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            color: Colors.white,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: "شماره موبایل", hintStyle: TextStyle(fontSize: 13)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'شماره موبایل وارد نشده است';
                } else if (!(value.startsWith("09") && value.length == 11 ||
                    value.startsWith("+989") && value.length == 13 ||
                    value.startsWith("00989") && value.length == 14)) {
                  return 'شماره موبایل وارد شده صحیح نمی باشد';
                }
                return null;
              },
            ),
            padding: EdgeInsets.only(left: 50, right: 50, top: 12)),
        Container(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.only(bottom: 16, top: 16),
            child: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _bloc.dispatch(AttemptPassChange(phoneController.text));
                }
              },
              child: Container(
                height: 34,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.second_color),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text("تایید",
                    style:
                    TextStyle(fontSize: 13, color: AppColors.second_color)),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Text(
            state.prevErr ?? "",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _buildOtpEntry(WaitingForOtp state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            color: Colors.white,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: otpController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: "کد", hintStyle: TextStyle(fontSize: 13)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'کد وارد نشده است';
                } else if (value.length != 6) {
                  return 'کد وارد شده صحیح نمی باشد';
                }
                return null;
              },
            ),
            padding: EdgeInsets.only(left: 50, right: 50, top: 12)),
        Container(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.only(bottom: 16, top: 16),
            child: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _bloc.dispatch(AttemptOtpCheck(
                      otpController.text, phoneController.text));
                }
              },
              child: Container(
                height: 34,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.second_color),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  "تایید",
                  style: TextStyle(fontSize: 13, color: AppColors.second_color),
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Text(
            state.err ?? "",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _buildNewPassEntry(OtpSuccessful state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            color: Colors.white,
            child: TextFormField(
              controller: newPassController,
              textAlign: TextAlign.center,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "رمزعبور جدید", hintStyle: TextStyle(fontSize: 13)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'رمز عبور وارد نشده است';
                } else if (value.length < 5) {
                  return 'رمزعبور باید حداقل ۵ کاراکتر باشد';
                }
                return null;
              },
            ),
            padding: EdgeInsets.only(left: 50, right: 50, top: 12)),
        Container(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.only(bottom: 16, top: 16),
            child: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _bloc.dispatch(SubmitNewPass(
                      newPassController.text, phoneController.text));
                }
              },
              child: Container(
                height: 34,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.second_color),
                    borderRadius: BorderRadius.all(
                        Radius.circular(30))),
                child: Text(
                  "تغییر رمز عبور",
                  style: TextStyle(fontSize: 13, color: AppColors.second_color),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  StreamSubscription loginBlocSubscription;

  Widget _buildPasswordChanged(PasswordChanged state) {
    var loginBloc = Provider.of<LoginBloc>(context);
    print('newwpaass:: ${newPassController.text}');
    loginBloc
        .dispatch(AttemptLogin(phoneController.text, newPassController.text));

    loginBlocSubscription = loginBloc.state.listen((state) {
      if (state is LoginSuccessful) {
        Navigator.popAndPushNamed(context, HomePage.routeName);
        Navigator.pop(context);
        loginBlocSubscription.cancel();
      }
    });

    return Container(
      alignment: Alignment.center,
      child: Text(
        "رمز عبور بروزرسانی شد !",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
