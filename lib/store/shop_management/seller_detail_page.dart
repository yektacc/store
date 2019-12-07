import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/data_layer/shop_management/seller_repository.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class SellerDetailPage extends StatefulWidget {
  final Shop seller;

  SellerDetailPage(this.seller);

  @override
  _SellerDetailPageState createState() => _SellerDetailPageState();
}

class _SellerDetailPageState extends State<SellerDetailPage> {
  ShopRepository _repo;
  BehaviorSubject<List<PrdItem>> editedPrdItems = BehaviorSubject.seeded([]);
  Map<String, List<SellerPrd>> categoryTabsPrds = HashMap();
  final BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);

  @override
  void dispose() {
    editedPrdItems.close();
    loading.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_repo == null) {
      _repo = Provider.of<ShopRepository>(context);
    }

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

    return FutureBuilder(
        future: _repo.getProductsOfSeller(widget.seller.id),
        builder: (context, AsyncSnapshot<List<SellerPrd>> prdSnapshot) {
          if (prdSnapshot.data != null) {
            if (categoryTabsPrds.isEmpty) {
              prdSnapshot.data.forEach((prd) {
                var catName = prd.petName + ' ,' + prd.categoryName;
                if (categoryTabsPrds.containsKey(catName)) {
                  categoryTabsPrds.update(
                      catName, (oldList) => oldList + [prd]);
                } else {
                  categoryTabsPrds.putIfAbsent(catName, () => [prd]);
                }
              });
            }

            return DefaultTabController(
              length: categoryTabsPrds.length,
              child: Scaffold(
                  appBar: AppBar(
                    title: Row(
                      children: <Widget>[
                        Text(
                          "محصولات شما",
                          style: TextStyle(fontSize: 15),
                        ),
                        /* Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.seller.centerName,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      )*/
                      ],
                    ),
                    bottom: TabBar(
                      indicatorColor: Colors.white,
                      isScrollable: true,
                      tabs: categoryTabsPrds.keys
                          .map((key) => Tab(
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
                  body: StreamBuilder<bool>(
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
                                  future: _repo
                                      .getProductsOfSeller(widget.seller.id),
                                  builder: (context,
                                      AsyncSnapshot<List<SellerPrd>>
                                          prdSnapshot) {
                                    if (prdSnapshot.data != null) {
                                      if (categoryTabsPrds.isEmpty) {
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
                                      }

                                      return Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: TabBarView(
                                              children: categoryTabsPrds.keys
                                                  .map((key) {
                                                return ListView(
                                                  children:
                                                      categoryTabsPrds[key]
                                                          .map((sp) {
                                                    return PrdItem(
                                                        sp, editedPrdItems);
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
                                                if (editedSnapshot
                                                    .data.isNotEmpty) {
                                                  return Container(
                                                    height: 64,
                                                    color: Colors.grey[200],
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        loading.add(true);
                                                        var shopRepo = Provider
                                                            .of<ShopRepository>(
                                                                context);

                                                        var res = await shopRepo
                                                            .editProductOfSeller(
                                                                editedSnapshot
                                                                    .data);
                                                        loading.add(false);

                                                        if (res) {
                                                          Future.delayed(Duration.zero,() {
                                                            Navigator.pop(context);
                                                          });
                                                          Helpers.showToast(
                                                              'تغییرات با موفقیت انجام گرفت');
                                                        } else {
                                                          Helpers
                                                              .showDefaultErr();
                                                        }
                                                      },
                                                      child: Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Card(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40)),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 6,
                                                                        right:
                                                                            10,
                                                                        top: 7,
                                                                        bottom:
                                                                            7),
                                                                elevation: 7,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: AppColors
                                                                          .main_color,
                                                                      size: 24,
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          56,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(),
                                                                      child:
                                                                          Text(
                                                                        '  ثبت تغییرات',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14),
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
                                                                        BorderRadius.circular(
                                                                            40)),
                                                                color: AppColors
                                                                    .main_color,
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          editedPrdItems
                                                                              .value
                                                                              .length
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
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
                                      );
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
                  )),
            );
          } else {
            return Container();
          }
        });
  }
}

class PrdItem extends StatefulWidget {
  final SellerPrd prd;
  final BehaviorSubject<List<PrdItem>> editedPrdItems;
  bool hasChanged;
  var newPrice;
  var newCount;
  var deliveryHour;
  var maxOrder;

  PrdItem(this.prd, this.editedPrdItems);

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
                                        widget.newPrice = price;
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
                                    keyboardType: TextInputType.number,
                                    onChanged: (count) {
                                      setState(() {
                                        _isChanged();
                                        widget.newCount = count;
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
                                    onChanged: (hour) {
                                      setState(() {
                                        _isChanged();
                                        widget.deliveryHour = hour;
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
                                    keyboardType: TextInputType.number,
                                    onChanged: (max) {
                                      setState(() {
                                        _isChanged();
                                        widget.maxOrder = max;
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
