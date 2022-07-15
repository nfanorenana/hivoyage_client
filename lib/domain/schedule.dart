class Schedule {
  int id;
  String scheduleRegistration;
  int busId;
  int driverId;
  int routeId;
  String departure;
  String arrival;
  String scheduleDatetime;
  String estimatedArrival;
  String duration;
  String distance;
  String tarif;
  String remarks;
  String departureDate;
  String departureTime;
  String arrivalDate;
  String arrivalTime;
  String classLogo;

  Schedule({
    this.id,
    this.scheduleRegistration,
    this.busId,
    this.driverId,
    this.routeId,
    this.departure,
    this.arrival,
    this.scheduleDatetime,
    this.estimatedArrival,
    this.duration,
    this.distance,
    this.tarif,
    this.remarks,
    this.departureDate,
    this.departureTime,
    this.arrivalDate,
    this.arrivalTime,
    this.classLogo,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    String logo = '';
    (json["classLogo"] as String).endsWith('1.png')
        ? logo = "assets/images/logo/1.png"
        : logo = "assets/images/logo/2.png";
    return Schedule(
      id: json["id"],
      scheduleRegistration: json["schedule_registration"] as String,
      busId: json["bus_id"],
      driverId: json["driver_id"],
      routeId: json["route_id"],
      departure: json["departure"] as String,
      arrival: json["arrival"] as String,
      scheduleDatetime: json["schedule_datetime"] as String,
      estimatedArrival: json["estimated_arrival"] as String,
      duration: json["duration"] as String,
      distance: json["distance"] as String,
      tarif: json["tarif"],
      remarks: json["remarks"],
      departureDate: json["departure_date"] as String,
      departureTime: json["departure_time"] as String,
      arrivalDate: json["arrival_date"] as String,
      arrivalTime: json["arrival_time"] as String,
      classLogo: logo,
    );
  }
}
