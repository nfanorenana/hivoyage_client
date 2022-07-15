class BookingDetails {
  int id;
  String seatClass;
  String seat;
  String fareAmount;
  int bookingId;
  String name;
  int quantity;
  double price;
  String currency;

  BookingDetails({
    this.id,
    this.seatClass,
    this.seat,
    this.fareAmount,
    this.bookingId,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      id: json["id"],
      seatClass: json["seat_class"] as String,
      seat: json["seat"] as String,
      fareAmount: json["fare_amount"] as String,
      bookingId: json["booking_id"],
    );
  }

  List toList(List<BookingDetails> bookingDetails, double currencyValue) {
    List items = [];
    for (var bookingDetail in bookingDetails) {
      items.add({
        "name": "place : " + bookingDetail.seat,
        "quantity": 1,
        "price": double.parse(bookingDetail.fareAmount) * currencyValue,
        "currency": "USD",
      });
    }
    return items;
  }
}
