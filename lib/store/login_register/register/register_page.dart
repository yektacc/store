import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/login_register/register/register_bloc.dart';
import 'package:store/store/login_register/register/register_event_state.dart';

class RegisterPage extends StatefulWidget {
  RegisterBloc _bloc;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final passConfController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<RegisterBloc>(context).dispatch(ResetRegister());
  }

  @override
  Widget build(BuildContext context) {
    if (widget._bloc == null) {
      widget._bloc = Provider.of<RegisterBloc>(context);
    }

    widget._bloc.state.listen((state) {
      print("register event: $state");
    });

    return new Scaffold(
        appBar: CustomAppBar(
          elevation: 0,
          titleText: 'ثبت‌نام',
        ),
        body: Container(
          color: AppColors.main_color,
          child: new BlocBuilder(
              bloc: widget._bloc,
              builder: (context, state) {
                if (state is InfoSubmission) {
                  return new Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            color: Colors.white,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: phoneController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.phone),
                                  hintText: "شماره موبایل",
                                  hintStyle: TextStyle(fontSize: 13)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'شماره موبایل وارد نشده است';
                                } else if (!(value.startsWith("09") &&
                                        value.length == 11 ||
                                    value.startsWith("+989") &&
                                        value.length == 13 ||
                                    value.startsWith("00989") &&
                                        value.length == 14)) {
                                  return 'شماره موبایل وارد شده صحیح نمی باشد';
                                }
                                return null;
                              },
                            ),
                            padding:
                                EdgeInsets.only(left: 50, right: 20, top: 12)),
                        new Container(
                          color: Colors.white,
                          child: TextFormField(
                            obscureText: true,
                            controller: passController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: "رمز عبور",
                                hintStyle: TextStyle(fontSize: 13)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'رمز عبور وارد نشده است';
                              }
                              return null;
                            },
                          ),
                          padding:
                              EdgeInsets.only(left: 50, right: 20, top: 12),
                        ),
                        new Container(
                          color: Colors.white,
                          child: TextFormField(
                            obscureText: true,
                            controller: passConfController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock_outline),
                                hintText: "تکرار رمز عبور",
                                hintStyle: TextStyle(fontSize: 13)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'تکرار رمز عبور وارد نشده است';
                              } else if (value != passController.text) {
                                return 'رمز عبور با تکرار رمز عبور مطابقت ندارد';
                              }
                              return null;
                            },
                          ),
                          padding:
                              EdgeInsets.only(left: 50, right: 20, top: 12),
                        ),
                        state.currentError != null
                            ? Text(state.currentError.toString())
                            : Container(),
                        new Container(
                          color: Colors.white,
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 18.0, bottom: 14),
                          child: Center(
                            child: FlatButton(
                              textColor: Colors.white,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  widget._bloc.dispatch(AttemptRegister(
                                      phoneController.text,
                                      passController.text));
                                }
                              },
                              child: Container(
                                height: 34,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: AppColors.main_color),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Text(
                                  'ثبت نام',
                                  style: TextStyle(fontSize: 13,
                                      color: AppColors.main_color),
                                ),
                              ),
                            ),
                          ),
                          margin: EdgeInsets.only(bottom: 40),
                        )

                        /*Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            color: Colors.blue,
                            textColor: Colors.black54,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                widget._bloc.dispatch(AttemptRegister(
                                    phoneController.text, passController.text));
                              }
                            },
                            child: Text('ثبت نام'),
                          ),
                        )*/
                        ,
                      ],
                    ),
                  );
                } else if (state is OtpSubmission) {
                  return new Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            color: Colors.white,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: otpController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  hintText: "کد دریافتی",
                                  hintStyle: TextStyle(fontSize: 13)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'کد وارد نشده است';
                                }
                                return null;
                              },
                            ),
                            padding:
                                EdgeInsets.only(left: 50, right: 50, top: 12)),
                        state.currentError != null
                            ? Text(state.currentError.toString())
                            : Container(),
                        Container(
                          color: Colors.white,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 40),
                          padding: const EdgeInsets.only(bottom: 16, top: 16),
                          child: FlatButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                widget._bloc.dispatch(AttemptOtpCheck(
                                    otpController.text,
                                    phoneController.text,
                                    passController.text));
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
                                "تایید",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        /* Text((state as OtpSubmission).opt)*/
                      ],
                    ),
                  );
                } else if (state is RegisterFailed) {
                  return Container(
                    child: Text("failed"),
                  );
                } else if (state is RegisterSuccessful) {
                  Future.delayed(Duration(seconds: 3), () {
                    Navigator.popAndPushNamed(context, HomePage.routeName);
                  });
                  return Center(
                    child: Text("ثبت نام با موفقیت انجام شد!"),
                  );
                } else if (state is LoadingRegister) {
                  return Center(
                    child: new Center(child: LightLoadingIndicator()),
                  );
                } else {
                  return Container(
                    child: Text("errorr"),
                  );
                }
              }),
        ));
  }
}
