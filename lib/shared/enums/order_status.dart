enum OrderStatus {
  created,
  preparing,
  ready,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.created:
        return 'Created';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
