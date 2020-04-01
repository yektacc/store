import 'package:bloc/bloc.dart';

import 'address_bloc_event.dart';
import 'address_repository.dart';
import 'model.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(this._addressRepository);

  final AddressRepository _addressRepository;

  @override
  AddressState get initialState => AddressesLoading();

  @override
  Stream<AddressState> mapEventToState(AddressEvent event) async* {
    if (event is FetchAddresses) {
      yield AddressesLoading();
      List<Address> addresses = await _addressRepository.getAll(event.sessionId,
          forceUpdate: event.forceUpdate);

      yield AddressesLoaded(addresses);
    } else if (event is AddAddress) {
      yield AddressesLoading();
      await _addressRepository.addAddress(event.sessionId, event.address);
      yield AddressesLoaded(
          await _addressRepository.getAll(event.sessionId, forceUpdate: true));

    } else if (event is EditAddress) {
      yield AddressesLoading();
      await _addressRepository.editAddress(event.address);
      yield AddressesLoaded(
          await _addressRepository.getAll(event.sessionId, forceUpdate: true));
    } else if (event is RemoveAddress) {
      yield AddressesLoading();
      await _addressRepository.removeAddress(event.addressId);
      yield AddressesLoaded(
          await _addressRepository.getAll(event.sessionId, forceUpdate: true));
    }
  }
}
