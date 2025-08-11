enum OrderType {
  dineIn,
  takeAway,
  delivery;

  String get displayName {
    switch (this) {
      case OrderType.dineIn:
        return 'Dine In';
      case OrderType.takeAway:
        return 'Take Away';
      case OrderType.delivery:
        return 'Delivery';
    }
  }
}
