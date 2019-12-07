class PetShop {
  final String id;
  final String name;
  bool hasDiscount;
  String imgUrl;

  PetShop(this.id, this.name, {this.imgUrl, this.hasDiscount = false}) {
    imgUrl =
        "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350";
  }
}
