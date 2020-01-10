import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/data_layer/centers/centers_repository.dart';
import 'package:store/data_layer/order/save_order_repository.dart';
import 'package:store/data_layer/payment/delivery/delivery_price_repository.dart';
import 'package:store/data_layer/payment/delivery/delivery_time.dart';
import 'package:store/services/centers/centers_bloc.dart';
import 'package:store/services/centers/model.dart';
import 'package:store/store/location/address/model.dart';
import 'package:store/store/location/provinces/model.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/cart/cart_bloc_event.dart';
import 'package:store/store/products/cart/cart_product.dart';
import 'package:store/store/products/detail/product_detail_model.dart';
import 'package:store/store/products/detail/product_detail_repository.dart';
import 'package:store/store/products/filter/filter.dart';

import '../payment_page.dart';

class DeliveryPage extends StatefulWidget {
  final String orderCode;
  final Address _address;
  final String sessionId;

  DeliveryPage(this._address, this.orderCode, this.sessionId);

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  var selectedDayOfMonth = BehaviorSubject<List<DayOfMonth>>.seeded([]);
  var selectedHourFrom = BehaviorSubject.seeded(-1);
  var selectedHourTo = BehaviorSubject<int>.seeded(-1);

  @override
  void dispose() {
    selectedDayOfMonth.close();
    selectedHourFrom.close();
    selectedHourTo.close();
    super.dispose();
  }

  CartBloc _cartBloc;
  ProductDetailRepository _detailRepo;
  CentersBloc _centersBloc;

  BehaviorSubject<Price> totalPrice = BehaviorSubject();

