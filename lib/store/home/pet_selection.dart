import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store/common/constants.dart';
import 'package:store/store/home/category_page.dart';
import 'package:store/store/products/product/products_page.dart';
import 'package:store/store/structure/structure_bloc.dart';
import 'package:store/store/structure/structure_event_state.dart';

import 'home_page.dart';

class PetSelection extends StatefulWidget {
  @override
  _PetSelectionState createState() => _PetSelectionState();
}

class _PetSelectionState extends State<PetSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        padding: Spaces.listInsets,
        child: BlocBuilder(
          bloc: Provider.of<StructureBloc>(context),
          builder: (context, StructureState state) {
            if (state is LoadedStructure) {
              return SizedBox(
                width: double.infinity,
                height: 150,
                child: Row(
                  children: state.pets
                      .map(
                        (pet) => PetItem(
                        title: pet.name,
                            color: AppColors.colors[state.pets.indexOf(pet)],
                            icon: AppIcons.pets[state.pets.indexOf(pet)],
                            onTap: () {
                              /* Provider.of<ProductsBloc>(context)
                                  .dispatch(LoadProducts(pet));*/
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                      pet,
                                      () => Navigator.of(context)
                                          .popAndPushNamed(ProductsPage.routeName))));
                            }),
                      )
                      .toList(),
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}

class PetItem extends StatefulWidget {
  final String title;
  final Widget icon;
  final Color color;
  final VoidCallback onTap;

  PetItem({this.title, this.color, this.icon, this.onTap});

  @override
  _PetItemState createState() => _PetItemState();
}

class _PetItemState extends State<PetItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: Spaces.listCardInsets,
        child: Card(
          color: /*widget.color*/ Colors.grey[200],
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: widget.color, width: 1)),
            child: Column(
              children: <Widget>[
                Container(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    color: widget.color,
                    child: Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: widget.icon,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
