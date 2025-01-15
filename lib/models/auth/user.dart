import 'package:gtco_smart_invoice_flutter/models/auth/auth_dtos.dart';

import '../company.dart';

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? location;
  final int onboardingStep;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Company? company;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.location,
    required this.onboardingStep,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      onboardingStep: json['onboardingStep'] as int,
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      company: json['company'] != null
          ? Company.fromJson(json['company'] as Map<String, dynamic>)
          : null,
    );
  }

  // Add this factory constructor to create a User from a SignupUser
  factory User.fromSignUpUser(SignupUser signupUser) {
    return User(
      id: signupUser.id,
      email: signupUser.email,
      firstName: '', // Empty string for firstName
      lastName: '', // Empty string for lastName
      phoneNumber: null, // Null for phoneNumber
      location: null, // Null for location
      onboardingStep: 0, // Default onboarding step
      onboardingCompleted: false, // Default onboarding status
      createdAt: DateTime.now(), // Current time for createdAt
      updatedAt: DateTime.now(), // Current time for updatedAt
      company: null, // Null for company
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'location': location,
        'onboardingStep': onboardingStep,
        'onboardingCompleted': onboardingCompleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'company': company?.toJson(),
      };
}