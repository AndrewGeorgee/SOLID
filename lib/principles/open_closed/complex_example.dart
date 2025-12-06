import '../../models/product.dart';
import '../../models/order.dart';

/// COMPLEX REAL-WORLD EXAMPLE: Advanced Pricing System
/// 
/// Demonstrates Open/Closed Principle with complex pricing strategies,
/// discount rules, tax calculations, and shipping options.

// ============================================================================
// DISCOUNT STRATEGIES - Open for extension, closed for modification
// ============================================================================

abstract class IDiscountStrategy {
  String getDiscountName();
  double calculateDiscount(double originalPrice, DiscountContext context);
  bool isApplicable(DiscountContext context);
  int getPriority(); // Higher priority discounts are applied first
}

class DiscountContext {
  final Product product;
  final String? userId;
  final DateTime purchaseDate;
  final int quantity;
  final double cartTotal;
  final Map<String, dynamic> metadata;

  DiscountContext({
    required this.product,
    this.userId,
    required this.purchaseDate,
    this.quantity = 1,
    this.cartTotal = 0.0,
    this.metadata = const {},
  });
}

/// Base discount strategy with common functionality
abstract class BaseDiscountStrategy implements IDiscountStrategy {
  final double discountPercent;

  BaseDiscountStrategy({required this.discountPercent});

  @override
  double calculateDiscount(double originalPrice, DiscountContext context) {
    if (!isApplicable(context)) return 0.0;
    return originalPrice * (discountPercent / 100);
  }

  @override
  int getPriority() => 1; // Default priority
}

/// Student discount - 15% off
class StudentDiscountStrategy extends BaseDiscountStrategy {
  StudentDiscountStrategy() : super(discountPercent: 15.0);

  @override
  String getDiscountName() => 'Student Discount';

  @override
  bool isApplicable(DiscountContext context) {
    return context.metadata['isStudent'] == true;
  }
}

/// Senior discount - 20% off
class SeniorDiscountStrategy extends BaseDiscountStrategy {
  SeniorDiscountStrategy() : super(discountPercent: 20.0);

  @override
  String getDiscountName() => 'Senior Discount';

  @override
  bool isApplicable(DiscountContext context) {
    final age = context.metadata['age'] as int?;
    return age != null && age >= 65;
  }
}

/// VIP discount - 25% off
class VipDiscountStrategy extends BaseDiscountStrategy {
  VipDiscountStrategy() : super(discountPercent: 25.0);

  @override
  String getDiscountName() => 'VIP Discount';

  @override
  bool isApplicable(DiscountContext context) {
    return context.metadata['isVip'] == true;
  }

  @override
  int getPriority() => 2; // Higher priority
}

/// Bulk discount - based on quantity
class BulkDiscountStrategy implements IDiscountStrategy {
  final int minQuantity;
  final double discountPercent;

  BulkDiscountStrategy({
    required this.minQuantity,
    required this.discountPercent,
  });

  @override
  String getDiscountName() => 'Bulk Discount';

  @override
  double calculateDiscount(double originalPrice, DiscountContext context) {
    if (!isApplicable(context)) return 0.0;
    return originalPrice * (discountPercent / 100);
  }

  @override
  bool isApplicable(DiscountContext context) {
    return context.quantity >= minQuantity;
  }

  @override
  int getPriority() => 1;
}

/// Seasonal discount - time-based
class SeasonalDiscountStrategy implements IDiscountStrategy {
  final DateTime startDate;
  final DateTime endDate;
  final double discountPercent;
  final String seasonName;

  SeasonalDiscountStrategy({
    required this.startDate,
    required this.endDate,
    required this.discountPercent,
    required this.seasonName,
  });

  @override
  String getDiscountName() => '$seasonName Discount';

  @override
  double calculateDiscount(double originalPrice, DiscountContext context) {
    if (!isApplicable(context)) return 0.0;
    return originalPrice * (discountPercent / 100);
  }

  @override
  bool isApplicable(DiscountContext context) {
    return context.purchaseDate.isAfter(startDate) &&
        context.purchaseDate.isBefore(endDate);
  }

  @override
  int getPriority() => 1;
}

/// Cart total discount - based on cart value
class CartTotalDiscountStrategy implements IDiscountStrategy {
  final double minCartTotal;
  final double discountPercent;

  CartTotalDiscountStrategy({
    required this.minCartTotal,
    required this.discountPercent,
  });

  @override
  String getDiscountName() => 'Cart Total Discount';

  @override
  double calculateDiscount(double originalPrice, DiscountContext context) {
    if (!isApplicable(context)) return 0.0;
    return originalPrice * (discountPercent / 100);
  }

