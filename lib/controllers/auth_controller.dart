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

  //signup method

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


Future<void> signupMethod(
    String email, String password, BuildContext context) async {
  try {
    // Check if email is valid
    if (!isEmailValid(email)) {
      VxToast.show(context, msg: "Please enter a valid email address.");
      return;
    }

    // Check if password meets criteria (at least 8 characters, including uppercase, lowercase, and digit)
    if (!isPasswordValid(password)) {
      VxToast.show(context, msg: "Password must be at least 8 characters long and contain uppercase, lowercase, and digit.");
      return;
    }

    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    // No automatic login after signup, send email verification instead
    await _auth.currentUser!.sendEmailVerification();
    VxToast.show(context, msg: "Please check your email for verification.");
  } on FirebaseAuthException catch (e) {
    VxToast.show(context, msg: e.toString());
  }
}

// Function to check if password meets criteria
bool isPasswordValid(String password) {
  // Check if password is at least 8 characters long
  if (password.length < 8) {
    return false;
  }

  // Check if password contains at least one uppercase letter
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return false;
  }

  // Check if password contains at least one lowercase letter
  if (!password.contains(RegExp(r'[a-z]'))) {
    return false;
  }

  // Check if password contains at least one digit
  if (!password.contains(RegExp(r'[0-9]'))) {
    return false;
  }

  return true;
}

  // Function to check if email is valid using regex
  bool isEmailValid(String email) {
    // Regular expression for email validation
    // This regex pattern matches most common email formats, but you can adjust it as needed
    final RegExp regex = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        caseSensitive: false,
        multiLine: false);
    return regex.hasMatch(email);
  }





  //storing data of costumer method

// Validation function for phone number
bool isPhoneNumberValid(String phoneNumber) {
  // Regular expression to match valid Pakistani phone number formats
  final RegExp regex = RegExp(
    r'^\+92\d{10}$', // Match Pakistani phone numbers starting with +92 and followed by 10 digits
    caseSensitive: false,
    multiLine: false,
  );
  return regex.hasMatch(phoneNumber);
}

// Update storeuserData method with phone number validation
storeuserData({
  required BuildContext context, // Add BuildContext parameter
  name,
  password,
  email,
  type,
  phone,
  profileImageurl,
}) async {
  // Check if phone number is valid
  if (!isPhoneNumberValid(phone)) {
    // Display error message for invalid phone number
    VxToast.show(context, msg: "Please enter a valid Pakistani phone number.");
    return; // Optionally return or throw an error
  }

  // Rest of your code...
}

// Update storeTailorData method with phone number validation
storeTailorData(
    {required BuildContext context, // Add BuildContext parameter
    name,
    password,
    email,
    type,
    cnic,
    phone,
    latitude = 0.00,
    longitude = 0.00}) async {
  // Check if phone number is valid
  if (!isPhoneNumberValid(phone)) {
    // Display error message for invalid phone number
    VxToast.show(context, msg: "Please enter a valid Pakistani phone number.");
    return; // Optionally return or throw an error
  }

  // Rest of your code...
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
