import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
Future<Map<String, String>> getHeaders() async {
  String idToken = await FirebaseAuth.instance.currentUser.getIdToken();
  return {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': idToken
  };
}