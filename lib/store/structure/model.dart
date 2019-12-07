import 'package:equatable/equatable.dart';
import 'package:quiver/core.dart';

abstract class Identifier extends Equatable {
  int getId();

  String getName();
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

  @override
  String getName() => nameFA;

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
                StructCategory.fromJson(value, petJson["basecategory_id"]))
            .toList());
  }
}

class StructCategory extends Identifier {
  final int id;
  final String nameFA;
  final String nameEN;
  final int petId;
  final List<StructSubCategory> subCategories;

  StructCategory(
      this.id, this.nameFA, this.nameEN, this.subCategories, this.petId);

  @override
  int getId() => id;

  @override
  String getName() => nameFA;

  @override
  int get hashCode => hash3(nameFA, nameEN, id);

  @override
  bool operator ==(Object other) =>
      other is StructCategory &&
      other.id == this.id &&
      this.petId == other.petId;

  factory StructCategory.fromJson(Map<String, dynamic> json, int petId) {
    return StructCategory(
        json["subcategory_id"],
        json["subcategory_name_fa"],
        json["subcategory_name_en"],
        (json["product_types"] as List)
            .map((value) => StructSubCategory.fromJson(
                value, petId, json["subcategory_id"]))
            .toList(),
        petId);
  }
}

class StructSubCategory extends Identifier {
  final int id;
  final int petId;
  final int catId;
  final String nameFA;
  final String nameEN;

  StructSubCategory(this.id, this.nameFA, this.nameEN, this.petId, this.catId);

  @override
  int getId() => id;

  @override
  String getName() => nameFA;

  @override
  int get hashCode => hash3(nameFA, nameEN, id);

  @override
  bool operator ==(Object other) =>
      other is StructSubCategory &&
      other.id == this.id &&
      this.petId == other.petId &&
      this.catId == other.catId;

  factory StructSubCategory.fromJson(
      Map<String, dynamic> json, int petId, int catId) {
    return StructSubCategory(json["type_id"], json["type_name_fa"],
        json["type_name_en"], petId, catId);
  }
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
  String getName() {
    return "همه حیوانات";
  }
}

class AllItems extends Identifier {
  @override
  String getName() => "همه محصولات";

  @override
  int getId() {
    return 0;
  }
}
