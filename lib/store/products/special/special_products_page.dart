import 'package:flutter/material.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/product_item_wgt.dart';
import 'package:store/store/products/special/special_products_repository.dart';
import 'package:provider/provider.dart';

class SpecialProductsPage extends StatefulWidget {
  final SpecialProductType type;

  SpecialProductsPage(this.type) {}

  @override
  _SpecialProductsPageState createState() => _SpecialProductsPageState();
}

class _SpecialProductsPageState extends State<SpecialProductsPage> {
  String appBarTitle = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Container(
        child: FutureBuilder<List<Product>>(
          future: Provider.of<SpecialProductsRepository>(context)
              .getSpecialProducts(widget.type),
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data
                  .map((p) => ProductListItem(
                      p, Provider.of<CartBloc>(context).getCount(p)))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case SpecialProductType.BEST_SELLER:
        appBarTitle = 'محصولات پرفروش';
        break;
      case SpecialProductType.NEWEST:
        appBarTitle = 'جدید‌ترین محصولات';
        break;
    }
  }
}
