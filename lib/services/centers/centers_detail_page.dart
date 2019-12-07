import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/centers/centers_repository.dart';
import 'package:store/data_layer/centers/service_repository.dart';
import 'package:store/store/login_register/login/login_page.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model.dart';

class CenterDetailPage extends StatefulWidget {
  final CenterItem center;

  CenterDetailPage(this.center);

  @override
  _CenterDetailPageState createState() => _CenterDetailPageState();
}

class _CenterDetailPageState extends State<CenterDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(
          color: AppColors.main_color, //change your color here
        ),
        title: Text(
          widget.center.name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16, color: AppColors.main_color),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            new Container(
              color: Colors.grey[200],
              height: 100,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10, right: 10),
                      color: Colors.grey[200],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /* Expanded(
                            child: Center(
                              child: Text(
                                widget.center.name,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),*/
                          /*  Divider(
                            color: Colors.grey,
                          ),*/
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_city,
                                color: Colors.grey,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget.center.province.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey[700]),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  " - " + widget.center.city.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey[700]),
                                ),
                              )
                            ],
                          )),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: BlocBuilder(
                                    bloc: Provider.of<LoginStatusBloc>(context),
                                    builder: (context, LoginStatusState state) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (state is IsLoggedIn) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    _buildScoreSubmissionDialog((score) =>
                                                        Provider.of<CentersRepository>(
                                                                context)
                                                            .submitCenterScore(
                                                                widget
                                                                    .center.id,
                                                                score,
                                                                state.user
                                                                    .sessionId)
                                                            .then((success) {
                                                          if (success) {
                                                            Helpers.showToast(
                                                                'امتیاز شما ثبت گردید.');
                                                            Navigator.pop(
                                                                context);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "خطا در اتصال!",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIos:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        50],
                                                                fontSize: 13.0);
                                                          }
                                                        })));
                                          } else if (state is NotLoggedIn) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()));
                                          }
                                        },
                                        child: RatingBarIndicator(
                                          unratedColor: Colors.grey[400],
                                          rating: double.parse(
                                              widget.center.score,
                                              (err) => 3.0),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: AppColors.second_color,
                                          ),
                                          itemCount: 5,
                                          itemSize: 25.0,
                                          direction: Axis.horizontal,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 1, left: 1),
                        alignment: Alignment.centerLeft,
                        color: Colors.grey[200],
                        height: 100,
                        child: FutureBuilder<String>(
                            future: Provider.of<CentersRepository>(context)
                                .getCenterImgUrl(widget.center.id.toString()),
                            builder: (context, snapshot) {
                              if (snapshot != null &&
                                  snapshot.data != null &&
                                  snapshot.data != '') {
                                return Helpers.image(snapshot.data);
                              } else {
                                return Container();
                              }
                            }) /*Icon(
                        Icons.pets,
                        size: 90,
                        color: Colors.grey[200],
                      )*/
                        ),
                  )
                ],
              ),
            ),
            widget.center.address == ''
                ? Container()
                : new Container(
                    padding: EdgeInsets.only(top: 13, bottom: 8),
                    color: AppColors.main_color,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            height: 44,
                            width: 44,
                            margin: EdgeInsets.only(
                                right: 4, left: 14, bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.white),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              child: AppIcons.showOnMap(AppColors.second_color),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return MapWgt(widget.center.location);
                                });
                          },
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${widget.center.address}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            new Container(
              height: 46,
              padding: EdgeInsets.only(right: 16),
              color: AppColors.main_color,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          launch("tel://${widget.center.phone}");
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.phone,
                            size: 22,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 14),
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.center.phone,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          )
                        ])),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        launch("mailto:${widget.center.email}");
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.email,
                            size: 22,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.center.email,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            widget.center.description == ''
                ? Container()
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    child: Text(
                      widget.center.description,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    color: AppColors.main_color,
                  ),
            widget.center.description == ''
                ? Container()
                : Container(
                    height: 2,
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4))),
                  ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(Icons.date_range, color: AppColors.main_color),
                  margin: EdgeInsets.only(right: 10),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      children: widget.center.workingDay1.days
                          .map((d) => Container(
                                child: Text(d),
                                margin: EdgeInsets.only(right: 1, top: 1),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                color: Colors.blueGrey[50],
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.access_time,
                    color: AppColors.main_color,
                  ),
                  margin: EdgeInsets.only(right: 10, left: 20),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  margin: EdgeInsets.only(left: 14),
                  child: Text(
                    widget.center.workingDay1.from.substring(0, 5),
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.main_color),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  margin: EdgeInsets.only(left: 14),
                  child: Text("-"),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  child: Text(
                    widget.center.workingDay1.to.substring(0, 5),
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.main_color),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30),
                )
              ],
            ),
            Divider(),
            Container(
              child: Text(
                "خدمات مرکز",
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              margin: EdgeInsets.only(right: 10, top: 10),
            ),
            StreamBuilder(
                stream: Provider.of<ServicesRepository>(context)
                    .getCenterServices(widget.center.departmentId),
                builder: (context, AsyncSnapshot<List<Service>> snapshot) {
                  if (snapshot.data != null && snapshot.data.isNotEmpty) {
                    return Container(
                      color: Colors.grey[300],
                      height: 56,
                      padding: EdgeInsets.only(right: 6),
                      margin: EdgeInsets.only(top: 10),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data[1].serviceName
                            .split(';')
                            .map((serviceName) => _buildService(serviceName))
                            .toList(),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
            /* new Expanded(
              child: ListView(
                children: <Widget>[
                ],
              ),
            )*/
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSubmissionDialog(Function(int score) onClick) {
    final double initialRate = 3;
    double currentRating = initialRate;

    return AlertDialog(
      title: Container(
        child: Text(
          'ثبت امتیاز',
          style: TextStyle(fontSize: 14),
        ),
      ),
      content: Container(
        alignment: Alignment.center,
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 30),
              child: RatingBar(
                textDirection: TextDirection.ltr,
                initialRating: initialRate,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 30,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  currentRating = rating;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Card(
                  color: Colors.green,
                  child: FlatButton(
                    child: Text(
                      'ثبت',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => onClick(currentRating.toInt()),
                  ),
                ),
                Card(
                  child: FlatButton(
                    child: Text('انصراف'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildService(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(4)),
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class MapWgt extends StatefulWidget {
  final LatLng latLng;

  MapWgt(this.latLng);

  @override
  _MapWgtState createState() => _MapWgtState();
}

class _MapWgtState extends State<MapWgt> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
        child: Stack(
          children: <Widget>[
            GoogleMap(
              /*  gestureRecognizers: [
            Factory(() => PlatformViewVerticalGestureRecognizer()),
          ].toSet(),*/
/*
          markers: markers != null ? markers.toSet() : Set(),
*/

              markers: [
                Marker(markerId: MarkerId('1'), position: widget.latLng)
              ].toSet(),
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: widget.latLng, zoom: 15),
            ),
          /*  Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                alignment: Alignment.center,
                height: 46,width: 46,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.grey[300]),
                child: AppIcons.googleMap(AppColors),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}

/*
class PlatformViewVerticalGestureRecognizer
    extends HorizontalDragGestureRecognizer {
  PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
      : super(kind: kind);

  Offset _dragDistance = Offset.zero;

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    _dragDistance = _dragDistance + event.delta;
    if (event is PointerMoveEvent) {
      final double dy = _dragDistance.dy.abs();
      final double dx = _dragDistance.dx.abs();

      if (dy > dx && dy > kTouchSlop) {
        // vertical drag - accept
        resolve(GestureDisposition.accepted);
        _dragDistance = Offset.zero;
      } else if (dx > kTouchSlop && dx > dy) {
        // horizontal drag - stop tracking
        stopTrackingPointer(event.pointer);
        _dragDistance = Offset.zero;
      }
    }
  }

  @override
  String get debugDescription => 'horizontal drag (platform view)';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
*/
