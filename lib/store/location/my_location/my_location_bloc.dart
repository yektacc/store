import 'package:bloc/bloc.dart';

import 'model.dart';
import 'my_location_bloc_event.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  MyLocationBloc();

  Location _location;

  @override
  MyLocationState get initialState => MyLocationLoading();

  @override
  Stream<MyLocationState> mapEventToState(MyLocationEvent event) async* {
    if (event is FetchMyLocation) {
      if (_location == null) {
        yield MyLocationUnspecified();
      } else {
        yield MyLocationLoaded(_location);
      }
    } else if (event is UpdateMyLocation) {
      _location = event.newLocation;
      yield (MyLocationLoaded(_location));
    } else if (event is RemoveMyLocation) {
      yield (MyLocationUnspecified());
    }
  }
}
