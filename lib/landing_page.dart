import 'package:flutter/material.dart';
import 'package:store/data_layer/centers/centers_repository.dart';
import 'package:store/services/centers/centers_page.dart';
import 'package:store/services/lost_pets/lost_pets_page.dart';
import 'package:store/services/lost_pets/lost_pets_repository.dart';
import 'package:store/store/home/home_page.dart';
import 'package:store/store/login_register/login/login_bloc.dart';
import 'package:store/store/login_register/login/login_event_state.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  LoginBloc _loginBloc;
  LoginStatusBloc _loginStatusBloc;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    /* Provider.of<LoginStatusBloc>(context).state.listen((state) {
      if(state is IsLoggedIn) {
        return new Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color.fromARGB(130, 200, 200, 200),
                width: double.infinity,
                height: 70,
                child: Card(
                  elevation: 10,
                  margin:
                  EdgeInsets.symmetric(horizontal: 100, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: AppColors.main_color,
                  child: Container(
                    width: 180,
                    child: Center(
                      child: Text(
                        "ورود / ثبت نام",
                        style:
                        TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    });*/

    if (widget._loginStatusBloc == null) {
      widget._loginStatusBloc = Provider.of<LoginStatusBloc>(context);
    }

    if (widget._loginBloc == null) {
      widget._loginBloc = Provider.of<LoginBloc>(context);
      if (widget._loginStatusBloc.currentState is NotLoggedIn) {
        widget._loginBloc.dispatch(AttemptLastLogin());
      }
    }

    return Scaffold(
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
                              image: AssetImage('assets/background_bottom.png'),
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter))),
                )
              ],
            ),
          ),
          new Column(
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
                        margin:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        color: Colors.cyan[300],
                        elevation: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: AssetImage('assets/clinics.png'),
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                CenterPage(CenterFetchType.PENSION_BARBER)));
                      },
                      child: new Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        color: Colors.cyan[300],
                        elevation: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: AssetImage('assets/barber.png'),
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                    Navigator.of(context).popAndPushNamed(HomePage.routeName);
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
                                    image: AssetImage('assets/pet_shop.jpg'),
                                    fit: BoxFit.fitHeight,
                                    alignment: Alignment.center)),
                            child: new Container(
                                height: 105,
                                width: 153,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/pet_shop.jpg'),
                                        fit: BoxFit.fitHeight,
                                        alignment: Alignment.center)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    color: Color.fromARGB(120, 70, 70, 70),
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
                                              fontWeight: FontWeight.bold),
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
                        margin:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                LostPetsPage(PetRequestType.LOST_FOUND)));
                      },
                      child: new Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
          )
        ],
      ),
    );
  }
}
/*

class WheelExample extends StatelessWidget {
  final RadialListViewModel radialNumbers = new RadialListViewModel(items: [
    new RadialListItemViewModel(
      number: 1,
      isSelected: true,
    ),
    new RadialListItemViewModel(
      number: 2,
      isSelected: false,
    ),
    new RadialListItemViewModel(
      number: 3,
      isSelected: false,
    ),
    new RadialListItemViewModel(
      number: 4,
      isSelected: false,
    ),
    new RadialListItemViewModel(
      number: 5,
      isSelected: false,
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return RadialList(
      radialList: radialNumbers,
      radius: 120.00,
    );
  }
}

class RadialList extends StatefulWidget {
  final RadialListViewModel radialList;
  final double radius;

  RadialList({
    this.radialList,
    this.radius,
  });

  List<Widget> _radialListItems() {
    final double firstItemAngle = pi;
    final double lastItemAngle = pi;
    final double angleDiff =
        (firstItemAngle + lastItemAngle) / (radialList.items.length);

    double currentAngle = firstItemAngle;
    return radialList.items.map((RadialListItemViewModel viewModel) {
      final listItem = _radialListItem(viewModel, currentAngle);
      currentAngle += angleDiff;
      return listItem;
    }).toList();
  }

  Widget _radialListItem(RadialListItemViewModel viewModel, double angle) {
    return Container(child: Transform(
      transform: new Matrix4.translationValues(-80.0, 320.0, 0.0),
      child: RadialPosition(
        radius: radius,
        angle: angle,
        child: new RadialListItem(
          listItem: viewModel,
        ),
      ),
    ),);
  }

  @override
  RadialListState createState() {
    return new RadialListState();
  }
}

class RadialListState extends State<RadialList> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: widget._radialListItems(),
    );
  }
}

class RadialListItem extends StatefulWidget {
  final RadialListItemViewModel listItem;

  RadialListItem({this.listItem});

  @override
  RadialListItemState createState() {
    return new RadialListItemState();
  }
}

class RadialListItemState extends State<RadialListItem> {
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: new Matrix4.translationValues(-40.0, -60.0, 0.0),
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[100],
            border: new Border.all(color: Colors.grey[200], width: 2.0)),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: OutlineButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(60.0)),
            color: Colors.transparent,
            onPressed: () {
              setState(() {
                widget.listItem.isSelected = true;
                //widget.listItem.number = widget.listItem.number + 1;
              });
            },
            child: new Text(
              widget.listItem.number.toString(),
              style: new TextStyle(
                  color:
                      widget.listItem.isSelected ? Colors.red : Colors.yellow,
                  fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}

class RadialListViewModel {
  final List<RadialListItemViewModel> items;

  RadialListViewModel({
    this.items = const [],
  });
}

class RadialListItemViewModel {
  int number;
  bool isSelected;

  RadialListItemViewModel({
    this.isSelected = false,
    this.number,
  });
}

class RadialPosition extends StatefulWidget {
  final double radius;
  final double angle;
  final Widget child;

  RadialPosition({
    this.angle,
    this.child,
    this.radius,
  });

  @override
  RadialPositionState createState() {
    return new RadialPositionState();
  }
}

class RadialPositionState extends State<RadialPosition> {
  @override
  Widget build(BuildContext context) {
    final x = cos(widget.angle) * widget.radius;
    final y = sin(widget.angle) * widget.radius;

    return Transform(
      transform: new Matrix4.translationValues(x, y, 0.0),
      child: widget.child,
    );
  }
}
*/
