import 'package:bloc/bloc.dart';
import 'package:store/common/log/log.dart';
import 'package:store/data_layer/brands/brands_repository.dart';

import 'brands_event_state.dart';

class BrandsBloc extends Bloc<BrandsEvent, BrandsState> {
  final BrandsRepository _repository;

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
    print(stacktrace);
  }

  BrandsBloc(this._repository);

  @override
  BrandsState get initialState {
    return LoadingBrands();
  }

  @override
  Stream<BrandsState> mapEventToState(BrandsEvent event) async* {
    if (event is FetchBrands) {
      try {
        yield LoadingBrands();
        await for (final snapshot in _repository.fetch()) {
          if (snapshot.isNotEmpty) {
            yield LoadedBrands(snapshot.map((brand) => brand.nameFa).toList());
          } else {
            yield BrandsFailed();
            Nik.e("failed: brands response from repository is empty");
          }
        }
      } catch (e) {
        print("BRANDS_BLOC: failure: " + e.toString());
        yield BrandsFailed();
      }
    }
  }
}
