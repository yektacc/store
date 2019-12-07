import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store/data_layer/province/province_repository.dart';
import 'package:store/store/location/provinces/provinces_bloc_event.dart';

import 'model.dart';

class ProvinceBloc extends Bloc<ProvinceEvent, ProvinceState> {
  ProvinceBloc(this._provinceRepository) {
    dispatch(FetchProvinces());
    Timer.periodic(Duration(seconds: 10), (timer) {
      if (!(currentState is ProvincesLoaded)) {
        dispatch(FetchProvinces());
      }
    });
  }

  Future<String> getCityId(String cityName) async {
    if (currentState is ProvincesLoaded) {
      List<City> cities = await getCities();

      final City city = cities.where((c) => c.name == cityName).first;

      return city.id.toString();
    } else {
      dispatch(FetchProvinces());
      return state.listen((state) {
        if (currentState is ProvincesLoaded) {
          List<City> cities = (currentState as ProvincesLoaded)
              .provinces
              .expand((p) => p.cities)
              .toList();

          final City city = cities.where((c) => c.name == cityName).first;
          return city.id.toString();
        }
      }).asFuture();
    }
  }

  Future<List<City>> getCities() async {
    if (currentState is ProvincesLoaded) {
      List<City> cities = (currentState as ProvincesLoaded)
          .provinces
          .expand((p) => p.cities)
          .toList();

      return cities;
    } else {
      dispatch(FetchProvinces());
      state.listen((state) {
        if (state is ProvincesLoaded) {
          List<City> cities = (currentState as ProvincesLoaded)
              .provinces
              .expand((p) => p.cities)
              .toList();
          return cities;
        } else {
          dispatch(FetchProvinces());
        }
      });
    }
  }

  Future<List<Province>> getProvinces() async {
    if (currentState is ProvincesLoaded) {
      return (currentState as ProvincesLoaded).provinces;
    } else {
      dispatch(FetchProvinces());
      state.listen((state) {
        if (state is ProvincesLoaded) {
          return state.provinces;
        } else {
          dispatch(FetchProvinces());
        }
      });
    }
  }

  final ProvinceRepository _provinceRepository;

  @override
  ProvinceState get initialState => ProvincesLoading();

  @override
  Stream<ProvinceState> mapEventToState(ProvinceEvent event) async* {
    if (event is FetchProvinces) {
      yield ProvincesLoaded(await _provinceRepository.getAllAsync());
    }
  }
}
