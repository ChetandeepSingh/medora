import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref ref;
  AuthService(this.ref);

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await ref.read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await ref.read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await ref.read(firebaseAuthProvider).signOut();
  }
}