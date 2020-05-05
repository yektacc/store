import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/common/widgets/form_fields.dart';
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
      appBar: CustomAppBar(
        titleText: 'فراموشی رمز عبور',
        elevation: 0,
      ),
      backgroundColor: AppColors.main_color,
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
                return LightLoadingIndicator();
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
            child:
            FormFields.phone(controller: phoneController, noBorder: true),
            padding: EdgeInsets.only(top: 24, bottom: 24)),
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
                    border: Border.all(color: AppColors.main_color),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text("تایید",
                    style:
                    TextStyle(fontSize: 13, color: AppColors.main_color)),
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
            child: FormFields.text(
              "کد تایید",
              otpController,
              noBorder: true,
              noIcon: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'کد وارد نشده است';
                } else if (value.length != 6) {
                  return 'کد وارد شده صحیح نمی باشد';
                }
                return null;
              },
            )),
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
                    border: Border.all(color: AppColors.main_color),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  "تایید",
                  style: TextStyle(fontSize: 13, color: AppColors.main_color),
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
          child: FormFields.password(
            'رمز عبور جدید',
            newPassController,
            noIcon: true,
            noBorder: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'رمز عبور وارد نشده است';
                } else if (value.length < 5) {
                  return 'رمزعبور باید حداقل ۵ کاراکتر باشد';
                }
                return null;
              },
          ),),
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
                    border: Border.all(color: AppColors.main_color),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  "تغییر رمز عبور",
                  style: TextStyle(fontSize: 13, color: AppColors.main_color),
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
