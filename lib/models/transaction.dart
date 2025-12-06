class Transaction {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String currency;
  final TransactionStatus status;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final String? referenceId;
  final String? description;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    this.currency = 'USD',
    required this.status,
    required this.timestamp,
    this.metadata = const {},
    this.referenceId,
    this.description,
  });
}

enum TransactionType {
  deposit,
  withdrawal,
  transfer,
  payment,
  refund,
  fee,
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  reversed,
}

