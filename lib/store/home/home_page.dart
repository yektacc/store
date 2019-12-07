import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/landing_page.dart';
import 'package:store/store/location/map/map_page.dart';
import 'package:store/store/location/my_location/my_location_bloc.dart';
import 'package:store/store/location/my_location/my_location_bloc_event.dart';
import 'package:store/store/login_register/login/login_bloc.dart';
import 'package:store/store/login_register/login/login_event_state.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/login_register/profile/profile_bloc.dart';
import 'package:store/store/login_register/profile/profile_bloc_event_state.dart';
import 'package:store/store/login_register/profile/profile_page.dart';
import 'package:store/store/order/order_page.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/cart/cart_bloc_event.dart';
import 'package:store/store/products/cart/cart_page.dart';
import 'package:store/store/products/detail/product_detail_page.dart';
import 'package:store/store/products/favorites/favorites_page.dart';
import 'package:store/store/products/filter/filtered_products_bloc.dart';
import 'package:store/store/products/product/products_bloc.dart';
import 'package:store/store/products/search/search_delegate.dart';
import 'package:store/store/products/special/special_products_page.dart';
import 'package:store/store/products/special/special_products_repository.dart';
import 'package:store/store/shop_management/seller_login_page.dart';
import 'package:store/store/structure/model.dart';
import 'package:store/store/structure/structure_bloc.dart';
import 'package:store/store/structure/structure_event_state.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import 'info_page.dart';
import 'main_area.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  ProductsBloc _productsBloc;
  FilteredProductsBloc _filteredProductsBloc;
  StructureBloc _structureBloc;
  LoginBloc _loginBloc;
  LoginStatusBloc _loginStatusBloc;

  @override
  _HomePageState createState() => _HomePageState();
}

enum OverlayPage { MAIN_PAGE, SEARCH, MAP }

enum PageChangeEvent { MAP_SHOW, MAP_HIDE, SEARCH_SHOW, SEARCH_HIDE }

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController mapAnimController;
  Animation<Offset> mapPageOffset;

