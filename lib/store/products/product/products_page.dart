import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/store/products/cart/cart_bloc.dart';
import 'package:store/store/products/cart/cart_bloc_event.dart';
import 'package:store/store/products/cart/cart_page.dart';
import 'package:store/store/products/cart/model.dart';
import 'package:store/store/products/filter/filter_sort.dart';
import 'package:store/store/products/filter/filtered_products_bloc.dart';
import 'package:store/store/products/filter/filtered_products_bloc_event.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/product_item_wgt.dart';
import 'package:store/store/products/product/products_bloc.dart';
import 'package:store/store/products/product/products_bloc_event.dart';
import 'package:store/store/structure/model.dart';

class ProductsPage extends StatefulWidget {
  static const String routeName = 'productspage';

  ProductsPage();

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with TickerProviderStateMixin {
  BehaviorSubject<FilterTabState> isShownController =
      BehaviorSubject(sync: true);

  PersistentBottomSheetController _controller;

  // only used for getting identifier name for appbar title
  ProductsBloc _productsBloc;

  // main source of products
  FilteredProductsBloc _filteredProductsBloc;

  CartBloc _cartBloc;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (_productsBloc == null) {
      _productsBloc = Provider.of<ProductsBloc>(context);
/*
      _productsBloc.dispatch(LoadProducts(AllItems()));
*/
    }

    if (_filteredProductsBloc == null) {
      _filteredProductsBloc = Provider.of<FilteredProductsBloc>(context);
    }

    if (_cartBloc == null) {
      _cartBloc = Provider.of<CartBloc>(context);
    }

    _cartBloc.dispatch(FetchCart());

    return SafeArea(
        child: new Column(children: <Widget>[
      Expanded(
        child: new Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: _buildAppBar(),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: new BlocBuilder(
              bloc: _cartBloc,
              builder: (context, CartState state) {
                return new Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.grey[200],
                        child: _buildProductsList(
                            state is CartLoaded ? state.cart.products : []),
                      ),
                    ),
                    state is CartLoaded && state.cart.products.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(CartPage.routeName);
                            },
                        child: CartBottomBar(state.cart.count))
                        : Container(),
                    new Container(
                      child: isShownController.stream.value !=
                              FilterTabState.HIDDEN
                          ? Container()
                          : FilterSortHeader(() {
                              isShownController.add(FilterTabState.SORT);
                            }, () {
                              isShownController.add(FilterTabState.HIDDEN);
                            }, isShownController),
                      height: 56,
                    )
                  ],
                );
              },
            ),
          ),
