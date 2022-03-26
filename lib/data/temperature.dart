class Temperature {
  double value;
  DateTime date;

  Temperature(this.value, this.date);

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(json['temperature'], DateTime.parse(json['date']));
  }
}