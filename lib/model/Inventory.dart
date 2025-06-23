class Inventory{
  String? id;
  String? itemName;
  String? category;
  String? isUse;
  String? itemQty;
  String? itemVolume;
  String? remainingVolume;
  String? volummeUse;
  String? shopID;

  Inventory({
      this.id,
      this.itemName,
      this.category,
      this.isUse,
      this.itemQty,
      this.itemVolume,
      this.remainingVolume,
      this.volummeUse,
      this.shopID
  });

  @override
  String toString() {
    return 'Inventory{id: $id, itemName: $itemName, category: $category, isUse: $isUse, itemQty: $itemQty, itemVolume: $itemVolume, remainingVolume: $remainingVolume, volummeUse: $volummeUse, shopID: $shopID}';
  }
}