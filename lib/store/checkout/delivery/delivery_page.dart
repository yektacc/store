import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/data_layer/order/save_order_repository.dart';
import 'package:store/data_layer/payment/delivery/delivery_price_repository.dart';
import 'package:store/data_layer/payment/delivery/delivery_time.dart';
import 'package:store/store/checkout/checkout_event_state.dart';
import 'package:store/store/products/cart/model.dart';
import 'package:store/store/products/filter/filter.dart';

import '../checkout_bloc.dart';
import '../payment/payment_page.dart';

class DeliveryPage extends StatefulWidget {
  static const String routeName = 'deliverypage';

  /* final String orderCode;
  final Address _address;
  final String sessionId;*/

  DeliveryPage(/*this._address, this.orderCode, this.sessionId*/);

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  var selectedDayOfMonth = BehaviorSubject<List<PersianDayOfMonth>>.seeded([]);
  var selectedHourFrom = BehaviorSubject.seeded(-1);
  var selectedHourTo = BehaviorSubject<int>.seeded(-1);
  StreamSubscription checkoutSub;

  @override
  void dispose() {
    selectedDayOfMonth.close();
    selectedHourFrom.close();
    selectedHourTo.close();
    checkoutSub.cancel();
    super.dispose();
  }

//  CartBloc _cartBloc;
//  ProductDetailRepository _detailRepo;
//  CentersBloc _centersBloc;
  CheckoutBloc _checkoutBloc;

//  BehaviorSubject<Price> totalPrice = BehaviorSubject();

  @override
  Widget build(BuildContext context) {
    /* if (_cartBloc == null) {
      _cartBloc = Provider.of<CartBloc>(context);
    }*/
/*

    if (_detailRepo == null) {
      _detailRepo = Provider.of<ProductDetailRepository>(context);
    }

    if (_centersBloc == null) {
      _centersBloc = Provider.of<CentersBloc>(context);
    }
*/

    _checkoutBloc ??= Provider.of<CheckoutBloc>(context);

//    _cartBloc.dispatch(FetchCart());

    return BlocBuilder<CheckoutBloc, CheckoutState>(
      bloc: _checkoutBloc,
      builder: (context, checkoutState) {
        print('new state: ' + checkoutState.toString());
        if (checkoutState is OrderWithDeliveryInf) {
          return Scaffold(
            appBar: CustomAppBar(
              titleText: "ارسال",
              light: true,
              elevation: 0,
              /*   leading: IconButton(
                onPressed: () {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.main_color,
                ),
              ),*/
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<Widget>(
                      stream: _buildDeliveryItemWgts(
                          checkoutState.cart.products,
                          context,
                          checkoutState.deliveryInfo.items),
                      builder: (context, snapshot) {
                        print('VERY ITEMS TO WIDGET  $snapshot');
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
                  height: 60,
                  width: double.infinity,
                  padding: EdgeInsets.only(right: 12, top: 16, bottom: 16),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "مجموع هزینه حمل: ${checkoutState.deliveryInfo
                            .totalPrice.formatted()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.main_color),
                      )
                    ],
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return DeliveryTimePicker(selectedDayOfMonth,
                              selectedHourFrom, selectedHourTo, () async {
                                DeliveryTime deliveryTime = DeliveryTime(
                                    selectedDayOfMonth.value,
                                    selectedHourFrom.value,
                                    selectedHourTo.value);

                                _checkoutBloc.dispatch(
                                    SubmitDelivery(deliveryTime));

                                checkoutSub ??=
                                    _checkoutBloc.state.listen((state) {
                                      print('new state:' + state.toString());
                                      if (state is OrderPayment) {
                                        Navigator.of(context).pushNamed(
                                            PaymentPage.routeName);
                                      }
                                    });

                                /* if (totalPrice.value != null && res) {
                             */ /* Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                      widget._address,
                                      totalPrice.value,
                                      widget.orderCode,
                                      widget.sessionId)));*/ /*
                            } else {
                              Helpers.errorToast();
                            }*/
                              });
                        });
                  },
                  child: Hero(
                      tag: "bottom_bar",
                      child: PickDeliveryDateBottomBar(true)),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  /*List getCityProvinceByShopId(int shopId, List<CenterItem> shops) {
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

  Future<List<WeightProduct>> getWeightedProducts(
      List<CartProduct> allCartProducts) async {
    print("all cart products in weightproducts function: " +
        allCartProducts.toString());

    var mappedList = allCartProducts.map((cartProduct) async {
      return await weightProduct(cartProduct);
    }).toList();

    List<WeightProduct> list = await Future.wait(mappedList);

    return list;
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
  }*/

  Stream<Widget> _buildDeliveryItemWgts(List<CartProduct> products,
      BuildContext context, List<DeliveryItem> deliveryItems) async* {
    yield ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
        )
      ] +
          deliveryItems.map((di) => DeliveryItemWgt(di)).toList(),
    );
//    List<DeliveryItem> deliveryItems = [];

    /*  List<WeightProduct> weightedProducts = await getWeightedProducts(products);

    print('weighted products: ' + weightedProducts.toString());

    var _centersRepo = Provider.of<CentersRepository>(context);

    var stores =
        await _centersRepo.getCenters(CenterFilter(CenterFetchType.STORE));*/

    /*if (deliveryItems.isEmpty) {
      if (stores != null) {
        if (stores.isNotEmpty && stores[0].typeId == 4) {
          List<CenterItem> shops = stores;

          City tmpCity;

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

         
        }
      } else {
        yield Center(
          child: LoadingIndicator(),
        );
      }*/
  }

/* await for (final state in _centersBloc.state) {

    }
  }*/
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
                                color: AppColors.main_color),
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
                                      widget.deliveryItem.getTotalWeight()),
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
