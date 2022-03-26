class Humidity {
  double value;
  DateTime date;

  Humidity(this.value, this.date);

  factory Humidity.fromJson(Map<String, dynamic> json) {
    return Humidity(json['humidity'], DateTime.parse(json['date']));
  }
}