  @override
  bool isApplicable(DiscountContext context) {
    return context.cartTotal >= minCartTotal;
  }

  @override
  int getPriority() => 1;
}

/// Composite discount - combines multiple discounts
class CompositeDiscountStrategy implements IDiscountStrategy {
  final List<IDiscountStrategy> strategies;

  CompositeDiscountStrategy(this.strategies);

  @override
  String getDiscountName() => 'Composite Discount';

  @override
  double calculateDiscount(double originalPrice, DiscountContext context) {
    double totalDiscount = 0.0;
    double currentPrice = originalPrice;

    // Sort by priority (higher first)
    final sortedStrategies = List<IDiscountStrategy>.from(strategies)
      ..sort((a, b) => b.getPriority().compareTo(a.getPriority()));

    for (final strategy in sortedStrategies) {
      if (strategy.isApplicable(context)) {
        final discount = strategy.calculateDiscount(currentPrice, context);
        totalDiscount += discount;
        currentPrice -= discount;
      }
    }

    return totalDiscount;
  }

  @override
  bool isApplicable(DiscountContext context) {
    return strategies.any((s) => s.isApplicable(context));
  }

  @override
  int getPriority() => 3; // Highest priority
}

// ============================================================================
// TAX CALCULATORS - Open for extension
// ============================================================================

abstract class ITaxCalculator {
  double calculateTax(double amount, TaxContext context);
  String getTaxName();
}

class TaxContext {
  final String region;
  final String? country;
  final ProductCategory? productCategory;
  final Map<String, dynamic> metadata;

  TaxContext({
    required this.region,
    this.country,
    this.productCategory,
    this.metadata = const {},
  });
}

enum ProductCategory { food, electronics, clothing, books, other }

/// Standard tax calculator
class StandardTaxCalculator implements ITaxCalculator {
  final double taxRate;

  StandardTaxCalculator({required this.taxRate});

  @override
  String getTaxName() => 'Standard Tax';

  @override
  double calculateTax(double amount, TaxContext context) {
    return amount * taxRate;
  }
}

/// Regional tax calculator with different rates per region
class RegionalTaxCalculator implements ITaxCalculator {
  final Map<String, double> regionRates;

  RegionalTaxCalculator({required this.regionRates});

  @override
  String getTaxName() => 'Regional Tax';

  @override
  double calculateTax(double amount, TaxContext context) {
    final rate = regionRates[context.region] ?? 0.0;
    return amount * rate;
  }
}

/// Category-based tax calculator
class CategoryTaxCalculator implements ITaxCalculator {
  final Map<ProductCategory, double> categoryRates;
  final double defaultRate;

  CategoryTaxCalculator({
    required this.categoryRates,
    this.defaultRate = 0.08,
  });

  @override
  String getTaxName() => 'Category Tax';

  @override
  double calculateTax(double amount, TaxContext context) {
    final category = context.productCategory ?? ProductCategory.other;
    final rate = categoryRates[category] ?? defaultRate;
    return amount * rate;
  }
}

/// Progressive tax calculator (higher amounts = higher rate)
class ProgressiveTaxCalculator implements ITaxCalculator {
  final List<TaxBracket> brackets;

  ProgressiveTaxCalculator({required this.brackets});

  @override
  String getTaxName() => 'Progressive Tax';

  @override
  double calculateTax(double amount, TaxContext context) {
    double totalTax = 0.0;
    double remainingAmount = amount;

    for (final bracket in brackets) {
      if (remainingAmount <= 0) break;

      final taxableInBracket = remainingAmount > bracket.maxAmount
          ? bracket.maxAmount - bracket.minAmount
          : remainingAmount - bracket.minAmount;

      if (taxableInBracket > 0) {
        totalTax += taxableInBracket * bracket.rate;
        remainingAmount -= taxableInBracket;
      }
    }

    return totalTax;
  }
}

class TaxBracket {
  final double minAmount;
  final double maxAmount;
  final double rate;

  TaxBracket({
    required this.minAmount,
    required this.maxAmount,
    required this.rate,
  });
}

// ============================================================================
// SHIPPING CALCULATORS - Open for extension
// ============================================================================

abstract class IShippingCalculator {
  double calculateShipping(ShippingContext context);
  String getShippingMethod();
  Duration getEstimatedDelivery();
}

class ShippingContext {
  final double orderWeight;
  final double orderValue;
  final ShippingAddress destination;
  final DateTime orderDate;
  final ShippingPriority priority;

  ShippingContext({
    required this.orderWeight,
    required this.orderValue,
    required this.destination,
    required this.orderDate,
    this.priority = ShippingPriority.standard,
  });
}

enum ShippingPriority { standard, express, overnight }

