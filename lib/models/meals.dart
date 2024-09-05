class Meals {
  String? name;
  String? description;
  String? category;
  String? id;
  String? quantity;
  String? image;
  String? solidfoodname;
  String? firstName;
  String? stewname;
  String? details;

  Meals(
      {this.name,
      this.description,
      this.category,
      this.solidfoodname,
      this.stewname,
      this.firstName,
      this.id,
      this.quantity,
      this.details,
      this.image});

  Meals.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    category = json['category'];
    solidfoodname = json['solidFood_name'];
    firstName = json['firstName'];
    stewname = json['Stew_name'];
    id = json['_id'];
    quantity = json['quantity'];
    details = json['details'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['category'] = category;
    data['_id'] = id;
    data['quantity'] = quantity;
    data['image'] = image;
    data['firstName'] = firstName;
    data['solidFood_name'] = solidfoodname;
    data['Stew_name'] = stewname;
    data['details'] = details;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Meals && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
