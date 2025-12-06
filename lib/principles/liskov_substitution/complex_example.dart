import '../../models/transaction.dart';

/// COMPLEX REAL-WORLD EXAMPLE: Banking System
///
/// Demonstrates Liskov Substitution Principle with complex financial
/// operations, account types, and transaction processing.

// ============================================================================
// ACCOUNT HIERARCHY - All accounts are substitutable
// ============================================================================

abstract class IAccount {
  String getAccountId();
  String getUserId();
  double getBalance();
  String getAccountType();
  AccountStatus getStatus();

  // All accounts must support these operations
  TransactionResult deposit(double amount, String description);
  TransactionResult withdraw(double amount, String description);
  TransactionResult transfer(
    IAccount toAccount,
    double amount,
    String description,
  );
  List<Transaction> getTransactionHistory({
    DateTime? startDate,
    DateTime? endDate,
  });
  bool canWithdraw(double amount);
  AccountSummary getAccountSummary();
}

enum AccountStatus { active, frozen, closed, suspended }

class TransactionResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final double newBalance;

  TransactionResult({
    required this.success,
    this.transactionId,
    this.errorMessage,
    required this.newBalance,
  });
}

class AccountSummary {
  final String accountId;
  final String accountType;
  final double balance;
  final int transactionCount;
  final DateTime lastTransactionDate;
  final AccountStatus status;

  AccountSummary({
    required this.accountId,
    required this.accountType,
    required this.balance,
    required this.transactionCount,
    required this.lastTransactionDate,
    required this.status,
  });
}

/// Base account implementation with common functionality
abstract class BaseAccount implements IAccount {
  final String accountId;
  final String userId;
  double _balance;
  AccountStatus _status;
  final List<Transaction> _transactions = [];
  final String accountType;

  BaseAccount({
    required this.accountId,
    required this.userId,
    double initialBalance = 0.0,
    this.accountType = 'Base',
  }) : _balance = initialBalance,
       _status = AccountStatus.active;

  @override
  String getAccountId() => accountId;

  @override
  String getUserId() => userId;

  @override
  double getBalance() => _balance;

  @override
  String getAccountType() => accountType;

  @override
  AccountStatus getStatus() => _status;

  @override
  TransactionResult deposit(double amount, String description) {
    if (_status != AccountStatus.active) {
      return TransactionResult(
        success: false,
        errorMessage: 'Account is not active',
        newBalance: _balance,
      );
    }

    if (amount <= 0) {
      return TransactionResult(
        success: false,
        errorMessage: 'Deposit amount must be positive',
        newBalance: _balance,
      );
    }

    _balance += amount;
    final transaction = Transaction(
      id: _generateTransactionId(),
      userId: userId,
      type: TransactionType.deposit,
      amount: amount,
      status: TransactionStatus.completed,
      timestamp: DateTime.now(),
      description: description,
    );
    _transactions.add(transaction);

    return TransactionResult(
      success: true,
      transactionId: transaction.id,
      newBalance: _balance,
    );
  }

  @override
  TransactionResult withdraw(double amount, String description) {
    if (!canWithdraw(amount)) {
      return TransactionResult(
        success: false,
        errorMessage: 'Withdrawal not allowed',
        newBalance: _balance,
      );
    }

    _balance -= amount;
    final transaction = Transaction(
      id: _generateTransactionId(),
      userId: userId,
      type: TransactionType.withdrawal,
      amount: amount,
      status: TransactionStatus.completed,
      timestamp: DateTime.now(),
      description: description,
    );
    _transactions.add(transaction);

    return TransactionResult(
      success: true,
      transactionId: transaction.id,
      newBalance: _balance,
    );
  }

  @override
  TransactionResult transfer(
    IAccount toAccount,
    double amount,
    String description,
  ) {
    if (!canWithdraw(amount)) {
      return TransactionResult(
        success: false,
        errorMessage: 'Insufficient funds or transfer not allowed',
        newBalance: _balance,
      );
    }

    final withdrawResult = withdraw(
      amount,
      'Transfer to ${toAccount.getAccountId()}: $description',
    );
    if (!withdrawResult.success) {
      return withdrawResult;
    }

    final depositResult = toAccount.deposit(
      amount,
      'Transfer from ${getAccountId()}: $description',
    );
    if (!depositResult.success) {
      // Rollback
      _balance += amount;
      return TransactionResult(
        success: false,
        errorMessage: 'Transfer failed: ${depositResult.errorMessage}',
        newBalance: _balance,
      );
    }

    return TransactionResult(
      success: true,
      transactionId: withdrawResult.transactionId,
      newBalance: _balance,
    );
  }

  @override
  List<Transaction> getTransactionHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var transactions = List<Transaction>.from(_transactions);

