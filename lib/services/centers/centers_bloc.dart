import 'package:bloc/bloc.dart';

import '../../data_layer/centers/centers_repository.dart';
import 'centers_event_state.dart';

class CentersBloc extends Bloc<CentersEvent, CentersState> {
  CentersBloc(this._centersRepository);

  final CentersRepository _centersRepository;

  @override
  CentersState get initialState => CentersLoading();

  @override
  Stream<CentersState> mapEventToState(CentersEvent event) async* {
    if (event is FetchCenters) {
      yield CentersLoading();
      var centers = await _centersRepository.getCenters(event.filter);
      yield CentersLoaded(centers);
    } else if(event is Reset) {
      yield CentersLoading();
    }
  }
}
