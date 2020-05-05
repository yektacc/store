import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/data_layer/products/products_count_in_category.dart';
import 'package:store/store/products/product/products_bloc.dart';
import 'package:store/store/products/product/products_bloc_event.dart';
import 'package:store/store/structure/model.dart';

class CategoryPage extends StatefulWidget {
  final Identifier _initialIdentifier;
  final VoidCallback goToNextPage;
  final bool onlyId;
  dynamic nextPageArgs;
  final bool altColor;

  CategoryPage(this._initialIdentifier, this.goToNextPage,
      {this.onlyId = false, this.altColor = false});

  @override
  _CategoryPageState createState() => _CategoryPageState(_initialIdentifier);

  static void launchProducts(BuildContext context, Identifier id,
      VoidCallback goToNextPage) {
    Provider.of<ProductsBloc>(context).dispatch(LoadProducts(id));
    goToNextPage();
  }
}

class _CategoryPageState extends State<CategoryPage> {
/*
  Identifier _currentIdentifier;
*/

  final BehaviorSubject<Identifier> _currentIdentifier = BehaviorSubject();
  Identifier _categoryPage;
  Identifier _petPage;
  Identifier _allPetsPage;

  _CategoryPageState(initialIdentifier) {
    _currentIdentifier.add(initialIdentifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        altMainColor: widget.altColor,
        title: StreamBuilder<Identifier>(
          stream: _currentIdentifier,
          builder: (context, snapshot) {
            return Text(
                snapshot.data != null ? snapshot.data.name ?? '' : '');
          },
        ),
        leading: new IconButton(
          onPressed: () {
            if ((_currentIdentifier.value is StructCategory)) {
              _currentIdentifier.add(_petPage);
            } else if (_currentIdentifier.value is StructPet) {
              if (_allPetsPage != null) {
                _currentIdentifier.add(_allPetsPage);
              } else {
                Navigator.of(context).pop(false);
              }
            } else if (_currentIdentifier.value is StructSubCategory) {
              _currentIdentifier.add(_categoryPage);
            } else if (_currentIdentifier.value is AllPets) {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder<Identifier>(
        stream: _currentIdentifier,
        builder: (context, snapshot) {
          return new ListView(
              children: ListTile.divideTiles(
                  context: context,
                  color: Colors.black26,
                  tiles: (snapshot.data is AllPets
                      ? (snapshot.data as AllPets)
                      .pets
                      .map((pet) =>
                      GestureDetector(
                        onTap: () {
                          _currentIdentifier.add(pet);
                          _allPetsPage = snapshot.data;
                        },
                        child:
                        CategoryItem(pet, widget.goToNextPage),
                      ))
                      .toList()
                      : snapshot.data is StructPet
                      ? (snapshot.data as StructPet)
                      .categories
                      .map((cat) =>
                      GestureDetector(
                        onTap: () {
                          if (cat.subCategories.isEmpty) {
                            CategoryPage.launchProducts(context,
                                cat, widget.goToNextPage);
                          } else {
                            _currentIdentifier.add(cat);
                            _petPage = snapshot.data;
                          }
                          print("new cat : $cat");
                        },
                        child: CategoryItem(
                            cat, widget.goToNextPage),
                      ))
                      .toList()
                      : snapshot.data is StructCategory &&
                      (snapshot.data as StructCategory)
                          .subCategories
                          .isNotEmpty
                      ? (snapshot.data as StructCategory)
                      .subCategories
                      .map((subCat) =>
                      GestureDetector(
                        onTap: () {
                          CategoryPage.launchProducts(
                              context,
                              subCat,
                              widget.goToNextPage);
                          _categoryPage = snapshot.data;
                        },
                        child: CategoryItem(
                            subCat, widget.goToNextPage),
                      ))
                      .toList()
                      : [Container()]))
                  .toList());
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Identifier _identifier;
  final VoidCallback goToNextPage;

  CategoryItem(this._identifier, this.goToNextPage);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(_identifier.name),
      trailing: SizedBox(
        height: 43,
        width: 43,
        child: StreamBuilder(
          stream: Provider.of<ProductsCountRepository>(context)
              .getCount(_identifier),
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot == null || snapshot.data == null) {
              return Container();
            } else if (snapshot.data == -1) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () =>
                    CategoryPage.launchProducts(
                        context, _identifier, goToNextPage),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey[100]),
                    /*color: Colors.grey[100]*/
                  ),
                  child: Text(
                    snapshot.data.toString(),
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
