enum SortType { priceAsc, priceDesc, capacityAsc, capacityDesc }

extension SortTypeExt on SortType {
  String get apiValue {
    switch (this) {
      case SortType.priceAsc:
        return "price_asc";
      case SortType.priceDesc:
        return "price_desc";
      case SortType.capacityAsc:
        return "capacity_asc";
      case SortType.capacityDesc:
        return "capacity_desc";
    }
  }

  String get label {
    switch (this) {
      case SortType.priceAsc:
        return "Price";
      case SortType.priceDesc:
        return "Price";
      case SortType.capacityAsc:
        return "Capacity";
      case SortType.capacityDesc:
        return "Capacity";
    }
  }
}
