enum PaymentMethod {
  cash,
  card,
  credit,
  upi,
  paytm,
  others;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.credit:
        return 'Credit';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.paytm:
        return 'Paytm';
      case PaymentMethod.others:
        return 'Others';
    }
  }

  String get value {
    return name;
  }

  String get iconPath {
    switch (this) {
      case PaymentMethod.cash:
        return 'assets/icons/cash.png';
      case PaymentMethod.card:
        return 'assets/icons/card.png';
      case PaymentMethod.credit:
        return 'assets/icons/credit.png';
      case PaymentMethod.upi:
        return 'assets/icons/upi.png';
      case PaymentMethod.paytm:
        return 'assets/icons/paytm.png';
      case PaymentMethod.others:
        return 'assets/icons/others.png';
    }
  }

  // Helper method to get enum from string
  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.value == value,
      orElse: () => PaymentMethod.cash,
    );
  }

  // Get all payment methods as list
  static List<PaymentMethod> get allMethods => PaymentMethod.values;

  // Get commonly used payment methods (excluding others)
  static List<PaymentMethod> get commonMethods => [
    PaymentMethod.cash,
    PaymentMethod.card,
    PaymentMethod.credit,
    PaymentMethod.upi,
    PaymentMethod.paytm,
  ];
}