    if (startDate != null) {
      transactions = transactions
          .where((t) => t.timestamp.isAfter(startDate))
          .toList();
    }

    if (endDate != null) {
      transactions = transactions
          .where((t) => t.timestamp.isBefore(endDate))
          .toList();
    }

    transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return transactions;
  }

  @override
  bool canWithdraw(double amount) {
    if (_status != AccountStatus.active) return false;
    if (amount <= 0) return false;
    return _balance >= amount;
  }

  @override
  AccountSummary getAccountSummary() {
    final transactions = getTransactionHistory();
    final lastTransaction = transactions.isNotEmpty
        ? transactions.first.timestamp
        : DateTime.now();

    return AccountSummary(
      accountId: accountId,
      accountType: accountType,
      balance: _balance,
      transactionCount: transactions.length,
      lastTransactionDate: lastTransaction,
      status: _status,
    );
  }

  String _generateTransactionId() {
    return 'TXN-${DateTime.now().millisecondsSinceEpoch}-${accountId.substring(0, 4)}';
  }
}

/// Checking Account - fully substitutable for IAccount
class CheckingAccount extends BaseAccount {
  final double overdraftLimit;

  CheckingAccount({
    required super.accountId,
    required super.userId,
    super.initialBalance,
    this.overdraftLimit = 0.0,
  }) : super(accountType: 'Checking');

  @override
  bool canWithdraw(double amount) {
    if (super.getStatus() != AccountStatus.active) return false;
    if (amount <= 0) return false;
    return super.getBalance() + overdraftLimit >= amount;
  }

  @override
  TransactionResult withdraw(double amount, String description) {
    if (!canWithdraw(amount)) {
      return TransactionResult(
        success: false,
        errorMessage: 'Insufficient funds (including overdraft)',
        newBalance: super.getBalance(),
      );
    }
    return super.withdraw(amount, description);
  }
}

/// Savings Account - fully substitutable for IAccount
class SavingsAccount extends BaseAccount {
  final double minimumBalance;
  final double interestRate;

  SavingsAccount({
    required super.accountId,
    required super.userId,
    super.initialBalance,
    this.minimumBalance = 0.0,
    this.interestRate = 0.02, // 2% annual
  }) : super(accountType: 'Savings');

  @override
  bool canWithdraw(double amount) {
    if (!super.canWithdraw(amount)) return false;
    // Must maintain minimum balance
    return (super.getBalance() - amount) >= minimumBalance;
  }

  double calculateInterest(DateTime fromDate, DateTime toDate) {
    final days = toDate.difference(fromDate).inDays;
    final dailyRate = interestRate / 365;
    return super.getBalance() * dailyRate * days;
  }
}

/// Business Account - fully substitutable for IAccount
class BusinessAccount extends BaseAccount {
  final double transactionFee;
  final double monthlyFee;
  final int freeTransactionsPerMonth;
  int _transactionsThisMonth = 0;
  DateTime _lastMonthReset = DateTime.now();

  BusinessAccount({
    required super.accountId,
    required super.userId,
    super.initialBalance,
    this.transactionFee = 0.50,
    this.monthlyFee = 10.0,
    this.freeTransactionsPerMonth = 50,
  }) : super(accountType: 'Business');

  @override
  TransactionResult withdraw(double amount, String description) {
    _resetMonthlyCountersIfNeeded();
    _transactionsThisMonth++;

    final fee = _transactionsThisMonth > freeTransactionsPerMonth
        ? transactionFee
        : 0.0;
    final totalAmount = amount + fee;

    if (!super.canWithdraw(totalAmount)) {
      return TransactionResult(
        success: false,
        errorMessage: 'Insufficient funds (including fees)',
        newBalance: super.getBalance(),
      );
    }

    final result = super.withdraw(
      totalAmount,
      '$description${fee > 0 ? ' (Fee: \$$fee)' : ''}',
    );
    return result;
  }

  @override
  TransactionResult deposit(double amount, String description) {
    _resetMonthlyCountersIfNeeded();
    _transactionsThisMonth++;

    final fee = _transactionsThisMonth > freeTransactionsPerMonth
        ? transactionFee
        : 0.0;
    final netAmount = amount - fee;

    if (netAmount <= 0) {
      return TransactionResult(
        success: false,
        errorMessage: 'Deposit amount too small after fees',
        newBalance: super.getBalance(),
      );
    }

    return super.deposit(
      netAmount,
      '$description${fee > 0 ? ' (Fee: \$$fee)' : ''}',
    );
  }

