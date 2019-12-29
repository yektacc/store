import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/data_layer/shop_management/shop_repository.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/products_bloc.dart';
import 'package:store/store/products/product/products_bloc_event.dart';

class SellerAddProductsPage extends StatefulWidget {
  static const String routeName = 'selleraddproduct';

  final ShopIdentifier shop;

  SellerAddProductsPage({@required this.shop});

  final priceController = TextEditingController();
  final countController = TextEditingController();
  final delHoursController = TextEditingController();
  final maximumOrderController = TextEditingController();

  @override
  _SellerAddProductsPageState createState() => _SellerAddProductsPageState();
}

class _SellerAddProductsPageState extends State<SellerAddProductsPage> {
  ProductsBloc _productsBloc;
  ShopRepository _shopRepository;

  final _formKey = GlobalKey<FormState>();
  final List<PricingProduct> selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    if (_productsBloc == null) {
      _productsBloc = Provider.of<ProductsBloc>(context);
    }

    if (_shopRepository == null) {
      _shopRepository = Provider.of<ShopRepository>(context);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedProducts.isNotEmpty) {
            bool res = await _shopRepository.submitProduct(
                selectedProducts[0], widget.shop.id.toString());
            if (res) {
              Helpers.showToast('تغییرات با موفقیت ثبت شد');
              Navigator.pop(context);
            } else {
              Helpers.showDefaultErr();
            }
          }
        },
        child: Center(
          child: Text("تایید"),
        ),
      ),
      appBar: AppBar(
        title: Text("قیمت دهی"),
      ),
      body: new BlocBuilder(
        bloc: _productsBloc,
        builder: (context, ProductsState state) {
          if (state is ProductsLoaded) {
            List<String> addedIds = [];
            List<Product> singleIdProducts = [];
            state.products.forEach((product) {
              if (!addedIds.contains(product.variantId)) {
                singleIdProducts.add(product);
                addedIds.add(product.variantId);
              }
            });

            return ListView(
                children: singleIdProducts
                    .map(
                      (p) => _buildProductItem(p, () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: new Container(
                                  alignment: Alignment.center,
                                  child: Form(
                                      key: _formKey,
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            height: 60,
                                            child: TextFormField(
                                              style: TextStyle(fontSize: 13),
                                              controller:
                                                  widget.priceController,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  hintText: " قیمت (به تومان)",
                                                  hintStyle:
                                                      TextStyle(fontSize: 13)),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'لطفا این فیلد را تکمیل کنید';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: TextFormField(
                                              style: TextStyle(fontSize: 13),
                                              controller:
                                                  widget.countController,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  hintText: "تعداد",
                                                  hintStyle:
                                                      TextStyle(fontSize: 13)),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'لطفا این فیلد را تکمیل کنید';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: TextFormField(
                                              style: TextStyle(fontSize: 13),
                                              controller:
                                                  widget.delHoursController,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "زمان تحویل (به ساعت)",
                                                  hintStyle:
                                                      TextStyle(fontSize: 13)),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'لطفا این فیلد را تکمیل کنید';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: TextFormField(
                                              style: TextStyle(fontSize: 13),
                                              controller:
                                                  widget.maximumOrderController,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "حداکثر کالای قابل سفارش",
                                                  hintStyle:
                                                      TextStyle(fontSize: 13)),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'لطفا این فیلد را تکمیل کنید';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            color: Colors.grey[100],
                                            height: 40,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: RaisedButton(
                                                color: AppColors.main_color,
                                                child: Text(
                                                  "تایید",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    selectedProducts.add(
                                                        PricingProduct(
                                                            p,
                                                            widget
                                                                .priceController
                                                                .text,
                                                            widget
                                                                .countController
                                                                .text,
                                                            int.parse(widget
                                                                .delHoursController
                                                                .text),
                                                            int.parse(widget
                                                                .maximumOrderController
                                                                .text)));

                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();

                                                    widget.priceController
                                                        .text = '';
                                                    widget.countController
                                                        .text = '';
                                                    widget.delHoursController
                                                        .text = '';
                                                    setState(() {});
                                                  }
                                                }),
                                          )
                                        ],
                                      )),
                                ),
                              );
                            });
                      }, () {
                        if (selectedProducts
                            .map((pp) => pp.product)
                            .contains(p)) {
                          selectedProducts.removeWhere((pp) => pp.product == p);
                          setState(() {});
                        }
                      },
                          selected: selectedProducts.isNotEmpty &&
                              selectedProducts
                                  .map((pp) => pp.product)
                                  .toList()
                                  .contains(p),
                          price: selectedProducts.isNotEmpty &&
                                  selectedProducts
                                      .map((pp) => pp.product)
                                      .toList()
                                      .contains(p)
                              ? selectedProducts
                                  .firstWhere((pp) => pp.product == p)
                                  .salePrice
                              : null,
                          count: selectedProducts.isNotEmpty &&
                                  selectedProducts
                                      .map((pp) => pp.product)
                                      .toList()
                                      .contains(p)
                              ? selectedProducts
                                  .firstWhere((pp) => pp.product == p)
                                  .count
                              : null),
                    )
                    .toList());
          } else {
            return LoadingIndicator();
          }
        },
      ),
    );
  }

  Widget _buildProductItem(
      Product product, VoidCallback onClick, VoidCallback onDeleteClicked,
      {bool selected = false, String price, String count}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              selected
                  ? Container()
                  : new Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: 65,
                      margin: EdgeInsets.only(right: 6),
                      child: RaisedButton(
                        color: AppColors.main_color,
                        onPressed: () {
                          onClick();
                        },
                        child: Text(
                          "انتخاب",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(right: 10, left: 10, top: 8),
                    height: 70,
                    child: Text(product.name)),
              ),
              Helpers.image(product.imgUrl, height: 50, width: 50)
            ],
          ),
          !selected
              ? Container()
              : Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        color: Colors.grey[100],
                        child: Row(
                          children: <Widget>[
                            Text("     تعداد :   "),
                            Text("$count عدد "),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        color: Colors.grey[100],
                        child: Row(
                          children: <Widget>[
                            Text("قیمت :   "),
                            Text("$price تومان "),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      color: Colors.grey[100],
                      child: IconButton(
                        onPressed: () => onDeleteClicked(),
                        icon: Icon(Icons.delete),
                        color: AppColors.main_color,
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}

class PricingProduct {
  final Product product;
  final String salePrice;
  final String count;
  final int shippingTime;
  final int maximumOrderable;

  PricingProduct(this.product, this.salePrice, this.count, this.shippingTime,
      this.maximumOrderable);
}
