import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

import 'model.dart';

@immutable
abstract class AddressEvent extends BlocEvent {}

@immutable
abstract class AddressState extends BlocState {}

// STATES *******************************

class AddressesLoading extends AddressState {
  AddressesLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class AddressesLoaded extends AddressState {
  final List<Address> addresses;

  AddressesLoaded(this.addresses);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class AddressLoadingFailed extends AddressState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class FetchAddresses extends AddressEvent {
  final int sessionId;
  bool forceUpdate;

  FetchAddresses(this.sessionId, {this.forceUpdate = false});

  @override
  String toString() {
    return "fetch";
  }
}

class AddAddress extends AddressEvent {
  final AddAddressItem address;
  final int sessionId;

  AddAddress(this.address, this.sessionId);
}

class EditAddress extends AddressEvent {
  final Address address;
  final int sessionId;

  EditAddress(this.address, this.sessionId);
}

class RemoveAddress extends AddressEvent {
  final int addressId;
  final int sessionId;

  RemoveAddress(this.addressId, this.sessionId);
}
/*
class Clear extends AddressEvent {
  Clear();
}*/