  void _resetMonthlyCountersIfNeeded() {
    final now = DateTime.now();
    if (now.month != _lastMonthReset.month ||
        now.year != _lastMonthReset.year) {
      _transactionsThisMonth = 0;
      _lastMonthReset = now;
      // Apply monthly fee
      super.withdraw(monthlyFee, 'Monthly account fee');
    }
  }
}

/// Investment Account - fully substitutable for IAccount
class InvestmentAccount extends BaseAccount {
  final Map<String, double> _holdings = {}; // Symbol -> Quantity

  InvestmentAccount({
    required super.accountId,
    required super.userId,
    super.initialBalance,
  }) : super(accountType: 'Investment');

  @override
  bool canWithdraw(double amount) {
    // Can only withdraw cash, not investments
    return super.getBalance() >= amount;
  }

  void buyStock(String symbol, int quantity, double price) {
    final cost = quantity * price;
    if (super.getBalance() >= cost) {
      super.withdraw(cost, 'Buy $quantity $symbol @ \$$price');
      _holdings[symbol] = (_holdings[symbol] ?? 0) + quantity;
    }
  }

  void sellStock(String symbol, int quantity, double price) {
    final currentHolding = _holdings[symbol] ?? 0;
    if (currentHolding >= quantity) {
      final proceeds = quantity * price;
      super.deposit(proceeds, 'Sell $quantity $symbol @ \$$price');
      _holdings[symbol] = currentHolding - quantity;
      if (_holdings[symbol] == 0) {
        _holdings.remove(symbol);
      }
    }
  }

  double getPortfolioValue(Map<String, double> currentPrices) {
    double total = super.getBalance();
    _holdings.forEach((symbol, quantity) {
      final price = currentPrices[symbol] ?? 0.0;
      total += quantity * price;
    });
    return total;
  }
}

// ============================================================================
// ACCOUNT SERVICE - Works with any IAccount implementation
// ============================================================================

class AccountService {
  /// This method works with ANY IAccount implementation
  /// All account types are fully substitutable
  double getTotalBalance(List<IAccount> accounts) {
    return accounts.fold<double>(
      0.0,
      (sum, account) => sum + account.getBalance(),
    );
  }

  /// Process payment from any account type
  bool processPayment(IAccount account, double amount, String merchant) {
    final result = account.withdraw(amount, 'Payment to $merchant');
    return result.success;
  }

  /// Transfer between any account types
  bool transferFunds(IAccount fromAccount, IAccount toAccount, double amount) {
    final result = fromAccount.transfer(toAccount, amount, 'Account transfer');
    return result.success;
  }

  /// Generate consolidated report for any account types
  String generateConsolidatedReport(List<IAccount> accounts) {
    final buffer = StringBuffer();
    buffer.writeln('CONSOLIDATED ACCOUNT REPORT');
    buffer.writeln('=' * 40);
    buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
    buffer.writeln('');

    double totalBalance = 0.0;
    int totalTransactions = 0;

    for (final account in accounts) {
      final summary = account.getAccountSummary();
      totalBalance += summary.balance;
      totalTransactions += summary.transactionCount;

      buffer.writeln('Account: ${summary.accountId}');
      buffer.writeln('  Type: ${summary.accountType}');
      buffer.writeln('  Balance: \$${summary.balance.toStringAsFixed(2)}');
      buffer.writeln('  Status: ${summary.status}');
      buffer.writeln('  Transactions: ${summary.transactionCount}');
      buffer.writeln(
        '  Last Transaction: ${summary.lastTransactionDate.toIso8601String()}',
      );
      buffer.writeln('');
    }

    buffer.writeln('TOTALS:');
    buffer.writeln('  Total Balance: \$${totalBalance.toStringAsFixed(2)}');
    buffer.writeln('  Total Transactions: $totalTransactions');
    buffer.writeln('  Number of Accounts: ${accounts.length}');

    return buffer.toString();
  }

  /// Find accounts by criteria - works with any account type
  List<IAccount> findAccountsByCriteria(
    List<IAccount> accounts,
    AccountSearchCriteria criteria,
  ) {
    return accounts.where((account) {
      if (criteria.minBalance != null &&
          account.getBalance() < criteria.minBalance!) {
        return false;
      }
      if (criteria.maxBalance != null &&
          account.getBalance() > criteria.maxBalance!) {
        return false;
      }
      if (criteria.accountType != null &&
          account.getAccountType() != criteria.accountType) {
        return false;
      }
      if (criteria.status != null && account.getStatus() != criteria.status) {
        return false;
      }
      return true;
    }).toList();
  }
}

class AccountSearchCriteria {
  final double? minBalance;
  final double? maxBalance;
  final String? accountType;
  final AccountStatus? status;

  AccountSearchCriteria({
    this.minBalance,
    this.maxBalance,
    this.accountType,
    this.status,
  });
}
