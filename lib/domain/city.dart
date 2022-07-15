class City {
  int id;
  String cityRegistration;
  String name;
  String province;
  String latitude;
  String longitude;

  City(
      {this.id,
      this.cityRegistration,
      this.name,
      this.province,
      this.latitude,
      this.longitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json["id"],
      cityRegistration: json["city_registration"] as String,
      name: json["name"] as String,
      province: json["province"] as String,
      latitude: json["latitude"] as String,
      longitude: json["longitude"] as String,
    );
  }
}
