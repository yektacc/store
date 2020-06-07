import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/services/centers/center_detail_page.dart';
import 'package:store/services/centers/centers_event_state.dart';
import 'package:store/services/centers/filter_widget.dart';
import 'package:store/store/products/search/search_bloc.dart';

import 'centers_bloc.dart';
import 'model.dart';

class CentersListPage extends StatefulWidget {
  static const String routeName = 'centerpage';

  final CenterFilterWidget filterWidget;

  final CenterFetchType type;

  CentersListPage(this.type)
      : this.filterWidget = CenterFilterWidget(CenterFilter(type));

  @override
  _CentersListPageState createState() => _CentersListPageState();
}

class _CentersListPageState extends State<CentersListPage> {
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
    }

    widget.filterWidget.filters
        .listen((filter) => _centersBloc.dispatch(FetchCenters(filter)));

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
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return widget.filterWidget;
                          });
                    },
                    child: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                    backgroundColor: AppColors.main_color),
                appBar: CustomAppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: CentersSearchDelegate(widget.type),
                        );
                      },
                    ), IconButton(
                      icon: Icon(Icons.chat),
                      onPressed: () {
//                       Provider.of<InboxManager>(context).userInbox.dispatch(SendBroadcast());
                      },
                    )
                  ],
                  titleText: name,
                ),
                body: ListView(
                  children: state.centers
                      .map((center) => ClinicItemWgt(center))
                      .toList(),
                ));
          } else {
            return Scaffold(
              appBar: CustomAppBar(
                titleText: name,
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
//          textDirection: TextDirection.ltr,
          children: <Widget>[
            new Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  width: 110,
                  child: widget._item.logoUrl != ''
                      ? Helpers.image(widget._item.logoUrl)
                      : Container(
                    width: 110,
                    height: 110,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.store,
                      size: 80,
                      color: Colors.grey[100],
                    ),
                  ),
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
                            rating:
                            double.parse(widget._item.score, (err) => 3.0),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: AppColors.main_color,
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

class CentersSearchDelegate extends SearchDelegate {
  final CenterFetchType type;

  CentersSearchDelegate(this.type);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "متن جستجو باید حداقل ۳ حرف باشد",
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
    var searchBloc = Provider.of<SearchBloc>(context);

    searchBloc.dispatch(SearchCenters(query, type));

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is LoadingResults) {
          return LoadingIndicator();
        } else if (state is NoResult) {
          return Column(
            children: <Widget>[
              Text(
                "نتیجه‌ای یافت نشد",
              ),
            ],
          );
        } else if (state is CenterSearchLoaded) {
          var results = state.results;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];
              return CenterSearchItemWidget(result);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}

class CenterSearchItemWidget extends StatelessWidget {
  final CenterItem item;

  CenterSearchItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () =>
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => CenterDetailPage(item))),
        child: ListTile(
          title: Text(item.name),
          leading: Container(
            child: Helpers.image(item.logoUrl),
            margin: EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}
