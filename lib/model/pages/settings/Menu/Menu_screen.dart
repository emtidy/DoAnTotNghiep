import 'package:coffee_cap/model/Menu_item.dart';
import 'package:flutter/material.dart';

import '../../widget_small/custom_button.dart';

class MenuSetupScreen extends StatelessWidget {
  final MenuService _menuService = MenuService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<MenuItem>>(
        stream: _menuService.getMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text("Chưa có menu nào, mời thêm vào menu",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return ListTile(
                leading: Image.asset(
                  item.image,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                ),
                title: Text(item.title),
                subtitle: Text('${item.price}đ'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editMenuItem(context, item),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _showDeleteDialog(context, item),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'menu_add',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMenuScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa ${item.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              _menuService.deleteMenuItem(item.id);
              Navigator.pop(context);
            },
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _editMenuItem(BuildContext context, MenuItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMenuScreen(menuItem: item),
      ),
    );
  }
}

class AddMenuScreen extends StatefulWidget {
  final MenuItem? menuItem;

  const AddMenuScreen({Key? key, this.menuItem}) : super(key: key);

  @override
  _AddMenuScreenState createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final MenuService _menuService = MenuService();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  String _category = '';
  List<String> selectedDays = [];
  final List<String> _availableImages = [
    'assets/images/product/img_product1.png',
    'assets/images/product/Trà sữa.jpeg',
    'assets/images/product/Coffe.jpeg',
    'assets/images/product/Nước ép.jpeg',
    'assets/images/product/Sinh Tố.jpeg',
    'assets/images/product/Soda.jpeg',
    'assets/images/product/Trà Xanh.jpeg',
    'assets/images/product/tra_xanh_matcha.jpeg',
    'assets/images/product/tra_sua_tran_chau.jpeg',
    'assets/images/product/cafe_den.jpeg',
    'assets/images/product/cafe_sua.jpeg',
    'assets/images/product/cappuccino.jpeg',
    'assets/images/product/Coffe.jpeg',
    'assets/images/product/img_product.png',
    'assets/images/product/img_product1.png',
    'assets/images/product/latte.jpeg',
    'assets/images/product/nuoc_ep_tao.jpeg',
    'assets/images/product/Nước Khoáng.jpeg',
    'assets/images/product/nuoc_ep_ca_rot.jpeg',
    'assets/images/product/nuoc_ep_dua_hau.jpeg',
    'assets/images/product/nuoc_ep_tao.jpeg',
    'assets/images/product/Sinh Tố.jpeg',
    'assets/images/product/sinh_to_bo.jpeg',
    'assets/images/product/sinh_to_dau.jpeg',
    'assets/images/product/sinh_to_chuoi.jpeg',
    'assets/images/product/sinh_to_xoai.jpeg',
    'assets/images/product/soda_bac_ha.jpeg',
    'assets/images/product/soda_chanh_day.jpeg',
    'assets/images/product/soda_dau_tay.jpeg',
    'assets/images/product/soda_viet_quat.jpeg',
    'assets/images/product/Soda.jpeg',
    'assets/images/product/Trà sữa.jpeg',
    'assets/images/product/Trà Xanh.jpeg',
    'assets/images/product/tra_dao_cam_sa.jpeg',
    'assets/images/product/tra_hoa_cuc.jpeg',
    'assets/images/product/tra_sua_tran_chau.jpeg',
    'assets/images/product/tra_xanh_matcha.jpeg',

    // Thêm các ảnh khác vào đây
  ];
  late String _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.menuItem?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.menuItem?.description ?? '');
    _priceController =
        TextEditingController(text: widget.menuItem?.price.toString() ?? '');
    _category = widget.menuItem?.category ?? '';
    _selectedImage = widget.menuItem?.image ?? _availableImages[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem == null ? "Thêm Menu" : "Sửa Menu"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Tên Menu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập tên menu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category.isEmpty ? null : _category,
                decoration: InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Trà sữa',
                  'Coffee',
                  'Nước ép',
                  'Sinh tố',
                  'Soda',
                  'Trầ xanh',
                  'Nước khoáng',
                  'Trà'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _category = newValue ?? '';
                  });
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng chọn danh mục';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Giá',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập giá';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              _buildImageSelector(),
              SizedBox(height: 24),
              CusButton(
                text: widget.menuItem == null ? 'Thêm' : 'Cập nhật',
                color: Colors.green,
                onPressed: _saveMenuItem,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Chọn ảnh:', style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableImages.length,
            itemBuilder: (context, index) {
              final image = _availableImages[index];
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedImage = image;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            _selectedImage == image ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _saveMenuItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        print('Title: ${_titleController.text}');
        print('Price: ${_priceController.text}');
        print('Category: $_category');

        final menuItem = MenuItem(
          id: widget.menuItem?.id ?? DateTime.now().toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: int.parse(_priceController.text.trim()),
          category: _category,
          image: _selectedImage,
          selectedIce: -1,
          selectedMood: -1,
          selectedSize: -1,
          selectedSugar: -1,
        );

        if (widget.menuItem == null) {
          await _menuService.addMenuItem(menuItem);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm sản phẩm thành công')),
          );
        } else {
          await _menuService.updateMenuItem(menuItem.id, menuItem);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cập nhật sản phẩm thành công')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
