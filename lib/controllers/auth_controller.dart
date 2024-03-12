import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/First_screen/first_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';
//import '../view/home_screen/home.dart';

class AuthController extends GetxController {
  var isloading = false.obs;

//text controllers

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  //login method

  Future<UserCredential?> loginMethod(
    context,
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //signup method

  Future<UserCredential?> signupMethod(email, password, context) async {
    UserCredential? userCredential;
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //storing data od costumer method

  storeuserData({
    name,
    password,
    email,
    type,
    phone,
    profileImageurl,
  }) async {
    DocumentReference store =
        firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'ProfileImageurl': profileImageurl,
      'id': currentUser!.uid,
      'type': type,
      'phone': phone,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

//from map
//to map

  storeTailorData(
      {name,
      password,
      email,
      type,
      cnic,
      phone,
      latitude = 0.00,
      longitude = 0.00}) async {
    DocumentReference store =
        firestore.collection(usersCollection1).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'ProfileImageurl': ' ',
      'id': currentUser!.uid,
      'type': type,
      'Phone': phone,
      'CNIC': cnic,
      'timestamp': FieldValue.serverTimestamp(),
      'longitude': longitude,
      'latitude': latitude
    });
  }

  //signout method

  signoutmethod(context, u_type) async {
    try {
      await auth.signOut();
      Get.offAll(() => const SplashScreen());
      // if (u_type == "Customer") {
      //   Get.offAll(LoginScreen(type: u_type));
      // } else {
      //   Get.offAll(LoginScreen_Tailor(type: u_type));
      // }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
