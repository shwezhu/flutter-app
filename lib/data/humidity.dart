class Humidity {
  Humidity(this.value, this.date);

  double value;
  DateTime date;

  factory Humidity.fromJson(Map<String, dynamic> json) {
    return Humidity(json['humidity'], DateTime.parse(json['date']));
  }
}