  @override
  Widget build(BuildContext context) {
    if (_cartBloc == null) {
      _cartBloc = Provider.of<CartBloc>(context);
    }

    if (_detailRepo == null) {
      _detailRepo = Provider.of<ProductDetailRepository>(context);
    }

    if (_centersBloc == null) {
      _centersBloc = Provider.of<CentersBloc>(context);
    }

    _cartBloc.dispatch(FetchCart());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          onPressed: () {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.main_color,
          ),
        ),
        title: Text(
          "ارسال",
          style: TextStyle(color: AppColors.main_color),
        ),
      ),
      body: new BlocBuilder(
        bloc: _cartBloc,
        builder: (context, CartState state) {
          if (state is CartLoading) {
            return LoadingIndicator();
          } else if (state is CartLoaded) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<Widget>(
                      stream: _buildDeliveryItemWgts(state.products, context),
                      builder: (context, snapshot) {
                        if (snapshot != null && snapshot.data != null) {
                          return snapshot.data;
                        } else {
                          return Center(
                            child: LoadingIndicator(),
                          );
                        }
                      }),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: EdgeInsets.only(right: 12, top: 16, bottom: 16),
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StreamBuilder(
                        stream: totalPrice,
                        builder: (context, AsyncSnapshot<Price> snapshot) {
                          if (snapshot.data != null) {
                            return Text(
                              "مجموع هزینه حمل: ${snapshot.data.formatted()}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.main_color),
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    var persianDateTime = PersianDateTime();

                    var day1 = persianDateTime.add(Duration(days: 1));
                    var day2 = persianDateTime.add(Duration(days: 2));
                    var day3 = persianDateTime.add(Duration(days: 3));
                    var day4 = persianDateTime.add(Duration(days: 4));
                    var day5 = persianDateTime.add(Duration(days: 5));
                    var day6 = persianDateTime.add(Duration(days: 6));
                    var day7 = persianDateTime.add(Duration(days: 7));

                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return DeliveryTimePicker([
                            DayOfMonth(day1.jalaaliDay, day1.jalaaliMonth,
                                day1.jalaaliMonthName),
                            DayOfMonth(day2.jalaaliDay, day2.jalaaliMonth,
                                day2.jalaaliMonthName),
                            DayOfMonth(day3.jalaaliDay, day3.jalaaliMonth,
                                day3.jalaaliMonthName),
                            DayOfMonth(day4.jalaaliDay, day4.jalaaliMonth,
                                day4.jalaaliMonthName),
                            DayOfMonth(day5.jalaaliDay, day5.jalaaliMonth,
                                day5.jalaaliMonthName),
                            DayOfMonth(day6.jalaaliDay, day6.jalaaliMonth,
                                day6.jalaaliMonthName),
                            DayOfMonth(day7.jalaaliDay, day7.jalaaliMonth,
                                day7.jalaaliMonthName),
                          ], selectedDayOfMonth, selectedHourFrom,
                              selectedHourTo, () async {
                            DeliveryTime deliveryTime = DeliveryTime(
                                selectedDayOfMonth.value,
                                selectedHourFrom.value,
                                selectedHourTo.value);

                            var res =
                                await Provider.of<OrderRepository>(context)
                                    .save(
                                        widget.sessionId,
                                        widget.orderCode,
                                        widget._address.id.toString(),
                                        Provider.of<CartBloc>(context)
                                            .getTotal(),
                                        totalPrice.stream.value.amount,
                                        deliveryTime);

                            if (totalPrice.value != null && res) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                      widget._address,
                                      totalPrice.value,
                                      widget.orderCode,
                                      widget.sessionId)));
                            } else {
                              Helpers.errorToast();
                            }
                          });
                        });
                  },
                  child: Hero(
                      tag: "bottom_bar",
                      child: PickDeliveryDateBottomBar(true)),
                )
              ],
            );
          } else {
            return Container(
              child: Text('err'),
            );
          }
        },
      ),
    );
  }

  List getCityProvinceByShopId(int shopId, List<CenterItem> shops) {
    print('shops: ${shops.map((s) => s.id).toList().toString()}');
    print('shopId: $shopId');

    if (shops.map((s) => s.id).contains(shopId)) {
      return [
        shops.firstWhere((shop) => shop.id == shopId).city,
        shops.firstWhere((shop) => shop.id == shopId).province
      ];
    } else {
      Helpers.showToast(
          '${shops.map((s) => s.id.toString() + ' ')}خطا در اتصال!');
    }
  }

  Stream<Widget> _buildDeliveryItemWgts(
      List<CartProduct> products, BuildContext context) async* {
    List<DeliveryItem> deliveryItems = [];

/*
    List<WeightProduct> weightProducts = [];
*/

/*
    categorizedById.forEach((id, sameIdProducts) async* {
      await for (final snapshot in getProductsWeighted(id, sameIdProducts)) {
        deliveryItems.
      }
    })*/

/*    CentersBloc centersBloc = Provider.of<CentersBloc>(context);

    */

/*    getWeightedProducts(products)
        .then((weighted) {
      print("@#DSSSSSSSAAAAAAAAAAAA" + weighted[0].weight.toString());
    });*/

    List<WeightProduct> weightedProducts = await getWeightedProducts(products);

    print('weighted products: ' + weightedProducts.toString());

/*
    _centersBloc.dispatch(FetchCenters(CenterFetchType.STORE));
*/

    var _centersRepo = Provider.of<CentersRepository>(context);

    var stores = await _centersRepo.getCenters(CenterFetchType.STORE);

    if (deliveryItems.isEmpty) {
      if (stores != null) {
        if (stores.isNotEmpty && stores[0].typeId == 4) {
          List<CenterItem> shops = stores;

          City tmpCity;

          /*   weightedProducts.forEach((product) {
              tmpCity = getCityProvinceByShopId(
                  int.parse(product.product.storeThumbnail.id), shops)[0];

              Province province = getCityProvinceByShopId(
                  int.parse(product.product.storeThumbnail.id), shops)[1];

              if (deliveryItems.map((di) => di.city).contains(tmpCity)) {
                deliveryItems
                    .firstWhere((di) => di.city == tmpCity)
                    .products
                    .add(product);
              } else {
                deliveryItems.add(DeliveryItem(tmpCity, province, [product]));
              }
            });*/

          int tmpShopId;

          weightedProducts.forEach((product) {
            tmpCity = getCityProvinceByShopId(
                int.parse(product.product.storeThumbnail.id), shops)[0];

            Province province = getCityProvinceByShopId(
                int.parse(product.product.storeThumbnail.id), shops)[1];

            if (deliveryItems
                .map((di) => di.sellerId)
                .contains(int.parse(product.product.storeThumbnail.id))) {
              var availableDi = deliveryItems
                  .firstWhere((DeliveryItem di) =>
              di.sellerId ==
                  int.parse(product.product.storeThumbnail.id))
                  .products
                  .add(product);
            } else {
              deliveryItems.add(DeliveryItem(tmpCity, province, [product],
                  int.parse(product.product.storeThumbnail.id)));
            }
          });

          totalPrice.add(await getTotalPrice(deliveryItems));

          yield ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12),
              ) as Widget
            ] +
                deliveryItems.map((di) => DeliveryItemWgt(di)).toList(),
          );
        }
      } else {
        yield Center(
          child: LoadingIndicator(),
        );
      }
    }

    /* await for (final state in _centersBloc.state) {

    }*/
  }

  Future<List<WeightProduct>> getWeightedProducts(
      List<CartProduct> allCartProducts) async {
    print("all cart products in weightproducts function: " +
        allCartProducts.toString());

    var mappedList = allCartProducts.map((cartProduct) async {
      return await weightProduct(cartProduct);
    }).toList();

    List<WeightProduct> list = await Future.wait(mappedList);

    return list;

    /* Map<String, List<CartProduct>> categorizedById = HashMap();

    List<WeightProduct> allWeighted = [];

    allCartProducts.forEach((cartProduct) {
      var id = cartProduct.product.id;
      if (categorizedById.containsKey(id)) {
        categorizedById[id].add(cartProduct);
      } else {
        categorizedById.putIfAbsent(
            cartProduct.product.id, () => [cartProduct]);
      }
    });

    categorizedById.forEach((id, products) {
      getProductsWeighted(id, products).listen((weighted) {
        allWeighted.addAll(weighted);
          return allWeighted;

      });
    });*/
  }

  Future<Price> getTotalPrice(List<DeliveryItem> items) async {
    var mappedList = items.map((deliveryItem) async {
      return await Provider.of<DeliveryPriceRepository>(context).getPrice(
          deliveryItem.city,
          deliveryItem.province,
          deliveryItem._getTotalWeight());
    }).toList();

    List<int> list = await Future.wait(mappedList);

    int price = list.fold(0, (pr, cost) => pr + cost);

    return Price(price.toString());
  }

  List<DetailedProduct> _detailCache;

  Future<WeightProduct> weightProduct(CartProduct cartProduct) async {
    print("weight function called: $cartProduct");
    var detail = await _detailRepo.load(cartProduct.product.id);
    return WeightProduct(cartProduct, double.parse(detail.weight),
        detail.unit == 'کیلوگرم' ? 1 : 0);
  }
}

