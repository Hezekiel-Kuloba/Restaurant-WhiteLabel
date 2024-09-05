class Rules {
  String? id;
  String? rule;

  Rules(
      {
      this.id,
      this.rule,
      });

  Rules.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    rule = json['rule'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['rule'] = rule;
    return data;
  }

}
