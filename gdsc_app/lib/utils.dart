import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getIDToken() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? idToken = await user.getIdToken();
      return idToken;
    } else {
      // User is not signed in
      return null;
    }
  } catch (e) {
    print("Error getting ID token: $e");
    return null;
  }
}
