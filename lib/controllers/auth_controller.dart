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

// Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //login method

  // Future<UserCredential?> loginMethod(
  //   context,
  // ) async {
  //   UserCredential? userCredential;
  //   try {
  //     userCredential = await auth.signInWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //   } on FirebaseAuthException catch (e) {
  //     VxToast.show(context, msg: e.toString());
  //   }
  //   return userCredential;
  // }

    Future<UserCredential?> loginMethod(context) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (userCredential != null && !userCredential.user!.emailVerified) {
        // If email is not verified, sign out the user and show a message
        await _auth.signOut();
        VxToast.show(context, msg: "Please verify your email before logging in.");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }







  // signup method

  // Future<UserCredential?> signupMethod(email, password, context) async {
  //   UserCredential? userCredential;
  //   try {
  //     await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     VxToast.show(context, msg: e.toString());
  //   }
  //   return userCredential;
  // }


Future<UserCredential?> signupMethod(email, password, context) async {
  try {
    // Email validation
    if (!isValidEmail(email)) {
      throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is not valid.');
    }

    // Password validation
    if (password.length < 8) {
      throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must be at least 8 characters.');
    }

    // Check for at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must contain at least one uppercase letter.');
    }

    // Check for at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must contain at least one lowercase letter.');
    }

    // Check for at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must contain at least one digit.');
    }


    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // Send email verification
    await userCredential.user!.sendEmailVerification();

    return userCredential;
  } on FirebaseAuthException catch (e) {
    VxToast.show(context, msg: e.message ?? 'An error occurred');
    return null;
  }
}

// Email validation function
bool isValidEmail(String email) {
  RegExp emailRegExp =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegExp.hasMatch(email);
}









  //storing data od costumer method

  storeuserData({
    required BuildContext context,
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
      {
      required BuildContext context,  
      name,
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