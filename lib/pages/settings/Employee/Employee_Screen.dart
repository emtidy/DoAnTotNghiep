import 'package:coffee_cap/pages/widget_small/custom_button.dart';
import 'package:flutter/material.dart';

class EmployeeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Trang Chủ'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Lịch Sử'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.online_prediction),
              title: Text('Đơn Online'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Báo Cáo'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Thiết Lập'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm theo tên, số điện thoại, email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Lý yếu lòng'),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Tôn ngộ không'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddEmployeeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Nhân Viên"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Họ tên',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Nhóm nhân viên',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(child: Text("Nhóm 1"), value: "1"),
                  DropdownMenuItem(child: Text("Nhóm 2"), value: "2"),
                ],
                onChanged: (value) {},
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              SwitchListTile(
                title: Text('Cho phép đăng nhập'),
                value: true,
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              CusButton(
                 text: 'Lưu',
                color: Colors.green, onPressed: () {  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