/*
          drawer: CategoriesDrawer(() {}),
*/
        ),
      ),
    ]));
  }

  @override
  void initState() {
    super.initState();
    isShownController.sink.add(FilterTabState.HIDDEN);

    isShownController.stream.listen((FilterTabState state) {
      switch (state) {
        case FilterTabState.SORT:
          setState(() {
            _controller =
                _scaffoldKey.currentState.showBottomSheet((_) => Container(
                      height: 500,
                      child: FilterSortArea(isShownController),
                    ));
          });

          _controller.closed.then((value) {
            setState(() {
              isShownController.add(FilterTabState.HIDDEN);
            });
          });

          break;
        case FilterTabState.HIDDEN:
          setState(() {
            if (_controller != null) _controller.close();
          });
          break;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  CustomAppBar _buildAppBar() {
    String identifier = '';

    try {
      identifier =
          (_productsBloc.currentState as ProductsLoaded).identifier.name;
    } catch (e, stk) {
      print(e);
      print(stk);
    }

    return new CustomAppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      titleText: 'محصولات ' + identifier,
    );
  }

  Widget _buildProductsList(List<CartProduct> cartProducts) {
    return BlocBuilder(
        bloc: _filteredProductsBloc,
        builder: (context, FilteredProductsState state) {
          if (state is FilteredProductsLoaded) {
            if (state.filteredProducts.isEmpty) {
              return Container(
                padding: EdgeInsets.only(bottom: 56),
                color: Colors.grey[50],
                child: Text(
                  "کالایی در این دسته موجود نمی باشد!",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                alignment: Alignment.center,
              );
            } else {
              /* List<ExtendedProduct> extendedProducts = [];

              state.filteredProducts.forEach((product) {
                if (extendedProducts.map((ep) => ep.id).contains(product.id)) {
                  extendedProducts
                      .firstWhere((ep) => ep.id == product.id)
                      .addProduct(product);
                } else {
                  extendedProducts.add(ExtendedProduct([product], product.id));
                }

                */ /* extendedProducts.forEach((ep) {
                  if (ep.id == product.id) {
                    ep.addProduct(product);
                  }
                });

                if (extendedProducts.isEmpty) {
                  extendedProducts.add(ExtendedProduct([product], product.id));
                }*/ /*
              });*/

/*
              List<ExtendedProduct> extendedProducts =  ;
*/

              return ListView(
                children: state.filteredProducts.map((p) {
                  int count = 0;

                  CartProduct cartProduct;

                  if (cartProducts.map((cp) => cp.product.id).contains(p.id)) {
                    cartProduct =
                        cartProducts.where((cp) => cp.product.id == p.id).first;
                    count = cartProduct.count;
                  }
                  return new ProductListItem(p, count);
                }).toList(),
              );
            }
          } else if (state is LoadingFilteredProducts) {
            return LoadingIndicator();
          } else if (state is FilteredProductsFailure) {}
          return Text("خطا!");
        });
  }

  List<Product> _onePriceProducts(List<Product> products) {
    List<Product> result = [];

    products.forEach((product) {
      print("results" + result.toString());
      Product foundProduct;

      if (result.map((r) => r.id).contains(product.id)) {
        foundProduct = result.firstWhere((p) => p.id == product.id);
      }

      if (foundProduct == null) {
        result.add(product);
      } else if (foundProduct.price.compareTo(product.price) > 0) {
        result.remove(foundProduct);
        result.add(product);
      }
    });

    return result;
  }

  @override
  void dispose() {
    isShownController.close();
/*
    animController.dispose();
*/
    super.dispose();
  }
}

class CartBottomBar extends StatelessWidget {
  final int count;

  CartBottomBar(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppColors.main_color,
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            child: Center(
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "مشاهده سبد خرید",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          Container(
            width: 60,
            margin: EdgeInsets.only(left: 20),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45),
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                      color: AppColors.main_color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//class EntryItem extends StatelessWidget {
//  const EntryItem(
//    this.entry,
//    this.context,
//    this.hideDrawer,
//  );
//
//  final VoidCallback hideDrawer;
//  final BuildContext context;
//  final StructPet entry;
//
//  Widget _buildTiles(StructPet pet) {
//    if (pet.categories.isEmpty) return ListTile(title: Text(pet.nameFA));
//    return ExpansionTile(
//      backgroundColor: Colors.white,
//      key: PageStorageKey<StructPet>(pet),
//      title: FlatButton(
//          onPressed: () {
//            Provider.of<ProductsBloc>(context).dispatch(LoadProducts(pet));
//            hideDrawer();
//          },
//          child: Text(
//            pet.nameFA,
//            style: TextStyle(fontSize: 13),
//          )),
//      children: pet.categories
//          .map((cat) => ListTile(
//                onTap: () {
//                  Provider.of<ProductsBloc>(context)
//                      .dispatch(LoadProducts(cat));
//                  hideDrawer();
//                },
//                title: Text(cat.nameFA, style: TextStyle(fontSize: 12)),
//              ))
//          .toList(),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return _buildTiles(entry);
//  }
//}

/*
class CategoriesDrawer extends StatelessWidget {
  CategoriesDrawer(this.hideDrawer);

  final VoidCallback hideDrawer;

  @override
  Widget build(BuildContext context) {
    Provider.of<StructureBloc>(context).dispatch(FetchStructure());

    return Container(
      width: 280,
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            color: AppColors.main_color,
            child: Center(
              child: Text(
                "دسته بندی محصولات",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
          BlocBuilder(
            bloc: Provider.of<StructureBloc>(context),
            builder: (context, StructureState state) {
              if (state is LoadingStructure) {
                return Container(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(
                    child: LoadingIndicator(),
                  ),
                );
              } else if (state is LoadedStructure) {
                return Container(
                  height: 400,
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) =>
                        EntryItem(state.pets[index], context, () {
                      Navigator.of(context).pop();
                    }),
                    itemCount: state.pets.length,
                  ),
                );
              } else {
                return Center(
                  child: Text("خطا!"),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
*/
