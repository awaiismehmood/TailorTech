//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/view/splash_screen/splash_screen.dart';
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

      log('Authentication successful: ${userCredential}');
      log('login successful');
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

  storeuserData(
      {name,
      password,
      email,
      type,
      phone,
      latitude = "",
      longitude = ""}) async {
    DocumentReference store =
        firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'ProfileImageurl': '',
      'id': currentUser!.uid,
      'type': type,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
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
      latitude = " ",
      longitude = " "}) async {
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
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  //signout method

  signoutmethod(context, u_type) async {
    try {
      await auth.signOut();
      Get.offAll(SplashScreen());
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
