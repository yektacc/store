import 'package:bloc/bloc.dart';

import 'adoption_event_state.dart';
import 'adoption_repository.dart';

class AdoptionPetsBloc extends Bloc<AdoptionPetsEvent, AdoptionPetsState> {
  AdoptionPetsBloc(this._adoptionPetsRepository);

  final AdoptionPetsRepository _adoptionPetsRepository;

  @override
  AdoptionPetsState get initialState => AdoptionPetsLoading();

  @override
  Stream<AdoptionPetsState> mapEventToState(AdoptionPetsEvent event) async* {
    if (event is FetchAdoptionPets) {
      yield AdoptionPetsLoaded(await _adoptionPetsRepository.getAll());
    } else if (event is RegisterAdoptionPet) {
      yield AdoptionPetsLoading();
      await _adoptionPetsRepository.registerAdoptionPet(event.adoptionPet);
    }
  }
}
