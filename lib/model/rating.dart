class Rating {
  final String rate; // String to represent the enum
  final String comment;
  final String? ratingImage;
  final DateTime dateIssued;
  final String username;

  Rating({
    required this.rate,
    required this.comment,
    this.ratingImage,
    required this.dateIssued,
    required this.username,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['Rate'],
      comment: json['Comment'],
      ratingImage: json['RatingImage'],
      dateIssued: DateTime.parse(json['DateIssued']),
      username: json['username'],
    );
  }

  // Convert string enum to integer for calculation
  int get rateAsInt {
    switch (rate) {
      case '1':
        return 1;
      case '2':
        return 2;
      case '3':
        return 3;
      case '4':
        return 4;
      case '5':
        return 5;
      default:
        return 0; // Default or handle unknown rate
    }
  }
}
