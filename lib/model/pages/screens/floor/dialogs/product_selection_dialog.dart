import 'package:coffee_cap/model/Menu_item.dart';
import 'package:coffee_cap/model/table.dart';
import 'package:flutter/material.dart';

import '../../../../../core/colors/color.dart';

class ProductSelectionDialog extends StatefulWidget {
  const ProductSelectionDialog({Key? key}) : super(key: key);

  @override
  State<ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? _selectedProduct;
  List<String> _selectedOptions = [];
  List<MenuItem> _products = [];
  bool _isLoading = true;
  final MenuService _menuService = MenuService();

  @override
  void initState() {
    super.initState();
    _quantityController.text = '1';
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _menuService.getMenuItems().first;
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(20),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Chọn món',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedProduct,
                      decoration: const InputDecoration(
                        labelText: 'Sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      items: _products.map((product) {
                        return DropdownMenuItem<String>(
                          value: product.id,
                          child: Text(
                            '${product.title} - ${product.price}đ',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProduct = value;
                          _selectedOptions.clear();
                        });
                      },
                    ),
                    if (_selectedProduct != null) ...[
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        children:
                            _getProductOptions(_selectedProduct!).map((option) {
                          return FilterChip(
                            label: Text(option),
                            selected: _selectedOptions.contains(option),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedOptions.add(option);
                                } else {
                                  _selectedOptions.remove(option);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _quantityController,
                            decoration: const InputDecoration(
                              labelText: 'Số lượng',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: 'Ghi chú',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _addProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Styles.green,
                          ),
                          child: const Text('Thêm'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<String> _getProductOptions(String productId) {
    final product = _products.firstWhere((p) => p.id == productId);
    return ['Nóng', 'Đá', 'Ít đường', 'Nhiều đường'];
  }

  void _addProduct() {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn sản phẩm')),
      );
      return;
    }

    final product = _products.firstWhere((p) => p.id == _selectedProduct);
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số lượng không hợp lệ')),
      );
      return;
    }

    final orderItem = OrderItem(
      productId: product.id,
      productName: product.title,
      quantity: quantity,
      price: product.price.toDouble(),
      options: _selectedOptions,
      note: _noteController.text,
    );

    Navigator.pop(context, orderItem);
  }
}
