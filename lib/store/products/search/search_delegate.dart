import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/common/loading_widget.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/products/product/products_repository.dart';
import 'package:store/store/products/search/search_bloc.dart';
import 'package:store/store/products/search/search_result_widget.dart';
import 'package:store/store/structure/model.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  ProductsRepository productRepository;
  final Identifier _identifier;
  final List<Product> products = [];

  CustomSearchDelegate(this._identifier);

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
    if (productRepository == null) {
      productRepository = Provider.of<ProductsRepository>(context);
    }

    if (query.length < 2) {
      return Center(
          child: Center(
        child: Text(
          "متن جستجو باید حداقل ۲ حرف باشد",
        ),
      ));
    }

    final bloc = Provider.of<SearchBloc>(context);
    bloc.dispatch(SearchFor(query,_identifier));

    return Center(
        child: BlocBuilder(
            bloc: bloc,
            builder: (context, state) {
              if (state is LoadingResults) {
                return Center(
                  child: Center(child: new Center(child: LoadingIndicator())),
                );
              } else if (state is NoResult) {
                return Center(
                  child: Text(
                    "نتیجه ای یافت نشد.",
                  ),
                );
              } else if (state is SearchLoaded) {
                print("RESSSSS: " + state.results.toString());
                return Container(
                  child: SearchResultWgt(state.results),
                );
              } else {
                return Container(
                  color: Colors.red,
                  width: 50,
                  height: 50,
                );
              }
            }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Container();
  }
}
