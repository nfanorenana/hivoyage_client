class Ticket {
  int id;
  String ticketNumber;
  String name;
  String from;
  String to;
  String departureDatetime;
  String arrivalDatetime;
  String seat;
  String startvalidity;
  String endvalidity;
  String totalAmount;
  int customerId;
  int scheduleId;
  String dateDeparture;
  String timeDeparture;
  String dateArrival;
  String timeArrival;

  Ticket({
    this.id,
    this.ticketNumber,
    this.name,
    this.from,
    this.to,
    this.departureDatetime,
    this.arrivalDatetime,
    this.seat,
    this.startvalidity,
    this.endvalidity,
    this.totalAmount,
    this.customerId,
    this.scheduleId,
    this.dateDeparture,
    this.timeDeparture,
    this.dateArrival,
    this.timeArrival,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json["id"],
      ticketNumber: json["ticket_number"] as String,
      name: json["name"] as String,
      from: json["from"] as String,
      to: json['to'] as String,
      departureDatetime: json["departure_datetime"] as String,
      arrivalDatetime: json["arrival_datetime"] as String,
      seat: json["seat"] as String,
      startvalidity: json["startvalidity"] as String,
      endvalidity: json["endvalidity"] as String,
      totalAmount: json["total_amount"] as String,
      customerId: json["customer_id"],
      scheduleId: json["schedules_id"],
      dateDeparture: json["date_departure"] as String,
      timeDeparture: json["time_departure"] as String,
      dateArrival: json["date_arrival"] as String,
      timeArrival: json["time_arrival"] as String,
    );
  }
}
