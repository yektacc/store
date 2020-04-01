import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/location/provinces/provinces_bloc.dart';
import 'package:store/store/location/provinces/provinces_bloc_event.dart';
import 'package:store/store/structure/structure_bloc.dart';
import 'package:store/store/structure/structure_event_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  final ProvinceBloc _provinceBloc;
  final StructureBloc _structureBloc;

  @override
  LandingState get initialState => InitialLoading();

  LandingBloc(this._provinceBloc, this._structureBloc) {
    dispatch(RetryLoading());
  }

  @override
  Stream<LandingState> mapEventToState(LandingEvent event) async* {
    if (event is RetryLoading) {
      print('retrying inital loading');
      yield InitialLoading();
      yield* syncInitialData().map((success) {
        if (success) {
          return LoadingSuccessful();
        } else {
          return LoadingFailed();
        }
      });
    }
  }

  Stream<bool> syncInitialData() {
    _provinceBloc.dispatch(FetchProvinces());
    _structureBloc.dispatch(FetchStructure());

    Future.delayed(Duration(seconds: 8), () {
      return false;
    });

    return Observable.combineLatest2(_provinceBloc.state, _structureBloc.state,
        (provinceState, structureState) {
      if (structureState is LoadedStructure &&
          provinceState is ProvincesLoaded) {
        return true;
      }
      ;
    });
  }
}

// states
class LandingState extends BlocState {}

class InitialLoading extends LandingState {}

class LoadingSuccessful extends LandingState {}

class LoadingFailed extends LandingState {}

// events
class LandingEvent extends BlocEvent {}

class RetryLoading extends LandingEvent {}
