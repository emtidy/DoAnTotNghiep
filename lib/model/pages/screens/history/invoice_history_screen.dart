import 'package:coffee_cap/model/invoice_item.dart';
import 'package:coffee_cap/service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../bill_tab/widget_bill/receipt_dialog.dart';

class InvoiceHistoryScreen extends StatelessWidget {
  final InvoiceService _invoiceService = InvoiceService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch sử hóa đơn'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Hóa đơn bàn'),
              Tab(text: 'Hóa đơn thông thường'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab hóa đơn bàn
            FutureBuilder<List<Invoice>>(
              future: _invoiceService.getTableInvoices(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildInvoiceList(snapshot.data!);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            // Tab hóa đơn thông thường
            FutureBuilder<List<Invoice>>(
              future: _invoiceService.getGeneralInvoices(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildInvoiceList(snapshot.data!);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceList(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return const Center(
        child: Text('Không có hóa đơn nào'),
      );
    }

    return ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return ListTile(
          title: Text('Hóa đơn ${invoice.id}'),
          subtitle: Text('Ngày: ${invoice.date}\n'
              'Tổng tiền: ${invoice.total}đ'),
          onTap: () {
            // Xử lý khi tap vào hóa đơn
          },
        );
      },
    );
  }
}
