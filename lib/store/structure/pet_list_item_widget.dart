import 'package:flutter/material.dart';

import 'model.dart';

class PetListItem extends StatelessWidget {
  final StructPet _pet;
  final Color color;
  final VoidCallback onClick;

  PetListItem(this._pet, this.onClick, this.color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_pet.nameFA == 'محصولات سگ' || _pet.nameFA == 'محصولات گربه') {
          onClick();
        }
      },
      child: Container(
        width: (MediaQuery.of(context).size.width) / 2 - 24,
        height: 100,
        child: Card(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(_pet.nameFA),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
