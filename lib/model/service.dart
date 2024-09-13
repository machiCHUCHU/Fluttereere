class Service {
  final int? serviceId;
  final String? serviceName;
  final String? description;
  final double? loadWeight;
  final double? loadPrice;
  final String? isFullService;  // Added
  final String? isSelfService;  // Added

  Service({
    this.serviceId,
    this.serviceName,
    this.description,
    this.loadWeight,
    this.loadPrice,
    this.isFullService,  // Added
    this.isSelfService,  // Added
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    print('Parsing JSON: $json');
    return Service(
      serviceId: json['ServiceID'] as int?,
      serviceName: json['ServiceName'] as String?,
      description: json['Description'] as String?,
      loadWeight: (json['LoadWeight'] as num?)?.toDouble(),
      loadPrice: (json['LoadPrice'] as num?)?.toDouble(),
      isFullService: json['IsFullService'] as String?,  // Added
      isSelfService: json['IsSelfService'] as String?,  // Added
    );
  }
}
