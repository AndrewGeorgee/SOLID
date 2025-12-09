/// SOLUTION: Hard - Open/Closed Principle
///
/// This solution demonstrates how to apply the Open/Closed Principle using
/// multiple Strategy Patterns. New report types, filters, and export formats
/// can be added without modifying the ReportGenerator class.

/// ============================================================================
/// PART 1: Report Type Strategy (Open for extension)
/// ============================================================================

abstract class ReportStrategy {
  List<Map<String, dynamic>> process(List<Map<String, dynamic>> data);
}

class SalesReportStrategy implements ReportStrategy {
  @override
  List<Map<String, dynamic>> process(List<Map<String, dynamic>> data) {
    // Sales-specific processing
    return data
        .map(
          (item) => {
            ...item,
            'total': (item['quantity'] ?? 0) * (item['price'] ?? 0),
          },
        )
        .toList();
  }
}

class InventoryReportStrategy implements ReportStrategy {
  @override
  List<Map<String, dynamic>> process(List<Map<String, dynamic>> data) {
    // Inventory-specific processing
    return data
        .map(
          (item) => {
            ...item,
            'stock_value': (item['quantity'] ?? 0) * (item['unit_cost'] ?? 0),
          },
        )
        .toList();
  }
}

class CustomerReportStrategy implements ReportStrategy {
  @override
  List<Map<String, dynamic>> process(List<Map<String, dynamic>> data) {
    // Customer-specific processing
    return data;
  }
}

/// Fallback / default: no-op (for unknown report types)
class PassthroughReportStrategy implements ReportStrategy {
  @override
  List<Map<String, dynamic>> process(List<Map<String, dynamic>> data) => data;
}

/// ============================================================================
/// PART 2: Filter Strategy (Open for extension - Chain of Responsibility)
/// ============================================================================

abstract class DataFilter {
  List<Map<String, dynamic>> apply(List<Map<String, dynamic>> data);
}

class DateRangeFilter implements DataFilter {
  @override
  List<Map<String, dynamic>> apply(List<Map<String, dynamic>> data) {
    // Date range filtering logic
    return data;
  }
}

class StatusFilter implements DataFilter {
  @override
  List<Map<String, dynamic>> apply(List<Map<String, dynamic>> data) {
    // Status filtering logic
    return data;
  }
}

class CategoryFilter implements DataFilter {
  @override
  List<Map<String, dynamic>> apply(List<Map<String, dynamic>> data) {
    // Category filtering logic
    return data;
  }
}

/// ============================================================================
/// PART 3: Export Format Strategy (Open for extension)
/// ============================================================================

abstract class ExportStrategy {
  Map<String, dynamic> export(List<Map<String, dynamic>> data);
}

class JsonExportStrategy implements ExportStrategy {
  @override
  Map<String, dynamic> export(List<Map<String, dynamic>> data) {
    return {'format': 'json', 'data': data};
  }
}

class CsvExportStrategy implements ExportStrategy {
  @override
  Map<String, dynamic> export(List<Map<String, dynamic>> data) {
    return {'format': 'csv', 'data': data};
  }
}

class XmlExportStrategy implements ExportStrategy {
  @override
  Map<String, dynamic> export(List<Map<String, dynamic>> data) {
    return {'format': 'xml', 'data': data};
  }
}

class PdfExportStrategy implements ExportStrategy {
  @override
  Map<String, dynamic> export(List<Map<String, dynamic>> data) {
    return {'format': 'pdf', 'data': data};
  }
}

/// ============================================================================
/// PART 4: Report Generator (Closed for modification, open for extension)
/// ============================================================================

class ReportGenerator {
  final Map<String, ReportStrategy> _reportStrategies;
  final Map<String, ExportStrategy> _exportStrategies;
  final Map<String, DataFilter> _filterStrategies;
  final ReportStrategy _defaultReportStrategy;
  final ExportStrategy _defaultExportStrategy;

  ReportGenerator({
    required Map<String, ReportStrategy> reportStrategies,
    required Map<String, ExportStrategy> exportStrategies,
    required Map<String, DataFilter> filterStrategies,
    ReportStrategy? defaultReportStrategy,
    ExportStrategy? defaultExportStrategy,
  }) : _reportStrategies = reportStrategies,
       _exportStrategies = exportStrategies,
       _filterStrategies = filterStrategies,
       _defaultReportStrategy =
           defaultReportStrategy ?? PassthroughReportStrategy(),
       _defaultExportStrategy = defaultExportStrategy ?? JsonExportStrategy();

  /// Generates a report with the specified type, filters, and export format
  /// New report types, filters, and export formats can be added without
  /// modifying this method (OCP)
  Map<String, dynamic> generateReport(
    String reportType,
    List<Map<String, dynamic>> data,
    String exportFormat,
    List<String> filterNames,
  ) {
    // 1) Choose report strategy
    final reportStrategy =
        _reportStrategies[reportType] ?? _defaultReportStrategy;

    // 2) Process data by report type
    var processedData = reportStrategy.process(data);

    // 3) Apply filters in order (acts like a chain of responsibility)
    for (final filterName in filterNames) {
      final filter = _filterStrategies[filterName];
      if (filter != null) {
        processedData = filter.apply(processedData);
      }
    }

    // 4) Export using selected format
    final exportStrategy =
        _exportStrategies[exportFormat] ?? _defaultExportStrategy;

    return exportStrategy.export(processedData);
  }
}

/// ============================================================================
/// USAGE EXAMPLES
/// ============================================================================

void main() {
  // Create ReportGenerator with all strategies
  // New strategies can be added here without modifying ReportGenerator class
  final reportGenerator = ReportGenerator(
    reportStrategies: {
      'sales': SalesReportStrategy(),
      'inventory': InventoryReportStrategy(),
      'customer': CustomerReportStrategy(),
      // Add new report types here (no change in ReportGenerator)
    },
    exportStrategies: {
      'json': JsonExportStrategy(),
      'csv': CsvExportStrategy(),
      'xml': XmlExportStrategy(),
      'pdf': PdfExportStrategy(),
      // Add new export formats here (no change in ReportGenerator)
    },
    filterStrategies: {
      'date_range': DateRangeFilter(),
      'status': StatusFilter(),
      'category': CategoryFilter(),
      // Add new filters here (no change in ReportGenerator)
    },
  );

  final data = <Map<String, dynamic>>[
    {'quantity': 2, 'price': 10.0, 'status': 'paid', 'category': 'A'},
  ];

  // Generate report with multiple filters
  final report = reportGenerator.generateReport('sales', data, 'json', [
    'date_range',
    'status',
  ]);

  print(report);

}
