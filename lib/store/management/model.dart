import 'package:quiver/core.dart';

abstract class CenterIdentifier {
  final int id;
  final int managerId;
  final String name;
  final int cityId;

  CenterIdentifier(this.id, this.managerId, this.name, this.cityId);

  @override
  toString() =>
      'id: $id  managerId (sellerId) : $managerId  name: $name cityId: $cityId';
}

class ServiceIdentifier extends CenterIdentifier {
  final bool chat;

  ServiceIdentifier(
      int id, int managerId, String centerName, int cityId, this.chat)
      : super(id, managerId, centerName, cityId);

  @override
  bool operator ==(other) {
    return other is ServiceIdentifier &&
        this.id == other.id &&
        this.managerId == other.managerId;
  }

  @override
  int get hashCode {
    return hash2(id, managerId);
  }
}

class ShopIdentifier extends CenterIdentifier {
  ShopIdentifier(int id, int managerId, String name, int cityId)
      : super(id, managerId, name, cityId);

  @override
  bool operator ==(other) {
    return other is ShopIdentifier && this.id == other.id;
  }

  @override
  int get hashCode {
    return hash2(id, 'seller_id');
  }
}

class ManagerUser {
  final String email;
  final String password;

  final List<CenterIdentifier> centerIdentifiers;

  ManagerUser(this.email, this.password, this.centerIdentifiers);

  @override
  String toString() {
    return 'mng user: $email,  $password $centerIdentifiers';
  }
}
