import 'package:bloc/bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/userpet/user_pet_repository.dart';
import 'package:store/store/login_register/login_status/login_status_bloc.dart';
import 'package:store/store/login_register/login_status/login_status_event_state.dart';
import 'package:store/store/userpet/user_pet_bloc_event_state.dart';

class UserPetBloc extends Bloc<UserPetEvent, UserPetState> {
  UserPetBloc(this._userPetRepository, this._loginStatusBloc);

  final LoginStatusBloc _loginStatusBloc;
  final UserPetRepository _userPetRepository;

  @override
  UserPetState get initialState => UserPetLoading();

  @override
  Stream<UserPetState> mapEventToState(UserPetEvent event) async* {
    var loginState = _loginStatusBloc.currentState;

    if (event is FetchUserPet) {
      if (loginState is IsLoggedIn) {
        yield UserPetLoading();
        print('inside fetch usr pet');
        var pet = await _userPetRepository.get(loginState.user.appUserId);
        print('before handling pet');
        print('user pet in bloc:' + pet.toString());

        if (pet is UninitiatedPet) {
          yield UserPetNotSet();
        } else {
          yield UserPetLoaded(pet);
        }
      }
    } else if (event is SetUserPet) {
      yield UserPetLoading();
      if (loginState is IsLoggedIn) {
        yield UserPetLoading();
        var pet = await _userPetRepository.get(loginState.user.appUserId);
        var updatedPet = UserPet(
            event.id,
            loginState.user.appUserId,
            event.name,
            '',
            event.age,
            event.gender,
            event.typeId,
            event.sterilization);

        if (pet is UninitiatedPet) {
          var success = await _userPetRepository.send(updatedPet);
          if (success) {
            Helpers.changeSuccessfulToast();
            yield (UserPetLoaded(
                await _userPetRepository.get(loginState.user.appUserId)));
          } else {
            Helpers.showErrorToast();
            yield (UserPetNotSet());
          }
        } else {
          var success = await _userPetRepository.edit(updatedPet);
          if (success) {
            Helpers.changeSuccessfulToast();
            yield (UserPetLoaded(
                await _userPetRepository.get(loginState.user.appUserId)));
          } else {
            Helpers.showErrorToast();
            yield (UserPetLoaded(pet));
          }
        }
      }
    } else if (event is RemoveUserPet) {
      var success = await _userPetRepository.delete(event.id);
      if (success) {
        Helpers.changeSuccessfulToast('حیوان خانگی شما حذف شد');
        yield (UserPetNotSet());
      } else {
        Helpers.showErrorToast();
      }
    }
  }
}
