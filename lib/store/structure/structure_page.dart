import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:store/common/constants.dart';

import 'model.dart';

class StructureMenu extends StatefulWidget {
  final List<StructPet> pets;

  StructureMenu(this.pets);

  @override
  _StructureMenuState createState() => _StructureMenuState();
}

class _StructureMenuState extends State<StructureMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            PetItemWgt(widget.pets[index], index),
        itemCount: widget.pets.length,
      ),
    );
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

/*
final List<Entry> data = <Entry>[
  Entry(
    'Chapter A',
    <Entry>[
      Entry(
        'Section A0',
        <Entry>[
          Entry('Item A0.1'),
          Entry('Item A0.2'),
          Entry('Item A0.3'),
        ],
      ),
      Entry('Section A1'),
      Entry('Section A2'),
    ],
  ),
  Entry(
    'Chapter B',
    <Entry>[
      Entry('Section B0'),
      Entry('Section B1'),
    ],
  ),
  Entry(
    'Chapter C',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry(
        'Section C2',
        <Entry>[
          Entry('Item C2.0'),
          Entry('Item C2.1'),
          Entry('Item C2.2'),
          Entry('Item C2.3'),
        ],
      ),
    ],
  ),
];
*/

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class PetItemWgt extends StatelessWidget {
  const PetItemWgt(this.pet, this.index);

  final StructPet pet;
  final int index;

  Widget _buildTiles(StructPet pet, BuildContext context) {
    if (pet.categories.isEmpty) return ListTile(title: Text(pet.nameFA));
    return ExpansionTile(
      key: PageStorageKey<StructPet>(pet),
      leading: Container(
        child: AppIcons.pets[index],
        width: 26,
        height: 26,
      ),
      backgroundColor: Colors.grey[100],
      title: Text(
        pet.nameFA,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
            fontSize: 15),
      ),
      children: pet.categories.map((c) => _buildChildren(c, context)).toList(),
    );
  }

  Widget _buildChildren(StructCategory category, BuildContext context) {
    return ListTile(
      leading: Text(category.nameFA),
      onTap: () {
        /*Provider.of<FilteredProductsBloc>(context).dispatch(Updat
            eFilter([]));
        Navigator.of(context).push(AppRoutes.productsPage(context, category));*/
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(pet, context);
  }
}