/*  AnimationController searchAnimController;
  Animation<Offset> searchPageOffset;*/

  PersistentBottomSheetController _controller;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSearchShown = false;

  void _updateOverlay(PageChangeEvent event) {
    if (event == PageChangeEvent.MAP_SHOW) {
      _showMap();
    } else if (event == PageChangeEvent.MAP_HIDE) {
      _hideMap();
    } else if (event == PageChangeEvent.SEARCH_SHOW) {
      _isSearchShown = true;
      _showSearch();
    } else if (event == PageChangeEvent.SEARCH_HIDE) {
      _isSearchShown = false;
      _hideSearch();
    }
  }

  void _showMap() {
    if (mapAnimController.status != AnimationStatus.completed) {
      mapAnimController.forward();
    }
  }

  void _hideMap() {
    mapAnimController.reverse();
  }

  void _showSearch() {
    /*searchAnimController.forward();*/
    /*setState(() {
      _controller = _scaffoldKey.currentState.showBottomSheet((_) => Container(
            child: new Container(
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Container(
                  color: Colors.grey[300],
                  child: SearchPage(() {
                    _updateOverlay(PageChangeEvent.SEARCH_HIDE);
                  }, () {
                    _updateOverlay(PageChangeEvent.SEARCH_SHOW);
                  }),
                ),
              ),
            ),
          ));
    });*/
    showSearch(context: context, delegate: CustomSearchDelegate(AllItems()));
  }

  void _hideSearch() {
/*
    searchAnimController.reverse();
*/
    setState(() {
      if (_controller != null) _controller.close();
    });
  }

  @override
  void initState() {
    super.initState();

    mapAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    mapPageOffset =
        Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
            .animate(CurvedAnimation(
      parent: mapAnimController,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /* searchAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    searchPageOffset = Tween<Offset>(
            begin: Offset(0.0, 1 - (56 / MediaQuery.of(context).size.height)),
            end: Offset(0.0, (59 / MediaQuery.of(context).size.height)))
        .animate(CurvedAnimation(
      parent: searchAnimController,
      curve: Curves.fastOutSlowIn,
    ));*/
  }

  AppBar _buildAppBar(BuildContext context) {
    return new AppBar(
      title: FlatButton(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            BlocBuilder<MyLocationBloc, MyLocationState>(
              bloc: Provider.of<MyLocationBloc>(context),
              builder: (context, MyLocationState state) {
                if (state is MyLocationLoaded) {
                  return Text(
                    state.myLocation.city.name,
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return Text(
                    "نزدیک من",
                    style: TextStyle(color: Colors.white),
                  );
                }
              },
            ),
          ],
        ),
        onPressed: () {
          _updateOverlay(PageChangeEvent.MAP_SHOW);
        },
      ),
      actions: <Widget>[
        Container(
          width: 70,
          child: BlocBuilder(
            bloc: Provider.of<CartBloc>(context),
            builder: (context, CartState state) {
              if (state is CartLoaded) {
                return CartButton(state.count);
              } else {
                return CartButton(0);
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildDrawer() {
    return SafeArea(
      child: new Drawer(
        child: Column(
          children: <Widget>[
            Container(
                height: 90,
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 0.0),
                    // 10% of the width, so there are ten blinds.
                    colors: [
                      AppColors.main_color,
                      AppColors.main_color,
                    ],
                    // whitish to gray
                    tileMode:
                        TileMode.clamp, // repeats the gradient over the canvas
                  ),
                ),
/*
                color: AppColors.main_color,
*/
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: new BlocBuilder(
                      bloc: widget._loginStatusBloc,
                      builder: (context, LoginStatusState state) {
                        if (state is NotLoggedIn) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: BorderSide(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.push(context,
                                          AppRoutes.loginPage(context));
                                    },
                                    child: Text(
                                      "ورود / ثبت نام",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: BorderSide(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LandingPage()));
                                    },
                                    child: Text(
                                      "خدمات",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else if (state is IsLoggedIn) {
                          return new Align(
                            alignment: Alignment.bottomCenter,
                            child: new Column(
                              children: <Widget>[
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Center(
                                            child: BlocBuilder(
                                                bloc: Provider.of<ProfileBloc>(
                                                    context),
                                                builder: (BuildContext context,
                                                    ProfileState state) {
                                                  if (state is ProfileLoaded) {
                                                    return Container(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return ProfilePage();
                                                          }));
                                                        },
                                                        child: Text(
                                                          state.profile
                                                                  .firstName +
                                                              '  ' +
                                                              state.profile
                                                                  .lastName,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child:
                                                /*Text(
                                                (state.status as LoggedInStatus)
                                                    .user
                                                    .phoneNo,style: TextStyle(color: Colors.white),)*/
                                                Container(),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (state is StatusLoading) {
                          return new Center(child: LoadingIndicator());
                        } else {
                          return Container();
                        }
                      }),
                )),
            BlocBuilder(
                bloc: widget._loginStatusBloc,
                builder: (context, LoginStatusState state) {
                  return new Container(
                    padding: EdgeInsets.only(right: 4, top: 20),
                    child: Column(
                      children: <Widget>[
                        _buildDrawerItem(() {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ProfilePage();
                          }));
                        }, Icons.person, "پروفایل کاربری"),
                        _buildDrawerItem(() {
                          Navigator.of(context).pushNamed(CartPage.routeName);
                        }, Icons.shopping_cart, "سبد خرید"),
                        _buildDrawerItem(() {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return InfoPage();
                          }));
                        }, Icons.info, "حقوق و قوانین"),
                        _buildDrawerItem(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OrderPage()));
                        }, Icons.history, "سفارش های قبلی"),
                        _buildDrawerItem(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FavoritesPage()));
                        }, Icons.favorite, "علاقه‌مندی ها"),
                        Divider(),
                        _buildDrawerItem(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SpecialProductsPage(
                                  SpecialProductType.BEST_SELLER)));
                        }, Icons.local_offer, "پرفروشترین محصولات"),
                        _buildDrawerItem(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SpecialProductsPage(
                                  SpecialProductType.NEWEST)));
                        }, Icons.new_releases, "جدید‌ترین محصولات"),
                        Divider(),
                        _buildDrawerItem(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SellerLoginPage()));
                        }, Icons.store, "ورود به قسمت فروشندگان"),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(VoidCallback onPressed, IconData icon, String title) {
    return Container(
      height: 50,
      child: FlatButton(
          onPressed: onPressed,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: Colors.grey[600],
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget._productsBloc == null) {
      widget._productsBloc = Provider.of<ProductsBloc>(context);
/*
      widget._productsBloc.dispatch(LoadPopularProducts(AllItems()));
*/
    }

    if (widget._filteredProductsBloc == null) {
      widget._filteredProductsBloc = Provider.of<FilteredProductsBloc>(context);
    }

    if (widget._structureBloc == null) {
      widget._structureBloc = Provider.of<StructureBloc>(context);
      widget._structureBloc.dispatch(FetchStructure());
    }

    if (widget._loginStatusBloc == null) {
      widget._loginStatusBloc = Provider.of<LoginStatusBloc>(context);
    }

    if (widget._loginBloc == null) {
      widget._loginBloc = Provider.of<LoginBloc>(context);
      if (widget._loginStatusBloc.currentState is NotLoggedIn) {
        widget._loginBloc.dispatch(AttemptLastLogin());
      }
    }

    return SafeArea(
      child: new Stack(
        children: <Widget>[
          new Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              drawer: _isSearchShown ? null : _buildDrawer(),
              backgroundColor: Colors.grey[100],
              appBar: _buildAppBar(context),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: MainArea(),
                  ),
                  GestureDetector(
                    child: AppBar(
                      backgroundColor: Colors.grey[200],
                      leading: Padding(
                        padding: EdgeInsets.only(right: 14),
                        child: Icon(
                          Icons.search,
                          color: AppColors.main_color,
                        ),
                      ),
                      title: Container(
                        alignment: Alignment.center,
                        height: 45,
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'جستجو بین محصولات',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.main_color),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    onTap: () {
                      _updateOverlay(PageChangeEvent.SEARCH_SHOW);
                    },
                  )
                  /* SearchArea(() {
                    searchAnimController.forward();
                  })*/
                ],
              )),
          /* new SlideTransition(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Container(
                color: Colors.grey[300],
                child: SearchPage(() {
                  _updateOverlay(PageChangeEvent.SEARCH_HIDE);
                }, () {
                  _updateOverlay(PageChangeEvent.SEARCH_SHOW);
                }),
              ),
            ),
          ),*/
          new SlideTransition(
            position: mapPageOffset,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Container(
                color: Colors.grey[300],
                child: MapPage(() {
                  _updateOverlay(PageChangeEvent.MAP_HIDE);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Spaces {
  static const EdgeInsets listInsets =
      EdgeInsets.symmetric(vertical: 4, horizontal: 4);

  static const EdgeInsets listCardInsets =
      EdgeInsets.symmetric(vertical: 2, horizontal: 2);
}
