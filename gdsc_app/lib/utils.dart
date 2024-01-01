import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map<String, String>?> getHeaders() async {
  String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
  if (idToken != null) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': idToken,
    };
  } else {
    return null;
  }
}

Future<String?> userSignedIn() async {
  String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken(true);
  if (idToken != null) {
    return idToken;
  } else {
    return null;
  }
}

