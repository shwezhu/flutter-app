class Temperature {
  Temperature(this.value, this.date);

  double value;
  DateTime date;

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(json['temperature'], DateTime.parse(json['date']));
  }
}