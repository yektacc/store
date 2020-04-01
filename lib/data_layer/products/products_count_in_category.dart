import 'dart:collection';
import 'package:store/store/products/product/products_repository.dart';
import 'package:store/store/structure/model.dart';
import 'package:store/store/structure/structure_bloc.dart';
import 'package:store/store/structure/structure_event_state.dart';

class ProductsCountRepository {
  final ProductsRepository _productsRepository;
  final StructureBloc _structureBloc;

  final Map<Identifier, int> _cache = HashMap();

  ProductsCountRepository(this._productsRepository, this._structureBloc) {
    _structureBloc.dispatch(FetchStructure());

    /* _structureBloc.state.listen((state) {
      if (state is LoadedStructure) {
        state.pets.forEach((petStruct) => petStruct.categories
            .forEach((catStruct) => getCount(catStruct).listen((_) {})));
      }
    });*/
  }

  Stream<int> getCount(Identifier _identifier) async* {
    if (_cache.containsKey(_identifier)) {
      yield _cache[_identifier];
    } else {
      yield -1;
      try {
        await for (final items in _productsRepository.load(_identifier)) {
          yield items.length;
          _cache.putIfAbsent(_identifier, () => items.length);
        }
      } catch (e) {
        print("error loading products count: $e");
        yield -1;
      }
    }
  }
}
