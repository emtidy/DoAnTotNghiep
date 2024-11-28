import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String usersCollection = 'users';
  final String userSessionsCollection = 'user_sessions';
  final String wordCollection = 'Word';

  FirestoreRepository(this._firestore);

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllWords() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(wordCollection).get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<String> getUserRole(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists) {
      return 'user';
    }

    if (!doc.data()!.containsKey('role')) {
      return 'user';
    }

    return doc.get('role') ?? 'user';
  }

  Future<void> updateLoginTimestamp(String uid) async {
    try {
      // Kiểm tra document có tồn tại không
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (!docSnapshot.exists) {
        // Nếu document chưa tồn tại, tạo mới với các giá trị mặc định
        await _firestore.collection('users').doc(uid).set({
          'lastLogin': FieldValue.serverTimestamp(),
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Nếu document đã tồn tại, chỉ cập nhật lastLogin
        await _firestore.collection('users').doc(uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating login timestamp: $e');
      rethrow;
    }
  }

  Future<void> updateLogoutTimestamp(User user) async {
    await _firestore.collection('users').doc(user.uid).update({
      'lastLogoutAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getTime() async {
    try {
      final QuerySnapshot userSnapshot =
          await _firestore.collection(usersCollection).orderBy('name').get();

      List<Map<String, dynamic>> users = [];

      for (var doc in userSnapshot.docs) {
        final latestSession = await _firestore
            .collection(userSessionsCollection)
            .where('userId', isEqualTo: doc.id)
            .orderBy('loginTime', descending: true)
            .limit(1)
            .get();

        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        userData['id'] = doc.id;

        if (latestSession.docs.isNotEmpty) {
          final sessionData = latestSession.docs.first.data();
          final loginTime = (sessionData['loginTime'] as Timestamp).toDate();
          final logoutTime = sessionData['logoutTime'] != null
              ? (sessionData['logoutTime'] as Timestamp).toDate()
              : null;

          userData['lastLoginTime'] = loginTime;
          userData['lastLogoutTime'] = logoutTime;
          userData['isCurrentlyLoggedIn'] = logoutTime == null;

          if (logoutTime == null) {
            final duration = DateTime.now().difference(loginTime);
            userData['currentSessionDuration'] = duration;
          }
        }

        users.add(userData);
      }

      return users;
    } catch (e) {
      throw e;
    }
  }

  // Add new user
  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      // Tạo một document ID mới
      DocumentReference docRef = _firestore.collection(usersCollection).doc();

      // Thêm uid vào userData
      userData['uid'] = docRef.id;
      userData['allowLogin'] =
          userData['allowLogin'] ?? false; // Mặc định là false
      userData['createdAt'] = FieldValue.serverTimestamp();
      userData['lastLoginAt'] = null;

      await docRef.set(userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(uid).update(userData);
  }

  Future<void> deleteUser(String userId) async {
    try {
      final sessions = await _firestore
          .collection(userSessionsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      for (var session in sessions.docs) {
        await session.reference.delete();
      }

      await _firestore.collection(usersCollection).doc(userId).delete();
    } catch (e) {
      throw e;
    }
  }

  // Record user login
  Future<void> recordUserLogin(String userId) async {
    try {
      await _firestore.collection(userSessionsCollection).add({
        'userId': userId,
        'loginTime': FieldValue.serverTimestamp(),
        'deviceInfo': await _getDeviceInfo(),
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> recordUserLogout(String userId) async {
    try {
      final activeSession = await _firestore
          .collection(userSessionsCollection)
          .where('userId', isEqualTo: userId)
          .where('logoutTime', isNull: true)
          .orderBy('loginTime', descending: true)
          .limit(1)
          .get();

      if (activeSession.docs.isNotEmpty) {
        await activeSession.docs.first.reference.update({
          'logoutTime': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error recording logout: $e');
      throw e;
    }
  }

  Future<Duration> getUserTodaySessionTime(String userId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final sessions = await _firestore
          .collection(userSessionsCollection)
          .where('userId', isEqualTo: userId)
          .where('loginTime', isGreaterThanOrEqualTo: startOfDay)
          .get();

      Duration totalDuration = Duration.zero;

      for (var session in sessions.docs) {
        final data = session.data();
        final loginTime = (data['loginTime'] as Timestamp).toDate();
        final logoutTime = data['logoutTime'] != null
            ? (data['logoutTime'] as Timestamp).toDate()
            : DateTime.now();

        totalDuration += logoutTime.difference(loginTime);
      }

      return totalDuration;
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': 'Flutter',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Future<void> saveUserData(User user, {String role = 'user'}) async {
    try {
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? '',
        'photoUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'role': role,
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));
    } catch (e) {}
  }

  Future<void> updateLogoutTime(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastLogoutAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {}
  }

  Future<void> calculateUsageTime(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final lastLoginAt = (userDoc['lastLoginAt'] as Timestamp?)?.toDate();
      final lastLogoutAt = (userDoc['lastLogoutAt'] as Timestamp?)?.toDate();

      if (lastLoginAt != null && lastLogoutAt != null) {
        final duration = lastLogoutAt.difference(lastLoginAt);
      } else {}
    } else {}
  }

  Future<void> updateUserActivity(
      {int listeningScore = 0,
      int speakingScore = 0,
      int readingScore = 0,
      int writingScore = 0}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final today = DateTime.now().toIso8601String().split('T')[0];
      DocumentReference userActivityRef =
          _firestore.collection('user_activity').doc(userId);

      await userActivityRef.set({
        'userId': userId,
        'accessDates': FieldValue.arrayUnion([today]),
        'totalHours': FieldValue.increment(1),
        'scores': {
          'listening': FieldValue.increment(listeningScore),
          'speaking': FieldValue.increment(speakingScore),
          'reading': FieldValue.increment(readingScore),
          'writing': FieldValue.increment(writingScore),
        }
      }, SetOptions(merge: true));
    }
  }

  Future<Map<String, dynamic>> getUserActivity() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final snapshot =
          await _firestore.collection('user_activity').doc(userId).get();

      if (snapshot.exists) {
        final data = snapshot.data();
        return {
          'daysVisited': (data?['accessDates'] as List<dynamic>)?.length ?? 0,
          'totalHours': data?['totalHours'] ?? 0,
        };
      }
    }
    return {
      'daysVisited': 0,
      'totalHours': 0,
    };
  }

  Future<void> updateDisplayName(String name, String uid) async {
    await _firestore.collection('users').doc(uid).update({'name': name});
  }

  Future<void> updateEmail(String email, String uid) async {
    await _firestore.collection('users').doc(uid).update({'email': email});
  }

  Future<void> addUserWithId(Map<String, dynamic> userData, String uid) async {
    await _firestore.collection('users').doc(uid).set(userData);
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }
}
