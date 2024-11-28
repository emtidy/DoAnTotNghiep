import 'package:coffee_cap/core/assets.dart';
import 'package:coffee_cap/core/colors/color.dart';
import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:coffee_cap/model/Menu_item.dart';
import 'package:flutter/material.dart';
import '../../../Begever.dart';
import '../../widget_small/custom_button.dart';
import 'invoice_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MenuService _menuService = MenuService();
  final BeverageService _beverageService = BeverageService();

  int _selectedDrinkIndex = -1;
  List<MenuItem> _filteredMenuItems = [];
  MenuItem? _selectedMenuItem;

  final Map<String, Map<String, int>> _itemOptions = {};
  final List<String> options = ['30%', '50%', '70%'];

  List<Map<String, dynamic>> _invoiceItems = [];
  double _subtotal = 0;
  double _vat = 0;
  double _total = 0;

  Map<String, int> _getOptionsForItem(String itemTitle) {
    return _itemOptions[itemTitle] ??
        {
          'mood': -1,
          'size': -1,
          'sugar': -1,
          'ice': -1,
        };
  }

  void _updateOption(String itemTitle, String optionType, int value) {
    setState(() {
      if (!_itemOptions.containsKey(itemTitle)) {
        _itemOptions[itemTitle] = {
          'mood': -1,
          'size': -1,
          'sugar': -1,
          'ice': -1,
        };
      }
      _itemOptions[itemTitle]![optionType] = value;
    });
  }

  void _resetOptions(String itemTitle) {
    setState(() {
      _itemOptions[itemTitle] = {
        'mood': -1,
        'size': -1,
        'sugar': -1,
        'ice': -1,
      };
    });
  }

  void _clearInvoice() {
    setState(() {
      _invoiceItems.clear();
      _subtotal = 0;
      _vat = 0;
      _total = 0;
      _selectedMenuItem = null;
      _itemOptions.clear();
    });
  }

  void _addToInvoice(MenuItem menuItem) {
    final options = _getOptionsForItem(menuItem.title);
    String selectedOptions = 'Mood: ${options['mood'] == 0 ? 'Hot' : 'Cold'}, '
        'Size: ${['S', 'M', 'L'][options['size']!]}, '
        'Sugar: ${this.options[options['sugar']!]}, '
        'Ice: ${this.options[options['ice']!]}';

    setState(() {
      int existingIndex = _invoiceItems.indexWhere((item) =>
          item['title'] == menuItem.title &&
          item['options'] == selectedOptions);

      if (existingIndex != -1) {
        _invoiceItems[existingIndex]['quantity'] =
            (_invoiceItems[existingIndex]['quantity'] as int) + 1;
      } else {
        _invoiceItems.add({
          'title': menuItem.title,
          'price': menuItem.price,
          'quantity': 1,
          'image': menuItem.image,
          'options': selectedOptions,
        });
      }

      _updateTotals();
      _selectedMenuItem = null;
      _resetOptions(menuItem.title);
    });
  }

  void _updateTotals() {
    _subtotal = _invoiceItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
    _vat = _subtotal * 0.1;
    _total = _subtotal + _vat;
  }

  List<MenuItem> _filterMenuItems(List<MenuItem> items) {
    if (_selectedDrinkIndex <= 0) return items;
    return items.where((item) {
      final beverages = BeverageService.defaultBeverages;
      print(
          'Filtering: ${item.category} vs ${beverages[_selectedDrinkIndex].name}');
      return item.category.toLowerCase() ==
          beverages[_selectedDrinkIndex].name.toLowerCase();
    }).toList();
  }

  void _onBeverageTapped(int index, String category) {
    setState(() {
      _selectedDrinkIndex = index;
      _selectedMenuItem = null;
      if (_selectedMenuItem != null) {
        _resetOptions(_selectedMenuItem!.title);
      }
    });
  }

  Widget _buildOptionButton({
    required String option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
        child: Text(
          option,
          style: context.theme.textTheme.titleSmall?.copyWith(
            color: isSelected ? Colors.green : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemOptions(MenuItem menuItem) {
    final options = _getOptionsForItem(menuItem.title);

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: context.width * 0.14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mood",
                    style: context.theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      bottomInProduct(
                        context,
                        Asset.iconHot,
                        "",
                        options['mood'] == 0,
                        () => _updateOption(menuItem.title, 'mood', 0),
                      ),
                      bottomInProduct(
                        context,
                        Asset.iconCold,
                        "",
                        options['mood'] == 1,
                        () => _updateOption(menuItem.title, 'mood', 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Size",
                  style: context.theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    bottomInProduct(
                      context,
                      Asset.iconHot,
                      "S",
                      options['size'] == 0,
                      () => _updateOption(menuItem.title, 'size', 0),
                    ),
                    bottomInProduct(
                      context,
                      Asset.iconCold,
                      "M",
                      options['size'] == 1,
                      () => _updateOption(menuItem.title, 'size', 1),
                    ),
                    bottomInProduct(
                      context,
                      Asset.iconCold,
                      "L",
                      options['size'] == 2,
                      () => _updateOption(menuItem.title, 'size', 2),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: context.width * 0.136,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sugar",
                    style: context.theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: this.options.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String option = entry.value;
                      return _buildOptionButton(
                        option: option,
                        isSelected: options['sugar'] == idx,
                        onTap: () =>
                            _updateOption(menuItem.title, 'sugar', idx),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ice",
                  style: context.theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: this.options.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String option = entry.value;
                    return _buildOptionButton(
                      option: option,
                      isSelected: options['ice'] == idx,
                      onTap: () => _updateOption(menuItem.title, 'ice', idx),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
        CusButton(
          onPressed: () {
            final opts = _getOptionsForItem(menuItem.title);
            if (opts['mood']! >= 0 &&
                opts['size']! >= 0 &&
                opts['sugar']! >= 0 &&
                opts['ice']! >= 0) {
              _addToInvoice(menuItem);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vui lòng chọn đầy đủ các tùy chọn'),
                ),
              );
            }
          },
          text: "Thêm vào hóa đơn",
          color: Styles.green,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Styles.defaultPadding, right: Styles.defaultPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: SizedBox(
                      width: context.width * 0.62,
                      height: context.height * 0.14,
                      child: StreamBuilder<List<Beverage>>(
                        stream: _beverageService.getBeverages(),
                        initialData: BeverageService.defaultBeverages,
                        builder: (context, snapshot) {
                          final beverages =
                              snapshot.data ?? BeverageService.defaultBeverages;

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: beverages.length,
                            itemBuilder: (context, index) {
                              bool isSelected = _selectedDrinkIndex == index;
                              return GestureDetector(
                                onTap: () => _onBeverageTapped(
                                    index, beverages[index].name),
                                child: containerDrink(
                                  beverages[index].name,
                                  beverages[index].imageUrl,
                                  isSelected,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
                  Text(
                    "Tất cả menu",
                    style: context.theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: context.height * 0.01),
                  SizedBox(
                    width: context.width * 0.63,
                    height: context.height * 0.62,
                    child: StreamBuilder<List<MenuItem>>(
                      stream: _menuService.getMenuItems(),
                      initialData: allMenuItems,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        print('Firebase data: ${snapshot.data?.length}');
                        final menuItems = snapshot.data ?? allMenuItems;
                        _filteredMenuItems = _filterMenuItems(menuItems);

                        return SingleChildScrollView(
                          child: Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: List.generate(_filteredMenuItems.length,
                                (index) {
                              final menuItem = _filteredMenuItems[index];
                              bool isSelected =
                                  _selectedMenuItem?.title == menuItem.title;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_selectedMenuItem?.title !=
                                        menuItem.title) {
                                      _selectedMenuItem = menuItem;
                                      if (!_itemOptions
                                          .containsKey(menuItem.title)) {
                                        _resetOptions(menuItem.title);
                                      }
                                    } else {
                                      _selectedMenuItem = null;
                                    }
                                  });
                                },
                                child: Container(
                                  width: context.width * 0.308,
                                  padding:
                                      EdgeInsets.all(Styles.defaultPadding),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Styles.dark.withOpacity(0.2),
                                        offset: const Offset(1.1, 1.1),
                                        blurRadius: 5,
                                      ),
                                    ],
                                    color: isSelected
                                        ? Styles.light.withOpacity(0.9)
                                        : Styles.light,
                                    border: isSelected
                                        ? Border.all(
                                            color: Styles.green, width: 2)
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: context.height * 0.2,
                                            width: context.width * 0.1,
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              image: DecorationImage(
                                                image:
                                                    AssetImage(menuItem.image),
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.width * 0.15,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  menuItem.title,
                                                  style: context.theme.textTheme
                                                      .headlineSmall
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  menuItem.description,
                                                  style: context.theme.textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                    color: Styles.grey,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        context.height * 0.015),
                                                Text(
                                                  '${menuItem.price} đ',
                                                  style: context.theme.textTheme
                                                      .headlineMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isSelected)
                                        _buildMenuItemOptions(menuItem),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.85,
                width: context.width * 0.26,
                child: InvoiceWidget(
                  invoiceItems: _invoiceItems,
                  subtotal: _subtotal,
                  vat: _vat,
                  total: _total,
                  onClearInvoice: _clearInvoice,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget containerDrink(String title, String img, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: isSelected ? Colors.greenAccent.withOpacity(0.1) : Styles.light,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Styles.green.withOpacity(0.2),
            offset: const Offset(1.1, 1.1),
            blurRadius: 5,
          ),
        ],
        border: Border.all(
          width: 1,
          color: isSelected ? Styles.green : Styles.grey,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: context.height * 0.07,
            width: context.width * 0.06,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Styles.light,
              image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            width: context.width * 0.055,
            child: Text(
              title,
              style: context.theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomInProduct(BuildContext context, String img, String title,
      bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
        child: Opacity(
          opacity: isSelected ? 0.5 : 1,
          child: CircleAvatar(
            backgroundColor: Styles.greyNearLight,
            radius: 20,
            child: title == ""
                ? Image.asset(img)
                : Text(
                    title,
                    style: context.theme.textTheme.headlineSmall,
                  ),
          ),
        ),
      ),
    );
  }
}
