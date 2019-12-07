/*
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/products/filter/filtered_products_bloc.dart';
import 'package:store/store/products/filter/filtered_products_bloc_event.dart';
import 'package:store/store/products/product/product_item_wgt.dart';
import 'package:provider/provider.dart';

import 'model.dart';

class PetShopPage extends StatefulWidget {
  final PetShop petShop;

  PetShopPage(this.petShop);

  @override
  _PetShopPageState createState() => _PetShopPageState();
}

class _PetShopPageState extends State<PetShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(widget.petShop.name,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                        )),
                    background: Container(
                      color: Colors.grey[200],
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 60,
                              child: Row(
                                children: <Widget>[
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      width: 50,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 6,
                                              left: 10,
                                              top: 8,
                                              bottom: 8),
                                          child: AppIcons.pets[0],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 7,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.greenAccent)),
                                      width: 50,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: AppIcons.pets[1],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      width: 50,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: AppIcons.pets[2],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      width: 50,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: AppIcons.pets[3],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Hero(
                            tag: widget.petShop.id,
                            child: Icon(
                              Icons.store,
                              color: Colors.blueGrey[200],
                              size: 100,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              new SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelPadding: EdgeInsets.all(0),
                    indicatorColor: AppColors.main_color,
                    isScrollable: true,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Container(
                        child: Center(
                          child: Text(
                            "غذا و مکمل گربه",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        color: Colors.grey[50],
                        height: 56,
                        width: 110,
                      ),
                      Container(
                        child: Center(
                          child: Text("جای خواب پرندگان",
                              style: TextStyle(fontSize: 12)),
                        ),
                        color: Colors.grey[50],
                        height: 56,
                        width: 110,
                      ),
                      Container(
                        child: Center(
                          child: Text("غذا و مکمل گربه",
                              style: TextStyle(fontSize: 12)),
                        ),
                        color: Colors.grey[50],
                        height: 56,
                        width: 110,
                      ),
                      Container(
                        child: Center(
                          child: Text("غذا و مکمل پرندگان",
                              style: TextStyle(fontSize: 12)),
                        ),
                        color: Colors.grey[50],
                        height: 56,
                        width: 110,
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: new Container(
            alignment: Alignment.center,
            child: new TabBarView(
              children: [
                Container(
                    child: BlocBuilder(
                        bloc: Provider.of<FilteredProductsBloc>(context),
                        builder: (context, FilteredProductsState state) {
                          if (state is LoadingFilteredProducts) {
                            return Center(
                              child: LoadingIndicator(),
                            );
                          } else if (state is FilteredProductsLoaded) {
                            return ListView(
                              children: state.filteredProducts
                                  .map((p) => ProductListItem(p, 0))
                                  .toList(),
                            );
                          } else {
                            return Container();
                          }
                        })),
                Container(
                    child: BlocBuilder(
                        bloc: Provider.of<FilteredProductsBloc>(context),
                        builder: (context, FilteredProductsState state) {
                          if (state is LoadingFilteredProducts) {
                            return Center(
                              child: LoadingIndicator(),
                            );
                          } else if (state is FilteredProductsLoaded) {
                            return ListView(
                              children: state.filteredProducts
                                  .map((p) => ProductListItem(p, 0))
                                  .toList(),
                            );
                          } else {
                            return Container();
                          }
                        })),
                Container(
                    child: BlocBuilder(
                        bloc: Provider.of<FilteredProductsBloc>(context),
                        builder: (context, FilteredProductsState state) {
                          if (state is LoadingFilteredProducts) {
                            return Center(
                              child: LoadingIndicator(),
                            );
                          } else if (state is FilteredProductsLoaded) {
                            return ListView(
                              children: state.filteredProducts
                                  .map((p) => ProductListItem(p, 0))
                                  .toList(),
                            );
                          } else {
                            return Container();
                          }
                        })),
                Container(
                    color: Colors.blue,
                    child: BlocBuilder(
                        bloc: Provider.of<FilteredProductsBloc>(context),
                        builder: (context, FilteredProductsState state) {
                          if (state is LoadingFilteredProducts) {
                            return Center(
                              child: LoadingIndicator(),
                            );
                          } else if (state is FilteredProductsLoaded) {
                            return ListView(
                              children: state.filteredProducts.reversed
                                  .map((p) => ProductListItem(p, 0))
                                  .toList(),
                            );
                          } else {
                            return Container();
                          }
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final IconData icon;
  final String text;

  CategoryTab(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 70,
          color: Colors.blue,
        )
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
*/
