import 'package:bloc/bloc.dart';

import 'lost_pets_event_state.dart';
import 'lost_pets_repository.dart';

class LostPetsBloc extends Bloc<LostPetsEvent, LostPetsState> {
  LostPetsBloc(this._lostPetsRepository);

  final LostPetsRepository _lostPetsRepository;

  @override
  LostPetsState get initialState => LostPetsLoading();

  @override
  Stream<LostPetsState> mapEventToState(LostPetsEvent event) async* {
    if (event is FetchLostPets) {
      yield LostPetsLoaded(await _lostPetsRepository.getPets(event.type));
    } else if (event is RegisterLostPet) {
      yield LostPetsLoading();
      await _lostPetsRepository.registerLostPet(event.lostPet,1);
    } else if(event is Reset) {
      yield LostPetsLoading();
    }
  }
}
