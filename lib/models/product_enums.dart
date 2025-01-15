enum VatCategory {
  none(0),
  five(5),
  sevenPointFive(7.5);

  final num value;
  const VatCategory(this.value);

  static VatCategory fromValue(num value) {
    return VatCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => VatCategory.none,
    );
  }

  String get display {
    switch (this) {
      case VatCategory.none:
        return 'None';
      case VatCategory.five:
        return '5%';
      case VatCategory.sevenPointFive:
        return '7.5%';
    }
  }
}

enum ProductCategory {
  Electronics,
  Clothing,
  FoodAndBeverage,
  HealthAndBeauty,
  HomeAndFurniture,
  Services,
  Software,
  Books,
  Other;

  String get display {
    switch (this) {
      case ProductCategory.Electronics:
        return 'Electronics';
      case ProductCategory.Clothing:
        return 'Clothing';
      case ProductCategory.FoodAndBeverage:
        return 'Food & Beverage';
      case ProductCategory.HealthAndBeauty:
        return 'Health & Beauty';
      case ProductCategory.HomeAndFurniture:
        return 'Home & Furniture';
      case ProductCategory.Services:
        return 'Services';
      case ProductCategory.Software:
        return 'Software';
      case ProductCategory.Books:
        return 'Books';
      case ProductCategory.Other:
        return 'Other';
    }
  }
}
