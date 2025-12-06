class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final PaymentInfo? paymentInfo;
  final ShippingAddress shippingAddress;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.status,
    required this.createdAt,
    this.paymentInfo,
    required this.shippingAddress,
  });
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

class PaymentInfo {
  final String paymentMethod;
  final String transactionId;
  final DateTime processedAt;
  final double amount;

  PaymentInfo({
    required this.paymentMethod,
    required this.transactionId,
    required this.processedAt,
    required this.amount,
  });
}

class ShippingAddress {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  ShippingAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });
}

