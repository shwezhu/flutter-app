class Visitor {
  String name = "";
  String phone = "";
  String id = "";
  String city = "";

  Visitor(this.name, this.phone, this.id, this.city);
  // ?? returns expression on its left, except if it is null,
  // and if so, it returns right expression.
  // The .. operator is dart "cascade" operator.
  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(json["name"] ?? "", json["phone"] ?? "", json["id"] ?? "", json["city"] ?? "");
  }

  // To encode a user, pass the User object to the jsonEncode() function.
  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'id': id,
    'city': city
  };
}