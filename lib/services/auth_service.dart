import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Auth state changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign up
  Future<UserCredential> signUp(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    
    // Create firestore profile
    await _db.collection('users').doc(result.user!.uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Send verification email
    await result.user!.sendEmailVerification();
    
    return result;
  }

  // Login
  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Check email verification
  Future<bool> checkEmailVerified() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  // Password reset
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
