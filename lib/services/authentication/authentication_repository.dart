import 'package:coffee_cap/services/firestore/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirestoreRepository _firestoreRepository;

  AuthenticationRepository(
      this._firebaseAuth, this._googleSignIn, this._firestoreRepository);

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password,
      {String role = 'user'}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore via FirestoreRepository with role
      await _firestoreRepository.saveUserData(userCredential.user!, role: role);

      return userCredential;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-input',
        message: 'Vui lòng nhập email và mật khẩu',
      );
    }

    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await _firestoreRepository.updateLoginTimestamp(userCredential.user!.uid);

    // Kiểm tra quyền đăng nhập
    final canLogin = await checkUserLoginPermission(userCredential.user!.uid);
    if (!canLogin) {
      await _firebaseAuth.signOut();
      throw 'Tài khoản của bạn không được phép đăng nhập';
    }

    return userCredential;
  }

  Future<UserCredential> signInWithGoogle({String role = 'user'}) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return Future.error('Google sign in failed');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    await _firestoreRepository.saveUserData(userCredential.user!, role: role);

    return userCredential;
  }

  Future<void> updateDisplayName(String name) async {
    await _firebaseAuth.currentUser!.updateDisplayName(name);
  }

  Future<void> updateEmail(String email) async {
    await _firebaseAuth.currentUser!.updateEmail(email);
  }

  Future<void> updatePassword(String password) async {
    await _firebaseAuth.currentUser!.updatePassword(password);
  }

  Future<void> reAuthenticateWithCredential(String password) async {
    final AuthCredential credential = EmailAuthProvider.credential(
      email: _firebaseAuth.currentUser!.email!,
      password: password,
    );
    await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> signOut() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // Cập nhật thời gian đăng xuất
      await _firestoreRepository.updateLogoutTimestamp(user);
    }

    await _firebaseAuth.signOut();
  }

  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  User getCurrentUser() {
    return _firebaseAuth.currentUser!;
  }

  Future<bool> checkUserLoginPermission(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) return false;

      final userData = doc.data();
      return userData?['allowLogin'] == true;
    } catch (e) {
      print('Error checking login permission: $e');
      return false;
    }
  }

  Future<void> updateLoginTimestamp(String userId) async {
    await _firestoreRepository.updateLoginTimestamp(userId);
  }

  Future<Map<String, dynamic>?> getUserLoginInfo(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists) return null;

      final userData = doc.data();
      return {
        'lastLoginTime': userData?['lastLoginTime'],
        'lastLogoutTime': userData?['lastLogoutTime'],
      };
    } catch (e) {
      print('Error getting user login info: $e');
      return null;
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Chưa có thông tin';

    final DateTime dateTime = timestamp.toDate();
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
