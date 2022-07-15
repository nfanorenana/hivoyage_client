class QrTicket {
  int id;
  String ticketNumber;
  String customerName;
  String bookingRegistration;
  int seatNumber;
  String purchaseDate;
  String bookingDate;
  String startvalidity;
  String endvalidity;
  String departure;
  String departureCity;
  String arrival;
  String arrivalCity;
  String departureDate;
  String arrivalDate;
  int unitNumber;
  String seat;
  String seatClass;
  String totalAmount;
  String dateDeparture;
  String timeDeparture;
  String dateArrival;
  String timeArrival;

  QrTicket({
    this.id,
    this.ticketNumber,
    this.customerName,
    this.bookingRegistration,
    this.seatNumber,
    this.purchaseDate,
    this.bookingDate,
    this.startvalidity,
    this.endvalidity,
    this.departure,
    this.departureCity,
    this.arrival,
    this.arrivalCity,
    this.departureDate,
    this.arrivalDate,
    this.unitNumber,
    this.seat,
    this.seatClass,
    this.totalAmount,
    this.dateDeparture,
    this.timeDeparture,
    this.dateArrival,
    this.timeArrival,
  });

  factory QrTicket.fromJson(Map<String, dynamic> json) {
    return QrTicket(
      id: json["id"],
      ticketNumber: json["ticket_number"] as String,
      customerName: json["customer_name"] as String,
      bookingRegistration: json["booking_registration"] as String,
      seatNumber: json["seat_number"],
      purchaseDate: json["purchase_date"] as String,
      bookingDate: json["booking_date"] as String,
      startvalidity: json["startvalidity"] as String,
      endvalidity: json["endvalidity"] as String,
      departure: json["departure"] as String,
      departureCity: json["departure_city"] as String,
      arrival: json['arrival'] as String,
      arrivalCity: json["arrival_city"] as String,
      departureDate: json["departure_date"] as String,
      arrivalDate: json["arrival_date"] as String,
      unitNumber: json["unit_number"],
      seat: json["seat"] as String,
      seatClass: json["seat_class"] as String,
      totalAmount: json["total_amount"] as String,
      dateDeparture: json["date_departure"] as String,
      timeDeparture: json["time_departure"] as String,
      dateArrival: json["date_arrival"] as String,
      timeArrival: json["time_arrival"] as String,
    );
  }
}
