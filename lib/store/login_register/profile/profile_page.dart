import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_bloc.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_event_state.dart';
import 'package:store/store/login_register/forgetpass/forget_pass_page.dart';
import 'package:store/store/login_register/login/login_bloc.dart';
import 'package:store/store/login_register/login/login_event_state.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/login_register/profile/profile_bloc.dart';
import 'package:store/store/login_register/profile/profile_bloc_event_state.dart';

import 'credit_card_page.dart';
import 'edit_profile_page.dart';
import 'model.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = 'profilepage';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileBloc profileBloc;
  Profile _currentProfile;

  @override
  Widget build(BuildContext context) {
    if (profileBloc == null) {
      profileBloc = Provider.of<ProfileBloc>(context);
    }

    var loginStatus = Provider.of<LoginStatusBloc>(context).currentState;
    if (loginStatus is IsLoggedIn) {
      profileBloc.dispatch(GetProfile(loginStatus.user.sessionId));
    }

    return Scaffold(
        appBar: CustomAppBar(
          titleText: "پروفایل",
        ),
        body: BlocBuilder(
            bloc: profileBloc,
            builder: (context, ProfileState state) {
              if (state is ProfileLoaded) {
                _currentProfile = state.profile;
                return Column(
                  children: <Widget>[
                    Container(
                      height: 70,
                      padding: EdgeInsets.only(right: 10),
                      color: Colors.grey[200],
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 2, left: 5),
                              child: Text(state.profile.firstName),
                            ),
                            Container(
                              child: Text(state.profile.lastName),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(children: <Widget>[] + items()),
                    )
                  ],
                );
              } else {
                return LoadingIndicator();
              }
            }));
  }

  List<Widget> items() => <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 6),
        ),
        ProfilePageOption(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileEditPage(_currentProfile)));
        }, Icons.edit, "ویرایش اطلاعات"),
    /* ProfilePageOption(() {
      ///todo #3
    }, Icons.history, "خرید های قبلی"),*/
        ProfilePageOption(() {
          Provider.of<ForgetPassBloc>(context).dispatch(ResetForgetPass());
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ForgetPassPage()));
        }, Icons.lock_outline, "تغییر کلمه عبور"),
        ProfilePageOption(() {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreditCardPage()));
        }, Icons.credit_card, "کارت بانکی"),
        ProfilePageOption(() {
          Provider.of<LoginBloc>(context).dispatch(Logout());
          Navigator.of(context).pop();
        }, Icons.exit_to_app, "خروج از حساب"),
      ];
}

class ProfilePageOption extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final String title;

  ProfilePageOption(this.onTap, this.iconData, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
        leading: Icon(iconData),
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        onTap: onTap,
      ),
      Divider()
    ]);
  }
}
