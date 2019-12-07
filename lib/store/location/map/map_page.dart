import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/location/my_location/model.dart';
import 'package:store/store/location/my_location/my_location_bloc.dart';
import 'package:store/store/location/my_location/my_location_bloc_event.dart';
import 'package:store/store/location/provinces/model.dart';
import 'package:store/store/location/provinces/provinces_bloc.dart';
import 'package:store/store/location/provinces/provinces_bloc_event.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MapPage extends StatefulWidget {
  final VoidCallback onDismissPressed;

  MapPage(this.onDismissPressed);

  @override
  _MapPageState createState() => _MapPageState();
}

class MapAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onDismiss;

  MapAppBar(this.onDismiss);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        elevation: 5,
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                height: 56,
                margin: EdgeInsets.only(),
                child: Center(
                  child: IconButton(
                      color: Colors.grey[600],
                      iconSize: 25,
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        onDismiss();
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 66);
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  List<Marker> markers = [];

  final LatLng _center = const LatLng(36.6830, 48.5087);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  LatLng _getCityLatLng(City city) {
    var lat = city.lat;
    var long = city.long;
    print("SDFSDF $lat $long");
    if (lat != null && long != null && lat != 0 && long != 0) {
      return LatLng(lat, long);
    } else {
      return _center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*
      appBar: MapAppBar(widget.onDismissPressed),
*/
      body: new BlocBuilder<MyLocationBloc, MyLocationState>(
        bloc: Provider.of<MyLocationBloc>(context),
        builder: (context, MyLocationState state) {
          if (state is MyLocationLoaded) {
            return new Column(
              children: <Widget>[
                _buildChangeCityArea(state.myLocation.city),
                _buildMap(CameraPosition(
                    target: state.myLocation.getLocation(), zoom: 12))
              ],
            );
          } else {
            return CitySelection();
          }
        },
      ),
    );
  }

  Widget _buildChangeCityArea(City city) {
    return new Container(
        width: double.infinity,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 6),
        margin: EdgeInsets.only(top: 9, bottom: 4),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: new Container(
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(40)),
              child: new Row(
                children: <Widget>[
                  Container(
                    width: 54,
                    child: IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 23,
                        ),
                        onPressed: () {
                          widget.onDismissPressed();
                        }),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  new Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: Card(
                        color: Colors.grey[600],
                        elevation: 15,
                        child: GestureDetector(
                          onTap: () {
                            markers = [];

                            Provider.of<MyLocationBloc>(context)
                                .dispatch(RemoveMyLocation());
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 14, left: 14),
                                  padding: EdgeInsets.only(right: 16),
                                  child: Center(
                                    child: Text(
                                      city.name,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Icon(Icons.location_city,
                                      size: 18, color: Colors.grey[300]),
                                )
                              ],
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                                topRight: Radius.circular(40))),
                      )),
                  Expanded(
                    child: Container(),
                  ),
                  new Container(
                    child: Card(
                      color: AppColors.main_color,
                      elevation: 15,
                      child: GestureDetector(
                        onTap: () {
                          markers = [];
                          Provider.of<MyLocationBloc>(context)
                              .dispatch(RemoveMyLocation());
                        },
                        child: Container(
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "تغییر",
                                style: TextStyle(
                                    color: Colors.grey[200], fontSize: 11),
                              ),
                              Icon(
                                Icons.mode_edit,
                                size: 18,
                                color: Colors.grey[200],
                              )
                            ],
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                              topRight: Radius.circular(40))),
                    ),
                  )
                ],
              )),
        ));
  }

  Widget _buildMap(CameraPosition initialPosition) {
    return new Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 8,
              child: Container(
                child: GoogleMap(
                  markers: markers.toSet(),
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: initialPosition,
                ),
              ),
            ),
          ),
          Container(
            height: 170,
            width: 100,
            padding: EdgeInsets.only(bottom: 70),
            child: markers.isEmpty ? new Stack(
              children: <Widget>[
                Center(
                  child: IconButton(
                    iconSize: 70,
                    onPressed: () {},
                    icon: AppIcons.mapPin,
                    color: AppColors.main_color,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    LatLng postion;

                    LatLngBounds region =
                        await mapController.getVisibleRegion();

                    postion = LatLng(
                        region.southwest.latitude +
                            (region.northeast.latitude -
                                    region.southwest.latitude) /
                                2,
                        region.southwest.longitude +
                            (region.northeast.longitude -
                                    region.southwest.longitude) /
                                2);

                    markers.add(Marker(
                        position: postion,
                        markerId: MarkerId("my_location_pin"),
                        ));
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40))),
                    margin: EdgeInsets.only(
                        bottom: 45, top: 10, right: 24, left: 24),
                    alignment: Alignment.center,
                    child: Container(
                      child: Text(
                        "اینجا",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ) : Container(),
          )
        ],
      ),
    );
  }
}

class CitySelection extends StatefulWidget {
  CitySelection();

  @override
  _CitySelectionState createState() => _CitySelectionState();
}

class _CitySelectionState extends State<CitySelection> {
  ProvinceBloc _provinceBloc;
  BehaviorSubject<Province> _selectedProvince = BehaviorSubject();

  @override
  Widget build(BuildContext context) {
    if (_provinceBloc == null) {
      _provinceBloc = Provider.of<ProvinceBloc>(context);
      _provinceBloc.dispatch(FetchProvinces());
    }

    return BlocBuilder<ProvinceBloc, ProvinceState>(
      bloc: _provinceBloc,
      builder: (context, ProvinceState state) {
        if (state is ProvincesLoaded) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 40),
              height: 400,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: 40, left: 12, top: 30, bottom: 30),
                      child: StreamBuilder(
                        stream: _selectedProvince,
                        builder: (context, AsyncSnapshot<Province> snapshot) {
                          return ListView(
                            children: state.provinces
                                .map((p) => GestureDetector(
                                      onTap: () {
                                        _selectedProvince.add(p);
                                      },
                                      child: _buildProvinceItem(
                                          p,
                                          snapshot.data != null &&
                                                  p.id == snapshot.data.id
                                              ? true
                                              : false),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 40, right: 12, top: 30, bottom: 30),
                      child: StreamBuilder(
                          stream: _selectedProvince,
                          builder: (context, AsyncSnapshot<Province> snapshot) {
                            if (snapshot.data == null) {
                              return Container();
                            } else {
                              return ListView(
                                children: snapshot.data.cities
                                    .map((c) => _buildCityItem(c))
                                    .toList(),
                              );
                            }
                          }),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return LoadingIndicator();
        }
      },
    );
  }

  Widget _buildProvinceItem(Province province, bool selected) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
      height: 48,
      decoration: BoxDecoration(
          color: selected ? Colors.blueGrey[0] : Colors.grey[100],
          borderRadius: BorderRadius.circular(50),
          border: selected ? Border.all(color: Colors.grey[100]) : null),
      child: Center(child: Text(province.name)),
    );
  }

  Widget _buildCityItem(City city) {
    return GestureDetector(
      onTap: () {
        Provider.of<MyLocationBloc>(context)
            .dispatch(UpdateMyLocation(Location(city)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
        height: 38,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(50)),
        child: Center(child: Text(city.name)),
      ),
    );
  }
}
