import 'package:coffee_cap/core/colors/color.dart';
import 'package:coffee_cap/model/pages/screens/floor/dialogs/product_selection_dialog.dart';
import 'package:coffee_cap/model/table.dart';
import 'package:flutter/material.dart';

class OrderDialog extends StatefulWidget {
  final TableModel table;

  const OrderDialog({Key? key, required this.table}) : super(key: key);

  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  final TextEditingController _peopleController = TextEditingController();
  final List<OrderItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _peopleController.text = widget.table.numberOfPeople.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Order - ${widget.table.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _peopleController,
                    decoration: const InputDecoration(
                      labelText: 'Số người',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _addNewItem,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Thêm món',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedItems.length,
                itemBuilder: (context, index) {
                  final item = _selectedItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.productName),
                      subtitle: Text(
                        'Số lượng: ${item.quantity} - ${item.price.toStringAsFixed(0)}đ'
                        '\nGhi chú: ${item.note}'
                        '\nTùy chọn: ${item.options.join(", ")}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _selectedItems.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng cộng: ${_calculateTotal().toStringAsFixed(0)}đ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _saveOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.green,
                      ),
                      child: const Text(
                        'Lưu',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addNewItem() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const ProductSelectionDialog(),
    );

    if (result != null && result is OrderItem) {
      setState(() {
        _selectedItems.add(result);
      });
    }
  }

  double _calculateTotal() {
    return _selectedItems.fold(
      0,
      (total, item) => total + (item.price * item.quantity),
    );
  }

  void _saveOrder() {
    int people = int.tryParse(_peopleController.text) ?? 0;
    if (people <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số người')),
      );
      return;
    }

    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất một món')),
      );
      return;
    }

    Navigator.pop(context, {
      'items': _selectedItems
          .map((item) => {
                'productId': item.productId,
                'productName': item.productName,
                'quantity': item.quantity,
                'price': item.price,
                'options': item.options,
                'note': item.note,
              })
          .toList(),
      'numberOfPeople': people,
    });
  }
}
