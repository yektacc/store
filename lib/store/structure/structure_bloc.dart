import 'package:bloc/bloc.dart';
import 'package:store/common/log/log.dart';
import 'package:store/store/structure/repository.dart';
import 'package:store/store/structure/structure_event_state.dart';

class StructureBloc extends Bloc<StructureEvent, StructureState> {
  final StructureRepository _repository;

  @override
  void onEvent(StructureEvent event) {
    print("STRUCTURE_BLOC: new event: $event");
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
    print(stacktrace);
  }

  StructureBloc(this._repository);

  @override
  StructureState get initialState {
    return LoadingStructure();
  }

  @override
  Stream<StructureState> mapEventToState(StructureEvent event) async* {
    if (event is FetchStructure) {
      try {
        yield LoadingStructure();
        var snapshot = await _repository.fetchAsync();
        if (snapshot.isNotEmpty) {
          yield LoadedStructure(snapshot);
        } else {
          yield FailureStructure();
          Nik.e("failed: structure response from repository is empty");
        }
      } catch (e, stacktrace) {
        print("STRUCTURE_BLOC: failure: " + e.toString());
        print(stacktrace);
        yield FailureStructure();
      }
    }
  }
}