/// Standard shipping calculator
class StandardShippingCalculator implements IShippingCalculator {
  final double baseRate;
  final double perKgRate;

  StandardShippingCalculator({
    this.baseRate = 5.0,
    this.perKgRate = 2.0,
  });

  @override
  String getShippingMethod() => 'Standard Shipping';

  @override
  Duration getEstimatedDelivery() => const Duration(days: 5);

  @override
  double calculateShipping(ShippingContext context) {
    double cost = baseRate;
    cost += context.orderWeight * perKgRate;

    // Free shipping over $100
    if (context.orderValue >= 100) {
      cost = 0.0;
    }

    return cost;
  }
}

/// Express shipping calculator
class ExpressShippingCalculator implements IShippingCalculator {
  final double baseRate;
  final double perKgRate;

  ExpressShippingCalculator({
    this.baseRate = 15.0,
    this.perKgRate = 5.0,
  });

  @override
  String getShippingMethod() => 'Express Shipping';

  @override
  Duration getEstimatedDelivery() => const Duration(days: 2);

  @override
  double calculateShipping(ShippingContext context) {
    return baseRate + (context.orderWeight * perKgRate);
  }
}

/// International shipping calculator
class InternationalShippingCalculator implements IShippingCalculator {
  final Map<String, double> countryRates;
  final double baseRate;

  InternationalShippingCalculator({
    required this.countryRates,
    this.baseRate = 25.0,
  });

  @override
  String getShippingMethod() => 'International Shipping';

  @override
  Duration getEstimatedDelivery() => const Duration(days: 10);

  @override
  double calculateShipping(ShippingContext context) {
    final countryRate = countryRates[context.destination.country] ?? 1.0;
    return baseRate * countryRate;
  }
}

// ============================================================================
// PRICE CALCULATOR - Closed for modification, open for extension
// ============================================================================

class AdvancedPriceCalculator {
  final List<IDiscountStrategy> discountStrategies;
  final ITaxCalculator taxCalculator;
  final IShippingCalculator shippingCalculator;

  AdvancedPriceCalculator({
    required this.discountStrategies,
    required this.taxCalculator,
    required this.shippingCalculator,
  });

  PriceCalculationResult calculatePrice({
    required Product product,
    required DiscountContext discountContext,
    required TaxContext taxContext,
    required ShippingContext shippingContext,
  }) {
    double originalPrice = product.price;
    double discountAmount = 0.0;
    List<String> appliedDiscounts = [];

    // Apply all applicable discounts
    for (final strategy in discountStrategies) {
      if (strategy.isApplicable(discountContext)) {
        final discount = strategy.calculateDiscount(originalPrice, discountContext);
        if (discount > 0) {
          discountAmount += discount;
          appliedDiscounts.add(strategy.getDiscountName());
        }
      }
    }

    final priceAfterDiscount = originalPrice - discountAmount;
    final taxAmount = taxCalculator.calculateTax(priceAfterDiscount, taxContext);
    final shippingCost = shippingCalculator.calculateShipping(shippingContext);
    final finalPrice = priceAfterDiscount + taxAmount + shippingCost;

    return PriceCalculationResult(
      originalPrice: originalPrice,
      discountAmount: discountAmount,
      priceAfterDiscount: priceAfterDiscount,
      taxAmount: taxAmount,
      shippingCost: shippingCost,
      finalPrice: finalPrice,
      appliedDiscounts: appliedDiscounts,
      taxName: taxCalculator.getTaxName(),
      shippingMethod: shippingCalculator.getShippingMethod(),
    );
  }
}

class PriceCalculationResult {
  final double originalPrice;
  final double discountAmount;
  final double priceAfterDiscount;
  final double taxAmount;
  final double shippingCost;
  final double finalPrice;
  final List<String> appliedDiscounts;
  final String taxName;
  final String shippingMethod;

  PriceCalculationResult({
    required this.originalPrice,
    required this.discountAmount,
    required this.priceAfterDiscount,
    required this.taxAmount,
    required this.shippingCost,
    required this.finalPrice,
    required this.appliedDiscounts,
    required this.taxName,
    required this.shippingMethod,
  });

  @override
  String toString() {
    return '''
Price Calculation Result:
  Original Price: \$${originalPrice.toStringAsFixed(2)}
  Discounts Applied: ${appliedDiscounts.join(', ')}
  Discount Amount: \$${discountAmount.toStringAsFixed(2)}
  Price After Discount: \$${priceAfterDiscount.toStringAsFixed(2)}
  Tax ($taxName): \$${taxAmount.toStringAsFixed(2)}
  Shipping ($shippingMethod): \$${shippingCost.toStringAsFixed(2)}
  Final Price: \$${finalPrice.toStringAsFixed(2)}
''';
  }
}

