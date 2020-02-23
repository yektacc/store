import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/data_layer/fcm/fcm_token_repository.dart';
import 'package:store/services/centers/centers_list_page.dart';
import 'package:store/services/centers/model.dart';
import 'package:store/services/lost_pets/lost_pets_page.dart';
import 'package:store/services/lost_pets/lost_pets_repository.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/landing/landing_bloc.dart';
import 'package:store/store/login_register/login/login_bloc.dart';
import 'package:store/store/login_register/login/login_event_state.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/management/management_bloc.dart';
import 'package:store/store/management/management_event_state.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  LoginBloc _loginBloc;
  LoginStatusBloc _loginStatusBloc;
  ManagementBloc _managementBloc;
  LandingBloc _landingBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    configureFcm(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_managementBloc == null) {
      _managementBloc = Provider.of<ManagementBloc>(context);
    }

    if (_loginStatusBloc == null) {
      _loginStatusBloc = Provider.of<LoginStatusBloc>(context);
    }

    if (_landingBloc == null) {
      _landingBloc = Provider.of<LandingBloc>(context);
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            new Container(
              height: double.infinity,
              width: double.infinity,
              child: new Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/background_top.png'),
                                fit: BoxFit.contain,
                                alignment: Alignment.topCenter))),
                  ),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                AssetImage('assets/background_bottom.png'),
                                fit: BoxFit.contain,
                                alignment: Alignment.bottomCenter))),
                  )
                ],
              ),
            ),
            BlocBuilder(
              bloc: _landingBloc,
              builder: (context, state) {
                if (state is LoadingSuccessful) {
                  if (_loginBloc == null) {
                    _loginBloc = Provider.of<LoginBloc>(context);
                    if (_loginStatusBloc.currentState is NotLoggedIn) {
                      _loginBloc.dispatch(AttemptLastLogin());
                    }
                  }

                  print('attempting running it');
                  Provider.of<ManagementBloc>(context)
                      .dispatch(InitiateManagerLogin());

                  return Column(
                    children: <Widget>[
                      Container(
                        height: 105,
                      ),
                      Container(
                        color: Colors.black12,
                        height: 130,
                        margin: EdgeInsets.only(),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CenterPage(CenterFetchType.CLINICS)));
                              },
                              child: new Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 4),
                                color: Colors.cyan[300],
                                elevation: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          image:
                                          AssetImage('assets/clinics.png'),
                                          fit: BoxFit.fill,
                                          alignment: Alignment.center)),
                                  height: 100,
                                  width: 100,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromARGB(120, 70, 70, 70),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(top: 30),
                                            child: Text(
                                              "کلینیک ها",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.local_hospital,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                            new GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CenterPage(
                                            CenterFetchType.PENSION_BARBER)));
                              },
                              child: new Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 4),
                                color: Colors.cyan[300],
                                elevation: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          image:
                                          AssetImage('assets/barber.png'),
                                          fit: BoxFit.fill,
                                          alignment: Alignment.center)),
                                  height: 100,
                                  width: 100,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromARGB(120, 70, 70, 70),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                top: 20, right: 20, left: 20),
                                            child: Text(
                                              "پانسیون و آرایشگاه ها",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        color: Colors.grey[100],
                        child: new GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(HomePage.routeName);
                          },
                          child: new Container(
                              margin: EdgeInsets.only(top: 7, bottom: 7),
                              height: 140,
                              child: Center(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80)),
                                  elevation: 10,
                                  child: new Container(
                                    height: 105,
                                    width: 153,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/pet_shop.jpg'),
                                            fit: BoxFit.fitHeight,
                                            alignment: Alignment.center)),
                                    child: new Container(
                                        height: 105,
                                        width: 153,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(80),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/pet_shop.jpg'),
                                                fit: BoxFit.fitHeight,
                                                alignment: Alignment.center)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(80),
                                            color:
                                            Color.fromARGB(120, 70, 70, 70),
                                          ),
                                          child: new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Center(
                                                child: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  "فروشگاه",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              /* Icon(
                                        Icons.shopping_cart,
                                        size: 50,
                                        color: Colors.grey[200],
                                      )*/
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              )),
                        ),
                        /**/
                      ),
                      new Container(
                        color: Colors.black12,
                        height: 130,
                        margin: EdgeInsets.only(),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        LostPetsPage(PetRequestType.ADOPTION)));
                              },
                              child: new Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 4),
                                color: Colors.cyan[300],
                                elevation: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          image: AssetImage('assets/adopt.png'),
                                          fit: BoxFit.fill,
                                          alignment: Alignment.center)),
                                  height: 100,
                                  width: 100,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromARGB(120, 70, 70, 70),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(top: 25),
                                            child: Text(
                                              "سرپرستی",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.label_outline,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                            new GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        LostPetsPage(
                                            PetRequestType.LOST_FOUND)));
                              },
                              child: new Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 4),
                                color: Colors.cyan[300],
                                elevation: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          image: AssetImage('assets/lost.png'),
                                          fit: BoxFit.fill,
                                          alignment: Alignment.center)),
                                  height: 100,
                                  width: 100,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromARGB(120, 70, 70, 70),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                top: 20, right: 20, left: 20),
                                            child: Text(
                                              "گم شده / پیدا شده",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.pets,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
                else {
                  return Container(
                    color: Colors.red,
                    child: Center(
                      child: FlatButton(
                        child: Text('try again'),
                        onPressed: () {
                          _landingBloc.dispatch(RetryLoading());
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        content: new Text('آیا می‌خواهید از اپ خارج شوید؟'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('خیر'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('بله'),
          ),
        ],
      ),
    )) ??
        false;
  }

  // initiation
  configureFcm(BuildContext context) {
    Provider
        .of<FcmTokenRepository>(context)
        .firebaseMessaging
        .configure(
      onMessage: (Map<String, dynamic> message) async {
        print("fcm: onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("fcm: onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("fcm: onResume: $message");
      },
    );
  }

/*setUpInboxes(BuildContext context) {
    var inboxMng = Provider.of<InboxManager>(context);
    var net = Provider.of<Net>(context);

    if (_managementBloc.user != null && inboxMng.managerInbox == null) {
      inboxMng.managerInbox = InboxBloc(
          ChatRepository(net, CenterChatUser(_managementBloc.srvCenterId)));
    }

    if (inboxMng.)
  }*/
}
