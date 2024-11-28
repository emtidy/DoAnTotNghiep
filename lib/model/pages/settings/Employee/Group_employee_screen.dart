import 'package:coffee_cap/services/firestore/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeGroupScreen extends StatefulWidget {
  @override
  State<EmployeeGroupScreen> createState() => _EmployeeGroupScreenState();
}

class _EmployeeGroupScreenState extends State<EmployeeGroupScreen> {
  final FirestoreRepository _firestoreRepo =
      FirestoreRepository(FirebaseFirestore.instance);
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
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
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestoreRepo.getUsersStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Đã xảy ra lỗi'));
                  }

                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final users = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .where((user) {
                    final searchLower = searchQuery.toLowerCase();
                    final name = (user['name'] ?? '').toLowerCase();
                    final email = (user['email'] ?? '').toLowerCase();
                    final phone = (user['phone'] ?? '').toLowerCase();
                    return name.contains(searchLower) ||
                        email.contains(searchLower) ||
                        phone.contains(searchLower);
                  }).toList();

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final name = user['name'] ?? 'N/A';
                      final role =
                          user['role'] == 'admin' ? 'Quản trị' : 'Nhân viên';
                      final initial =
                          name.isNotEmpty ? name[0].toUpperCase() : 'N';

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: user['role'] == 'admin'
                                ? Colors.red
                                : Colors.blue,
                            child: Text(initial),
                          ),
                          title: Text(name),
                          subtitle: Text(role),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoreInfoScreen(
                                  userId: user['uid'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreInfoScreen extends StatefulWidget {
  final String userId;

  const StoreInfoScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<StoreInfoScreen> createState() => _StoreInfoScreenState();
}

class _StoreInfoScreenState extends State<StoreInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController hometownController = TextEditingController();
  final TextEditingController identityNumberController =
      TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await FirestoreRepository(FirebaseFirestore.instance)
        .getUser(widget.userId);

    setState(() {
      nameController.text = userData?['name'] ?? '';
      emailController.text = userData?['email'] ?? '';
      phoneController.text = userData?['phone'] ?? '';
      addressController.text = userData?['address'] ?? '';
      birthdayController.text = userData?['birthday'] ?? '';
      hometownController.text = userData?['hometown'] ?? '';
      identityNumberController.text = userData?['identityNumber'] ?? '';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        birthdayController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      await FirestoreRepository(FirebaseFirestore.instance)
          .updateUser(widget.userId, {
        'name': nameController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'birthday': birthdayController.text,
        'hometown': hometownController.text,
        'identityNumber': identityNumberController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thông tin thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật thông tin: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin tài khoản'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                  prefixText: '+84 ',
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              TextField(
                controller: identityNumberController,
                decoration: InputDecoration(
                  labelText: 'Số CCCD/CMND',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: birthdayController,
                    decoration: InputDecoration(
                      labelText: 'Ngày sinh',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: hometownController,
                decoration: InputDecoration(
                  labelText: 'Quê quán',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ hiện tại',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text(
                    'Cập Nhật',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
