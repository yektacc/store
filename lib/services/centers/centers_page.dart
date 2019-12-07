import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/services/centers/centers_detail_page.dart';
import 'package:store/services/centers/centers_event_state.dart';
import 'package:provider/provider.dart';

import '../../data_layer/centers/centers_repository.dart';
import 'centers_bloc.dart';
import 'model.dart';

class CenterPage extends StatefulWidget {
  static const String routeName = 'centerpage';

  final CenterFetchType type;

  CenterPage(this.type);

  @override
  _CenterPageState createState() => _CenterPageState();
}

class _CenterPageState extends State<CenterPage> {
  GoogleMapController mapController;
  CentersBloc _centersBloc;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    var name = '';

    switch (widget.type) {
      case CenterFetchType.CLINICS:
        name = "کلینیک ها";
        break;
      case CenterFetchType.PENSION_BARBER:
        name = "پانسیون و آرایشگاه ها";
        break;
      case CenterFetchType.STORE:
        name = "فروشگاه ها";
        break;
      case CenterFetchType.ALL:
        break;
    }

    if (_centersBloc == null) {
      _centersBloc = Provider.of<CentersBloc>(context);
      _centersBloc.dispatch(Reset());
      _centersBloc.dispatch(FetchCenters(widget.type));
    }

    return BlocBuilder(
      bloc: _centersBloc,
      builder: (context, CentersState state) {
        List<Marker> markers;
        if (state is CentersLoaded) {
          if (state.centers.isNotEmpty) {
            markers = [
              Marker(
                position: state.centers[0].location,
                markerId: MarkerId("my_location_pin"),
              ),
              Marker(
                position: state.centers[0].location,
                markerId: MarkerId("my_location_pin"),
              )
            ];
            return Scaffold(
                appBar: AppBar(
                  title: Text(name,
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                ),
                body: ListView(
                  children: state.centers
                      .map((center) => ClinicItemWgt(center))
                      .toList(),
                ) /*new NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    new SliverAppBar(
                      backgroundColor: Colors.grey[300],
                      title: Text(name,
                          style: TextStyle(
                            color: AppColors.main_color,
                            fontSize: 16.0,
                          )),
                      expandedHeight: 360.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          background: SafeArea(
                              child: Container(
                        height: 100,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          margin: EdgeInsets.only(
                              top: 56, bottom: 13, right: 9, left: 9),
                          child: Container(
                            child: GoogleMap(
                              gestureRecognizers: [
                                Factory(() =>
                                    PlatformViewVerticalGestureRecognizer()),
                              ].toSet(),
                              markers:
                                  markers != null ? markers.toSet() : Set(),
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                  target: state.centers != null &&
                                          state.centers.isNotEmpty
                                      ? state.centers[0].location
                                      : LatLng(36, 43),
                                  zoom: 15),
                            ),
                          ),
                        ),
                      ))),
                    ),
                  ];
                },
                body: ListView(
                  children: state.centers
                      .map((center) => ClinicItemWgt(center))
                      .toList(),
                ),
              ),*/
                );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(name),
              ),
              body: Center(
                child: Text('مرکزی پیدا نشد'),
              ),
            );
          }
        } else {
          return Container(
            color: Colors.white,
            child: LoadingIndicator(),
          );
        }
      },
    );
  }
}

/*class PlatformViewVerticalGestureRecognizer
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
}*/

class ClinicItemWgt extends StatefulWidget {
  final CenterItem _item;

  ClinicItemWgt(this._item);

  @override
  _ClinicItemWgtState createState() => _ClinicItemWgtState();
}

class _ClinicItemWgtState extends State<ClinicItemWgt> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CenterDetailPage(widget._item)));
      },
      child: Card(
          child: new Container(
        height: 122,
        width: double.infinity,
        child: Row(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            new Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]),
                      borderRadius: BorderRadius.circular(3)),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  width: 110,
                  child: FutureBuilder<String>(
                      future: Provider.of<CentersRepository>(context)
                          .getCenterImgUrl(widget._item.id.toString()),
                      builder: (context, snapshot) {
                        if (snapshot != null &&
                            snapshot.data != null &&
                            snapshot.data != '') {
                          print('asdfadsfasdf' + snapshot.data);
                          return Helpers.image(snapshot.data);
                        } else {
                          return Container();
                        }
                      }),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text(
                      widget._item.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                    padding: EdgeInsets.only(right: 5, top: 6),
                  ),
                  Divider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 5, top: 6, bottom: 10),
                      child: Text(
                        widget._item.description,
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding:
                                EdgeInsets.only(bottom: 7, right: 10, top: 7),
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget._item.typeName,
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.main_color),
                              ),
                            ),
                          ),
                        ),
                        /*  Image.network("http://51.254.65.54/epet24/public/" +
                              widget._item.typeImg)*/
                        Container(
                          child: RatingBarIndicator(
                            unratedColor: Colors.grey[400],
                            rating: double.parse(
                                widget._item.score,
                                    (err) => 3.0),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: AppColors.second_color,
                            ),
                            itemCount: 5,
                            itemSize: 16.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                        /*    Container(
                            height: 20,
                            width: 20,
                            child: SvgPicture.network(
                              "http://51.254.65.54/epet24/public/" +
                                  widget._item.typeImg,
                              color: Colors.white,
                            ),
                          )*/
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
