import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moneymanager/core/models/user.dart';

class AuthServices {
  var userCollection = FirebaseFirestore.instance.collection('users');
  var savedUser = GetStorage().read('user');
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> signIn(String emailController, String passwordController) async {
    try {
      await auth.signInWithEmailAndPassword(email: emailController, password: passwordController);
      await saveUserInLocalStorage();
      return true;
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> signUp(String emailController, String passwordController, String name) async {
    try {
      await auth.createUserWithEmailAndPassword(email: emailController, password: passwordController);

      await saveUser(AppUser(uid: user!.uid, userName: name, email: emailController, role: 'user', ceiling: 0));
      await saveUserInLocalStorage();
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> resetPassword(String emailController) async {
    try {
      await auth.sendPasswordResetEmail(email: emailController);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  saveUser(AppUser user) async {
    try {
      await userCollection.doc(user.uid).set(user.Tojson());
      await userCollection.doc(user.uid).update({"income": 0, "expenses": 0});
    } catch (e) {}
  }

  User? get user => auth.currentUser;

  logout() {
    GetStorage().remove("auth");
    GetStorage().remove("user");
  }

  saveUserInLocalStorage() async {
    var storage = GetStorage();
    final uid = user!.uid;
    var currentUser = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    AppUser appUser = AppUser.fromJson(currentUser.data() as Map<String, dynamic>);
    await storage.write("user", {
      "uid": appUser.uid,
      "userName": appUser.userName,
      "Email": appUser.email,
      "role": appUser.role,
      "ceiling": appUser.ceiling,
    });

    storage.write("auth", 1);
  }
}
