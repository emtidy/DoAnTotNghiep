import 'dart:math';
import 'dart:async';

import 'package:coffee_cap/model/invoice_item.dart';
import 'package:coffee_cap/service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration.zero),
        builder: (context, snapshot) {
          return Scaffold(
            drawer: Drawer(),
            body: ReportBody(),
          );
        });
  }
}

class ReportBody extends StatefulWidget {
  @override
  State<ReportBody> createState() => _ReportBodyState();
}

class _ReportBodyState extends State<ReportBody> {
  final InvoiceService _invoiceService = InvoiceService();
  List<Invoice> _invoices = [];
  DateTime _selectedDate = DateTime.now();
  String _selectedPeriod = 'Ngày';
  StreamSubscription? _invoiceSubscription;

  @override
  void initState() {
    super.initState();
    _setupInvoiceStream();
  }

  void _setupInvoiceStream() {
    _invoiceSubscription =
        _invoiceService.getInvoicesStream().listen((invoices) {
      if (mounted) {
        setState(() {
          _invoices = invoices
              .where((invoice) =>
                  invoice != null &&
                  invoice.items != null &&
                  invoice.total != null)
              .toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _invoiceSubscription?.cancel();
    super.dispose();
  }

  Map<String, dynamic> _calculateStatistics() {
    double totalRevenue = 0;
    int totalOrders = 0;
    Map<String, int> productStats = {};

    for (var invoice in _getFilteredInvoices()) {
      totalRevenue += invoice.total;
      totalOrders++;

      for (var item in invoice.items) {
        String productName = item['title'] ?? '';
        int quantity = item['quantity'] ?? 0;
        productStats[productName] = (productStats[productName] ?? 0) + quantity;
      }
    }

    String bestSeller = '';
    int maxQuantity = 0;
    productStats.forEach((product, quantity) {
      if (quantity > maxQuantity) {
        maxQuantity = quantity;
        bestSeller = product;
      }
    });

    return {
      'totalRevenue': totalRevenue,
      'totalOrders': totalOrders,
      'averageOrderValue': totalOrders > 0 ? totalRevenue / totalOrders : 0,
      'bestSeller': bestSeller,
      'bestSellerQuantity': maxQuantity,
    };
  }

  List<Invoice> _getFilteredInvoices() {
    return _invoices.where((invoice) {
      DateTime invoiceDate = DateTime.parse(invoice.date);

      switch (_selectedPeriod) {
        case 'Ngày':
          return invoiceDate.year == _selectedDate.year &&
              invoiceDate.month == _selectedDate.month &&
              invoiceDate.day == _selectedDate.day;
        case 'Tuần':
          final startOfWeek =
              _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          return invoiceDate.isAfter(startOfWeek) &&
              invoiceDate.isBefore(endOfWeek.add(const Duration(days: 1)));
        case 'Tháng':
          return invoiceDate.year == _selectedDate.year &&
              invoiceDate.month == _selectedDate.month;
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Invoice>>(
      stream: _invoiceService.getInvoicesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        _invoices = snapshot.data ?? [];
        final stats = _calculateStatistics();

        return DefaultTabController(
          length: 1,
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TabBar(
                          labelColor: Colors.green,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.green,
                          tabs: [
                            Tab(text: 'Báo cáo tài chính'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedPeriod,
                        items: ['Ngày', 'Tuần', 'Tháng'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedPeriod = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tab 1 - Báo cáo tài chính
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Thống kê tổng quan
                            Row(
                              children: [
                                _buildStatCard(
                                  'Tổng doanh thu',
                                  '${NumberFormat('#,###').format(stats['totalRevenue'])}đ',
                                  Icons.attach_money,
                                  Colors.green,
                                  context,
                                ),
                                const SizedBox(width: 16),
                                _buildStatCard(
                                  'Số đơn hàng',
                                  '${stats['totalOrders']}',
                                  Icons.receipt_long,
                                  Colors.blue,
                                  context,
                                ),
                                const SizedBox(width: 16),
                                _buildStatCard(
                                  'Trung bình/đơn',
                                  '${NumberFormat('#,###').format(stats['averageOrderValue'])}đ',
                                  Icons.shopping_cart,
                                  Colors.orange,
                                  context,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Biểu đồ doanh thu
                            Container(
                              height: 800,
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Biểu đồ doanh thu(VND)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                  ),
                                  const SizedBox(height: 32),
                                  Expanded(
                                    child: BarChart(
                                      BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceAround,
                                        maxY: 5.0,
                                        barTouchData: BarTouchData(
                                          touchTooltipData: BarTouchTooltipData(
                                            getTooltipItem: (group, groupIndex,
                                                rod, rodIndex) {
                                              final amount = rod.toY * 1000000;
                                              return BarTooltipItem(
                                                '${NumberFormat("#,###").format(amount)}đ\nNgày ${group.x + 1}',
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        gridData: FlGridData(
                                          drawHorizontalLine: true,
                                          horizontalInterval: 1.0,
                                          drawVerticalLine: false,
                                        ),
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: 1.0,
                                              getTitlesWidget: (value, meta) {
                                                final amount = value * 1000000;
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0),
                                                  child: Text(
                                                    '${NumberFormat("#,###").format(amount)}đ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                );
                                              },
                                              reservedSize: 80,
                                            ),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: 5,
                                              getTitlesWidget: (value, meta) {
                                                if (value % 5 == 0) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(
                                                      'Ngày ${value.toInt() + 1}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return const SizedBox.shrink();
                                              },
                                              reservedSize: 40,
                                            ),
                                          ),
                                          rightTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                        ),
                                        barGroups: _createBarChartData(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 500,
                              padding: const EdgeInsets.all(16),
                              margin:
                                  const EdgeInsets.only(top: 24, bottom: 100),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phân bố sản phẩm bán ra',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: PieChart(
                                            PieChartData(
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 60,
                                              sections:
                                                  _createPieChartSections(),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildProductLegend(),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color,
      BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Thêm hàm để tạo dữ liệu cho biểu đồ
  List<FlSpot> _createChartData() {
    Map<int, double> dailyRevenue = {};

    // Khởi tạo giá trị 0 cho tất cả các ngày
    for (int i = 0; i < 30; i++) {
      dailyRevenue[i] = 0;
    }

    // Tính tổng doanh thu theo ngày
    for (var invoice in _getFilteredInvoices()) {
      DateTime invoiceDate = DateTime.parse(invoice.date);
      int day = invoiceDate.day - 1;
      dailyRevenue[day] = (dailyRevenue[day] ?? 0) + invoice.total;
    }

    // Chuyển đổi thành danh sách FlSpot (chia 1000 để hiển thị theo nghìn)
    return dailyRevenue.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value / 1000))
        .toList();
  }

  // Thêm hàm tạo dữ liệu cho biểu đồ tròn
  List<PieChartSectionData> _createPieChartSections() {
    Map<String, int> productStats = {};

    // Tính số lượng bán của từng sản phẩm
    for (var invoice in _getFilteredInvoices()) {
      for (var item in invoice.items) {
        String productName = item['title'] ?? '';
        int quantity = item['quantity'] ?? 0;
        productStats[productName] = (productStats[productName] ?? 0) + quantity;
      }
    }

    // Đảm bảo mỗi màu đều khác biệt và dễ nhìn
    final List<Color> colors = const [
      Color(0xFF4CAF50), // Xanh lá
      Color(0xFF2196F3), // Xanh dương
      Color(0xFFFF5722), // Cam đỏ
      Color(0xFF9C27B0), // Tím
      Color(0xFFFFEB3B), // Vàng
      Color(0xFF795548), // Nâu
      Color(0xFF00BCD4), // Cyan
      Color(0xFFE91E63), // Hồng
      Color(0xFF607D8B), // Xám xanh
      Color(0xFFFF9800), // Cam
    ];

    double total = productStats.values.fold(0, (sum, value) => sum + value);
    List<MapEntry<String, int>> sortedEntries = productStats.entries.toList()
      ..sort((a, b) =>
          b.value.compareTo(a.value)); // Sắp xếp theo số lượng giảm dần

    return sortedEntries.asMap().entries.map((entry) {
      final int index = entry.key;
      final String productName = entry.value.key;
      final int quantity = entry.value.value;
      final double percentage = (quantity / total) * 100;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: quantity.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Colors.black26,
            ),
          ],
        ),
        badgeWidget: Text(
          productName,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();
  }

  // Cập nhật widget chú thích để khớp với biểu đồ
  Widget _buildProductLegend() {
    Map<String, int> productStats = {};
    for (var invoice in _getFilteredInvoices()) {
      for (var item in invoice.items) {
        String productName = item['title'] ?? '';
        int quantity = item['quantity'] ?? 0;
        productStats[productName] = (productStats[productName] ?? 0) + quantity;
      }
    }

    final List<Color> colors = const [
      Color(0xFF4CAF50), // Xanh lá
      Color(0xFF2196F3), // Xanh dương
      Color(0xFFFF5722), // Cam đỏ
      Color(0xFF9C27B0), // Tím
      Color(0xFFFFEB3B), // Vàng
      Color(0xFF795548), // Nâu
      Color(0xFF00BCD4), // Cyan
      Color(0xFFE91E63), // Hồng
      Color(0xFF607D8B), // Xám xanh
      Color(0xFFFF9800), // Cam
    ];

    List<MapEntry<String, int>> sortedEntries = productStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedEntries.asMap().entries.map((entry) {
        final int index = entry.key;
        final String productName = entry.value.key;
        final int quantity = entry.value.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<BarChartGroupData> _createBarChartData() {
    Map<int, double> dailyRevenue = {};

    // Khởi tạo giá trị 0 cho tất cả các ngày
    for (int i = 0; i < 30; i++) {
      dailyRevenue[i] = 0;
    }

    // Tính tổng doanh thu theo ngày
    for (var invoice in _getFilteredInvoices()) {
      DateTime invoiceDate = DateTime.parse(invoice.date);
      int day = invoiceDate.day - 1;
      dailyRevenue[day] = (dailyRevenue[day] ?? 0) +
          (invoice.total / 1000000); // Chuyển đổi sang triệu
    }

    // Tạo dữ liệu cho biểu đồ với giá trị tối đa là 5 triệu
    return dailyRevenue.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: min(entry.value, 5.0), // Giới hạn giá trị tối đa là 5
            color: Colors.green,
            width: 16,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 5.0, // Đặt giá trị tối đa là 5
              color: Colors.grey[200],
            ),
          ),
        ],
      );
    }).toList();
  }

  double _calculateMaxRevenue() {
    return 5.0; // Trả về giá trị cố định là 5 triệu
  }

  Future<void> _refreshData() async {
    // await _invoiceService.loadAndEmitInvoices();
  }
}
