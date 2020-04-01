import 'package:equatable/equatable.dart';
import 'package:quiver/core.dart';

abstract class Identifier extends Equatable {
  Identifier();

  int getId();

  String get name;
}

class NAIdentifier extends Identifier {
  @override
  int getId() => -1;

  NAIdentifier();

  @override
  String get name => '';
}

class StructPet extends Identifier {
  final String nameFA;
  final String nameEN;
  final int id;
  final List<StructCategory> categories;

  @override
  int get hashCode => hash3(nameFA, nameEN, id);

  @override
  bool operator ==(Object other) => other is StructPet && other.id == this.id;

  @override
  int getId() => id;

  StructPet(this.nameFA, this.nameEN, this.id, this.categories);

  @override
  String toString() => nameFA + nameEN;

  factory StructPet.fromJson(Map<String, dynamic> petJson) {
    return StructPet(
        petJson["basecategory_name_fa"],
        petJson["basecategory_name_en"],
        petJson["basecategory_id"],
        (petJson["subcategories"] as List)
            .map((value) =>
            StructCategory.fromJson(value,
                petJson["basecategory_id"], petJson["basecategory_name_fa"]))
            .toList());
  }

  @override
  String get name => nameFA;
}

class StructCategory extends Identifier {
  final int id;
  final String nameFA;
  final String nameEN;
  final int petId;
  final String petName;
  final List<StructSubCategory> subCategories;

  StructCategory(this.id, this.nameFA, this.nameEN, this.subCategories,
      this.petId, this.petName);

  @override
  int getId() => id;

  @override
  int get hashCode => hash3(nameFA, nameEN, id);

  @override
  bool operator ==(Object other) =>
      other is StructCategory &&
      other.id == this.id &&
      this.petId == other.petId;

  factory StructCategory.fromJson(Map<String, dynamic> json,
      int petId,
      String petName,) {
    return StructCategory(
        json["subcategory_id"],
        json["subcategory_name_fa"],
        json["subcategory_name_en"],
        (json["product_types"] as List)
            .map((value) =>
            StructSubCategory.fromJson(value, petId,
                json["subcategory_id"], petName, json["subcategory_name_fa"]))
            .toList(),
        petId,
        petName);
  }

  @override
  // TODO: implement name
  String get name => '$petName $nameFA';
}

class StructSubCategory extends Identifier {
  final int id;
  final int petId;
  final int catId;
  final String petName;
  final String catName;
  final String nameFA;
  final String nameEN;

  StructSubCategory(this.id, this.nameFA, this.nameEN, this.petId, this.catId,
      this.petName, this.catName);

  @override
  int getId() => id;

  @override
  int get hashCode => hash3(nameFA, nameEN, id);

  @override
  bool operator ==(Object other) =>
      other is StructSubCategory &&
      other.id == this.id &&
      this.petId == other.petId &&
      this.catId == other.catId;

  factory StructSubCategory.fromJson(Map<String, dynamic> json, int petId,
      int catId, String petName, String catName) {
    return StructSubCategory(json["type_id"], json["type_name_fa"],
        json["type_name_en"],
        petId,
        catId,
        petName,
        catName);
  }

  @override
  String get name => '$petName $catName $nameFA';
}

class CategoryItem {
  CategoryItem({
    this.category,
    this.isExpanded = false,
  });

  StructCategory category;
  bool isExpanded;
}

class AllPets extends Identifier {
  final List<StructPet> pets;
  final id = 0;

  AllPets(this.pets);

  @override
  int getId() {
    return id;
  }

  @override
  // TODO: implement name
  String get name => "همه حیوانات";
}

class AllItems extends Identifier {
  @override
  int getId() {
    return 0;
  }

  @override
  String get name => "همه محصولات";
}