class WeightProduct extends CartProduct {
  final int unit;
  final double weight;
  final String unitName;

  WeightProduct(CartProduct cartProduct, this.weight, this.unit)
      : this.unitName = unit == 1 ? 'کیلوگرم' : 'گرم',
        super(cartProduct.product, cartProduct.count);
}

class DeliveryItem {
  final City city;
  final Province province;
  final List<WeightProduct> products;
  final int sellerId;

  bool matchCity(City city) {
    return city.id == this.city.id;
  }

  double _getTotalWeight() {
    double total = products.fold(
        0.0,
        (pr, wp) =>
            pr + (wp.unit == 1 ? wp.weight : wp.weight / 1000) * wp.count);

    return total;
  }

  String getTotalWeightString() {
    var grams = _getTotalWeight() * 1000;

    return grams % 1000 == 0
        ? _getTotalWeight().toInt().toString() + ' کیلوگرم '
        : (_getTotalWeight() * 1000).round().toString() + ' گرم ';
  }

  DeliveryItem(this.city, this.province, this.products, this.sellerId);
}

class DeliveryItemWgt extends StatefulWidget {
  final DeliveryItem deliveryItem;

  DeliveryItemWgt(this.deliveryItem);

  @override
  _DeliveryItemWgtState createState() => _DeliveryItemWgtState();
}

class _DeliveryItemWgtState extends State<DeliveryItemWgt> {
  @override
  Widget build(BuildContext context) {
    print(
        'cart products inside delivery Item widget - ${widget.deliveryItem.city} : ${widget.deliveryItem.products} ');

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      child: Column(
        children: <Widget>[
          Container(
            height: 45,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4), topLeft: Radius.circular(4))),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(
                      Icons.location_on,
                      size: 19,
                      color: AppColors.main_color,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Text(
                      widget.deliveryItem.city.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main_color),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Text("ارسال از "),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.second_color),
                            padding: EdgeInsets.symmetric(horizontal: 13),
                            margin: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 9),
                                  child: Icon(
                                    Icons.store,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                ),
                                Text(
                                  widget.deliveryItem.products[0].product
                                      .storeThumbnail.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          new Container(
            child: Column(
              children: <Widget>[
                Container(
                    child: Container(
                  padding: EdgeInsets.only(left: 2, top: 2, bottom: 2),
                  child: Column(
                    children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ) as Widget
                        ] +
                        widget.deliveryItem.products
                            .map((p) => _buildProductItem(p))
                            .toList(),
                  ),
                )),
                Container(
                  height: 70,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 18),
                            child: Text(
                                "مجموع وزن: ${widget.deliveryItem.getTotalWeightString()} "),
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 9, bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 9, left: 6),
                                  child: Icon(
                                    Icons.local_shipping,
                                    size: 16,
                                    color: AppColors.main_color,
                                  ),
                                ),
                                FutureBuilder(
                                  future: Provider.of<DeliveryPriceRepository>(
                                          context)
                                      .getPrice(
                                          widget.deliveryItem.city,
                                          widget.deliveryItem.province,
                                          widget.deliveryItem
                                              ._getTotalWeight()),
                                  builder:
                                      (context, AsyncSnapshot<int> snapshot) {
                                    print("sdddddddddsss" +
                                        snapshot.data.toString());
                                    return Container(
                                      child: Text(
                                          "هزینه بسته بندی و حمل درون شهری: ${Price.parseFormatted(snapshot.data)}"),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductItem(WeightProduct product) {
    return Container(
      height: 56,
      margin: EdgeInsets.only(top: 0.7),
      color: Colors.grey[50],
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child:
                      Text("وزن: ${product.weight}  ${product.unitName}"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 30),
                      child: Text(
                        "تعداد: ${product.count}",
                        style: TextStyle(fontSize: 11, color: Colors.green),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        widget.deliveryItem.products[0].product.name,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Helpers.image(product.product.imgUrl),
          )
        ],
      ),
    );
  }
}

class PickDeliveryDateBottomBar extends StatelessWidget {
  final bool enabled;

  PickDeliveryDateBottomBar(this.enabled);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: enabled ? AppColors.main_color : Colors.grey[100],
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Icon(Icons.local_shipping,
                    color: enabled ? Colors.white : Colors.grey[500]),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "انتخاب وقت دریافت",
                style: TextStyle(
                    color: enabled ? Colors.white : AppColors.main_color,
                    fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
