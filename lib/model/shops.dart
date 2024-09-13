class Shop {
  final int? id;
  final String? shopName;
  final String? shopAddress;
  final int? maxLoad;
  final String? workDay;
  final String? workHour;
  final String? shopStatus;
  final String? shopCode;
  final int? shopServiceId;
  final int? shopMachineId;
  final int? ownerId;

  Shop({
    this.id,
    this.shopName,
    this.shopAddress,
    this.maxLoad,
    this.workDay,
    this.workHour,
    this.shopStatus,
    this.shopCode,
    this.shopServiceId,
    this.shopMachineId,
    this.ownerId,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    print('Parsing JSON: $json');
    return Shop(
      id: json['ShopID'] as int?,
      shopName: json['ShopName'] as String?,
      shopAddress: json['ShopAddress'] as String?,
      maxLoad: json['MaxLoad'] as int?,
      workDay: json['WorkDay'] as String?,
      workHour: json['WorkHour'] as String?,
      shopStatus: json['ShopStatus'] as String?,
      shopCode: json['ShopCode'] as String?,
      shopServiceId: json['ShopServiceID'] as int?,
      shopMachineId: json['ShopMachineID'] as int?,
      ownerId: json['OwnerID'] as int?,
    );
  }
}
