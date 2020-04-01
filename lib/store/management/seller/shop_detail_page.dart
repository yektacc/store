import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/data_layer/management/management_repository.dart';
import 'package:store/store/management/seller/shop_management_bloc.dart';
import 'package:store/store/management/seller/shop_management_event_state.dart';
import 'package:store/store/products/filter/filter.dart';

class ShopProductsPage extends StatefulWidget {
//  final ShopIdentifier identifier;
  final ShopManagementBloc _shopManagementBloc;

  ShopProductsPage(this._shopManagementBloc) {
    _shopManagementBloc.dispatch(GetShopProducts());
  }

  @override
  _ShopProductsPageState createState() => _ShopProductsPageState();
}

class _ShopProductsPageState extends State<ShopProductsPage> {
  BehaviorSubject<List<PrdItem>> editedPrdItems = BehaviorSubject.seeded([]);
  Map<String, List<ShopProduct>> categoryTabsPrds = HashMap();

//  final BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);

  @override
  void dispose() {
    editedPrdItems.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    editedPrdItems.listen((edited) {
      edited.isNotEmpty
          ? showBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 56,
                  color: Colors.red,
                );
              })
          : Container();
    });

    return BlocBuilder<ShopManagementBloc, ShopManagerState>(
      bloc: widget._shopManagementBloc,
      builder: (context, state) {
        if (state is LoadingShopData) {
          return Scaffold(
            body: Center(
              child: LoadingIndicator(),
            ),
          );
        } else if (state is ShopDataLoaded) {
          editedPrdItems.add([]);

          if (categoryTabsPrds.isEmpty) {
            state.products.forEach((prd) {
              var catName = prd.product.petName + ' ,' +
                  prd.product.categoryName;
              if (categoryTabsPrds.containsKey(catName)) {
                categoryTabsPrds.update(
                    catName, (oldList) => oldList + [prd.product]);
              } else {
                categoryTabsPrds.putIfAbsent(catName, () => [prd.product]);
              }
            });
          }

          if (categoryTabsPrds.isEmpty) {
            state.products.forEach((prd) {
              var catName = prd.product.petName + ' ,' +
                  prd.product.categoryName;

              if (categoryTabsPrds.containsKey(catName)) {
                categoryTabsPrds.update(
                    catName, (oldList) => oldList + [prd.product]);
              } else {
                categoryTabsPrds.putIfAbsent(catName, () => [prd.product]);
              }
            });
          }

          return DefaultTabController(
            length: categoryTabsPrds.length,
            child: Scaffold(
                appBar: CustomAppBar(
                  altBackground: true,
                  title: Row(
                    children: <Widget>[
                      Text(
                        "محصولات شما",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    isScrollable: true,
                    tabs: categoryTabsPrds.keys
                        .map((key) =>
                        Tab(
                          child: Container(
                            child: Text(
                              key,
                              maxLines: 2,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ))
                        .toList(),
                  ),
                ),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: TabBarView(
                        children: categoryTabsPrds.keys.map((key) {
                          return ListView(
                            children: categoryTabsPrds[key].map((sp) {
                              return PrdItem(sp, editedPrdItems);
                            }).toList(),
                          );
                        }).toList()
                        /*<Widget>[
                                ,
                                */ /*ListView(
                                  children: snapshot.data.map((sp) {
                                    return PrdItem(sp, editedPrdItems);
                                  }).toList(),
                                ),
                                ListView(
                                  children: snapshot.data.map((sp) {
                                    return PrdItem(sp, editedPrdItems);
                                  }).toList(),
                                )*/ /*
                              ]*/
                        ,
                      ),
                    ),
                    StreamBuilder<List<PrdItem>>(
                      stream: editedPrdItems,
                      builder: (context, editedSnapshot) {
                        if (editedSnapshot.data != null) {
                          if (editedSnapshot.data.isNotEmpty) {
                            return Container(
                              height: 64,
                              color: Colors.grey[200],
                              child: GestureDetector(
                                onTap: () async {
                                  /*   var res = await (Provider.of<ShopRepository>(context))
                                        .editProductOfSeller(editedSnapshot.data
                                        .map((item) => item.prd)
                                        .toList());*/

                                  widget._shopManagementBloc.dispatch(
                                      EditShopProduct(editedSnapshot.data
                                          .map((item) => item.prd)
                                          .toList()));
                                },
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(40)),
                                          margin: EdgeInsets.only(
                                              left: 6,
                                              right: 10,
                                              top: 7,
                                              bottom: 7),
                                          elevation: 7,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.check,
                                                color: AppColors.main_color,
                                                size: 24,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: 56,
                                                padding: EdgeInsets.only(),
                                                child: Text(
                                                  '  ثبت تغییرات',
                                                  style:
                                                  TextStyle(fontSize: 14),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 56,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(40)),
                                          color: AppColors.main_color,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    editedPrdItems.value.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    '  کالا',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                ) /*StreamBuilder<bool>(
                    stream: loading,
                    builder: (context, loadingSnp) {
                      if (loadingSnp != null &&
                          loadingSnp.data != null &&
                          !loadingSnp.data) {
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: FutureBuilder(
                                  future: _repo.getFullShop(widget.seller),
                                  builder: (context,
                                      AsyncSnapshot<Shop> prdSnapshot) {
                                    if (prdSnapshot.data != null) {
                                      */ /*  if (categoryTabsPrds.isEmpty) {
                                        prdSnapshot.data.forEach((prd) {
                                          var catName = prd.petName +
                                              ' ,' +
                                              prd.categoryName;

                                          if (categoryTabsPrds
                                              .containsKey(catName)) {
                                            categoryTabsPrds.update(catName,
                                                    (oldList) => oldList + [prd]);
                                          } else {
                                            categoryTabsPrds.putIfAbsent(
                                                catName, () => [prd]);
                                          }
                                        });
                                      }*/ /*
                                      return ;
                                    } else {
                                      return LoadingIndicator();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return LoadingIndicator();
                      }
                    },
                  )*/
            ),
          );
        } else {
          return Container(
            height: 100,
            width: 100,
            color: Colors.red,
          );
        }
      },
    );

    /* return FutureBuilder(
        future: _repo.getFullShop(widget.seller.id),
        builder: (context, AsyncSnapshot<List<ShopProduct>> prdSnapshot) {

        });*/
  }
}

class PrdItem extends StatefulWidget {
  final ShopProduct prd;
  final BehaviorSubject<List<PrdItem>> editedPrdItems;
  bool hasChanged = false;

/*  var newPrice;
  var newCount;
  var deliveryHour;
  var maxOrder;*/

  PrdItem(this.prd, this.editedPrdItems) {
/*    this.newPrice = prd.salePrice;
    this.newCount = prd.stockQuantity;
    this.deliveryHour = prd.shippingTime;
    this.maxOrder = prd.maximumOrderable;*/
  }

  @override
  bool operator ==(other) {
    return other is PrdItem && other.prd == this.prd;
  }

  @override
  _PrdItemState createState() => _PrdItemState();
}

class _PrdItemState extends State<PrdItem> {
  _isChanged() {
    if (!widget.editedPrdItems.value.contains(widget)) {
      setState(() {
        widget.editedPrdItems.add((widget.editedPrdItems.value + [widget]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.hasChanged = widget.editedPrdItems.value.contains(widget);

    return Card(
      child: Container(
        padding: EdgeInsets.only(top: 3, bottom: 3),
        child: Column(
          children: <Widget>[
            Container(
              height: 110,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 11, top: 8),
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.prd.name,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            alignment: Alignment.centerRight,
                            child: Text(
                              Price(widget.prd.salePrice.toString())
                                  .formatted(),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.green),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    child: Helpers.image(widget.prd.img),
                  )
                ],
              ),
            ),
            ExpansionTile(
              title: Row(
                children: <Widget>[
                  Text(
                    'مشاهده و ویرایش جزییات',
                    style: TextStyle(fontSize: 13),
                  ),
                  widget.hasChanged
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200]),
                          margin: EdgeInsets.only(right: 16),
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Icon(
                            Icons.edit,
                            size: 17,
                            color: Colors.blue,
                          ),
                        )
                      : Container()
                ],
              ),
              children: <Widget>[
                Container(
                    height: 140,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                height: 60,
                                child: Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    initialValue:
                                        widget.prd.salePrice.toString(),
                                    onChanged: (price) {
                                      setState(() {
                                        _isChanged();
                                        widget.prd.salePrice = int.parse(price);
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        suffixText: 'تومان',
                                        suffixStyle: TextStyle(fontSize: 13),
                                        border: OutlineInputBorder(),
                                        labelText: 'قیمت',
                                        labelStyle: TextStyle(fontSize: 13)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                height: 60,
                                child: Container(
                                  child: TextFormField(
                                    initialValue:
                                    widget.prd.stockQuantity.toString(),
                                    keyboardType: TextInputType.number,
                                    onChanged: (quantity) {
                                      setState(() {
                                        _isChanged();
                                        widget.prd.stockQuantity =
                                            int.parse(quantity);
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'تعداد',
                                        labelStyle: TextStyle(fontSize: 13)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                height: 60,
                                child: Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    initialValue:
                                    widget.prd.shippingTime.toString(),
                                    onChanged: (hour) {
                                      setState(() {
                                        _isChanged();
                                        widget.prd.shippingTime =
                                            int.parse(hour);
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        suffixText: 'ساعت',
                                        suffixStyle: TextStyle(fontSize: 13),
                                        border: OutlineInputBorder(),
                                        labelText: 'مدت زمان تحویل',
                                        labelStyle: TextStyle(fontSize: 13)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                height: 60,
                                child: Container(
                                  child: TextFormField(
                                    initialValue:
                                    widget.prd.maximumOrderable.toString(),
                                    keyboardType: TextInputType.number,
                                    onChanged: (max) {
                                      setState(() {
                                        _isChanged();
                                        widget.prd.maximumOrderable =
                                            int.parse(max);
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'حداکثر سفارش',
                                        labelStyle: TextStyle(fontSize: 13)),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'شماره موبایل وارد نشده است';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
