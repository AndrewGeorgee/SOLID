/// EXERCISE: Hard - Open/Closed Principle
///
/// TASK: Refactor this code to follow Open/Closed Principle.
/// Currently, adding a new report type, export format, or filter requires
/// modifying the ReportGenerator class.
///
/// HINT: Use multiple design patterns:
/// - Strategy pattern for report types
/// - Strategy pattern for export formats
/// - Chain of responsibility or strategy for filters
/// - Make each component extensible without modifying existing code

class ReportGenerator {
  Map<String, dynamic> generateReport(
    String reportType,
    List<Map<String, dynamic>> data,
    String exportFormat,
    List<String> filters,
  ) {
    // Report type logic - adding new types requires modification
    List<Map<String, dynamic>> processedData = data;

    switch (reportType) {
      case 'sales':
        processedData = _processSalesData(data);
        break;
      case 'inventory':
        processedData = _processInventoryData(data);
        break;
      case 'customer':
        processedData = _processCustomerData(data);
        break;
      // Adding new report type requires modifying this
      default:
        processedData = data;
    }

    // Filter logic - adding new filters requires modification
    for (var filter in filters) {
      switch (filter) {
        case 'date_range':
          processedData = _applyDateRangeFilter(processedData);
          break;
        case 'status':
          processedData = _applyStatusFilter(processedData);
          break;
        case 'category':
          processedData = _applyCategoryFilter(processedData);
          break;
        // Adding new filter requires modifying this
      }
    }

    // Export format logic - adding new formats requires modification
    switch (exportFormat) {
      case 'json':
        return _exportAsJson(processedData);
      case 'csv':
        return _exportAsCsv(processedData);
      case 'xml':
        return _exportAsXml(processedData);
      case 'pdf':
        return _exportAsPdf(processedData);
      // Adding new export format requires modifying this
      default:
        return _exportAsJson(processedData);
    }
  }

  List<Map<String, dynamic>> _processSalesData(
    List<Map<String, dynamic>> data,
  ) {
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

  List<Map<String, dynamic>> _processInventoryData(
    List<Map<String, dynamic>> data,
  ) {
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

  List<Map<String, dynamic>> _processCustomerData(
    List<Map<String, dynamic>> data,
  ) {
    // Customer-specific processing
    return data;
  }

  List<Map<String, dynamic>> _applyDateRangeFilter(
    List<Map<String, dynamic>> data,
  ) {
    // Date range filtering logic
    return data;
  }

  List<Map<String, dynamic>> _applyStatusFilter(
    List<Map<String, dynamic>> data,
  ) {
    // Status filtering logic
    return data;
  }

  List<Map<String, dynamic>> _applyCategoryFilter(
    List<Map<String, dynamic>> data,
  ) {
    // Category filtering logic
    return data;
  }

  Map<String, dynamic> _exportAsJson(List<Map<String, dynamic>> data) {
    return {'format': 'json', 'data': data};
  }

  Map<String, dynamic> _exportAsCsv(List<Map<String, dynamic>> data) {
    return {'format': 'csv', 'data': data};
  }

  Map<String, dynamic> _exportAsXml(List<Map<String, dynamic>> data) {
    return {'format': 'xml', 'data': data};
  }

  Map<String, dynamic> _exportAsPdf(List<Map<String, dynamic>> data) {
    return {'format': 'pdf', 'data': data};
  }
}
