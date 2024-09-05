class OrderItem {
  String? stewname;
  String? solidfoodname;
  String? id;

  OrderItem({this.stewname, this.solidfoodname, this.id});

  OrderItem.fromJson(Map<String, dynamic> json) {
    stewname = json['Stew_name'];
    solidfoodname = json['solidFood_name'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Stew_name'] = stewname;
    data['solidFood_name'] = solidfoodname;
    data['_id'] = id;
    return data;
  }
}

class Orders {
  String? solidfoodname;
  String? firstName;
  String? stewname;
  String? alternativesolidfoodname;
  String? id;
  String? alternativestewname;
  String? specificinstructions;
  List<OrderItem>? items;

  Orders(
      {this.solidfoodname,
      this.stewname,
      this.firstName,
      this.alternativesolidfoodname,
      this.id,
      this.items,
      this.alternativestewname,
      this.specificinstructions});

  Orders.fromJson(Map<String, dynamic> json) {
    solidfoodname = json['solidFood_name'];
    firstName = json['firstName'];
    stewname = json['Stew_name'];
    alternativesolidfoodname = json['alternative_solidFood_name'];
    id = json['_id'];
    alternativestewname = json['alternative_stew_name'];
    specificinstructions = json['specific_instructions'];
    if (json['orders'] != null) {
      items = [];
      json['orders'].forEach((v) {
        items!.add(OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['solidFood_name'] = solidfoodname;
    data['Stew_name'] = stewname;
    data['alternative_solidFood_name'] = alternativesolidfoodname;
    data['_id'] = id;
    data['alternative_stew_name'] = alternativestewname;
    data['specific_instructions'] = specificinstructions;
    if (items != null) {
      data['orders'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
