import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../services/firestore/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widget_small/custom_button.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> filteredEmployees = [];
  bool isLoading = true;
  final searchController = TextEditingController();
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
    _loadEmployees();
  }

  Future<void> _checkAdminRole() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final firestoreRepo = FirestoreRepository(FirebaseFirestore.instance);
      final userData = await firestoreRepo.getUser(currentUser.uid);
      setState(() {
        isAdmin = userData?['role'] == 'admin';
      });
    }
  }

  Future<void> _loadEmployees() async {
    setState(() => isLoading = true);
    try {
      final firestoreRepo = FirestoreRepository(FirebaseFirestore.instance);
      final users = await firestoreRepo.getUsers();
      setState(() {
        employees = users;
        filteredEmployees = users;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading employees: $e');
      setState(() => isLoading = false);
    }
  }

  void _searchEmployees(String query) {
    setState(() {
      filteredEmployees = employees.where((employee) {
        final name = employee['name']?.toString().toLowerCase() ?? '';
        final email = employee['email']?.toString().toLowerCase() ?? '';
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) || email.contains(searchLower);
      }).toList();
    });
  }

  Future<void> _deleteEmployee(String uid) async {
    try {
      final firestoreRepo = FirestoreRepository(FirebaseFirestore.instance);
      await firestoreRepo.deleteUser(uid);
      // Reload danh sách sau khi xóa
      _loadEmployees();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa nhân viên thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa nhân viên: $e')),
      );
    }
  }

  void _showDeleteConfirmDialog(String uid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa nhân viên này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEmployee(uid);
            },
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editEmployee(Map<String, dynamic> employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmployeeScreen(
          employee: employee,
          onUpdate: () {
            _loadEmployees(); // Reload sau khi cập nhật
          },
        ),
      ),
    );
  }

  void _navigateToAddEmployee() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
    );

    // Reload danh sách khi quay lại từ màn hình thêm
    if (result == true) {
      _loadEmployees();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: 80.0,
        ),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm theo tên, email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _searchEmployees,
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredEmployees.length,
                      itemBuilder: (context, index) {
                        final employee = filteredEmployees[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: employee['photoUrl'] != null &&
                                      employee['photoUrl'].toString().isNotEmpty
                                  ? NetworkImage(employee['photoUrl'])
                                  : null,
                              child: employee['photoUrl'] == null ||
                                      employee['photoUrl'].toString().isEmpty
                                  ? Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(
                              employee['name'] ?? 'Không có tên',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Email: ${employee['email'] ?? 'Chưa có email'}'),
                                Text(
                                    'Vai trò: ${employee['role'] == 'admin' ? 'Quản trị' : employee['role'] == 'user' ? 'Nhân viên' : 'Chưa có vai trò'}'),
                                Text(
                                    'Tạo lúc: ${_formatDateTime(employee['createdAt'])}'),
                                Text(
                                    'Đăng nhập cuối: ${_formatDateTime(employee['lastLogin'])}'),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editEmployee(employee),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      _showDeleteConfirmDialog(employee['uid']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              heroTag: 'admin_add',
              onPressed: _navigateToAddEmployee,
              child: Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  String _formatDateTime(dynamic timestamp) {
    if (timestamp == null) return 'Chưa có dữ liệu';
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    }
    return 'Định dạng không hợp lệ';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class AddEmployeeScreen extends StatefulWidget {
  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'user';
  bool allowLogin = false;

  Future<void> _addEmployee() async {
    try {
      if (allowLogin && passwordController.text.isEmpty) {
        throw 'Vui lòng nhập mật khẩu cho tài khoản';
      }

      final firestoreRepo = FirestoreRepository(FirebaseFirestore.instance);

      // Nếu cho phép đăng nhập, tạo tài khoản Firebase Auth trước
      String? uid;
      if (allowLogin) {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        uid = userCredential.user?.uid;

        // Tạo document trong Firestore với ID là UID của user
        await firestoreRepo.addUserWithId({
          'uid': uid,
          'name': nameController.text,
          'email': emailController.text,
          'role': selectedRole,
          'allowLogin': allowLogin,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': null,
        }, uid!);
      } else {
        // Nếu không cho phép đăng nhập, tạo document với ID tự động
        await firestoreRepo.addUser({
          'name': nameController.text,
          'email': emailController.text,
          'role': selectedRole,
          'allowLogin': allowLogin,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thêm nhân viên thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm nhân viên: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm nhân viên')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên nhân viên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            if (allowLogin) ...[
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
            ],
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: InputDecoration(
                labelText: 'Vai trò',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'admin', child: Text('Quản trị')),
                DropdownMenuItem(value: 'user', child: Text('Nhân viên')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Cho phép đăng nhập'),
              subtitle: Text('Tạo tài khoản đăng nhập cho nhân viên'),
              value: allowLogin,
              onChanged: (value) {
                setState(() {
                  allowLogin = value;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addEmployee,
              child: Text('Thêm nhân viên'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class EditEmployeeScreen extends StatefulWidget {
  final Map<String, dynamic> employee;
  final VoidCallback onUpdate;

  const EditEmployeeScreen({
    Key? key,
    required this.employee,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  String selectedRole = 'user';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee['name']);
    emailController = TextEditingController(text: widget.employee['email']);
    selectedRole = widget.employee['role'] ?? 'user';
  }

  Future<void> _updateEmployee() async {
    try {
      final firestoreRepo = FirestoreRepository(FirebaseFirestore.instance);
      await firestoreRepo.updateUser(
        widget.employee['uid'],
        {
          'name': nameController.text,
          'email': emailController.text,
          'role': selectedRole,
        },
      );
      widget.onUpdate();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa nhân viên'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên nhân viên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: InputDecoration(
                labelText: 'Vai trò',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'admin', child: Text('Quản trị')),
                DropdownMenuItem(value: 'user', child: Text('Nhân viên')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateEmployee,
              child: Text('Cập nhật'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
