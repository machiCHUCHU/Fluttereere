class Booking {
  final int bookingId;
  final double customerLoad;
  final String status;
  final String paymentStatus;
  final int shopId;
  String? shopName;

  Booking({
    required this.bookingId,
    required this.customerLoad,
    required this.status,
    required this.paymentStatus,
    required this.shopId,
    this.shopName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['BookingID'],
      customerLoad: (json['CustomerLoad'] is int)
          ? (json['CustomerLoad'] as int).toDouble()
          : json['CustomerLoad'] as double,
      status: json['Status'],
      paymentStatus: json['PaymentStatus'],
      shopId: json['ShopID'],
      shopName: json['ShopName'],
    );
  }
}
