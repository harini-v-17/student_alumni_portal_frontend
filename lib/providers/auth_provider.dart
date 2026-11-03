import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// The role a logged-in user has in the portal.
enum UserRole { student, alumni }

/// Represents the currently authenticated user (local prototype only).
class AuthUser {
  final String name;
  final String email;
  final UserRole role;

  /// Relevant for alumni only.
  final String domain;
  final String designation;
  final String company;
  final String batch;

  const AuthUser({
    required this.name,
    required this.email,
    required this.role,
    this.domain = '',
    this.designation = '',
    this.company = '',
    this.batch = '',
  });
}

/// Manages authentication state for the prototype.
///
/// Demo credentials
/// ─────────────────
/// Student:  username = student   OR  student@university.edu
///           password = student123
///
/// Alumni:   username = alumni    OR  alumni@university.edu
///           password = alumni123
class AuthProvider extends ChangeNotifier {
  AuthUser? _currentUser;

  bool get isLoggedIn => _currentUser != null;
  AuthUser? get currentUser => _currentUser;

  // ─── Student Login ─────────────────────────────────────────────────────────

  /// Validates student credentials locally.
  /// Returns `null` on success, or an error message on failure.
  String? loginAsStudent(String identifier, String password) {
    if (identifier.trim().isEmpty || password.trim().isEmpty) {
      return 'Please fill in all fields.';
    }
    const validIds = ['student@university.edu', 'student'];
    if (validIds.contains(identifier.trim().toLowerCase()) &&
        password == 'student123') {
      _currentUser = const AuthUser(
        name: 'Rohan Mehta',
        email: 'student@university.edu',
        role: UserRole.student,
        batch: '2025',
      );
      notifyListeners();
      return null;
    }
    return 'Invalid credentials. Use  student / student123';
  }

  // ─── Alumni Login ──────────────────────────────────────────────────────────

  /// Validates alumni credentials locally.
  /// Returns `null` on success, or an error message on failure.
  String? loginAsAlumni(String identifier, String password) {
    final cleanId = identifier.trim().toLowerCase();
    final cleanPass = password.trim();

    if (cleanId.isEmpty || cleanPass.isEmpty) {
      return 'Please enter both username/email and password.';
    }

    // 1. Default demo alumni credentials
    const defaultIds = ['alumni@university.edu', 'alumni'];
    if (defaultIds.contains(cleanId)) {
      if (cleanPass == 'alumni123') {
        _currentUser = const AuthUser(
          name: 'Priya Nair',
          email: 'alumni@university.edu',
          role: UserRole.alumni,
          domain: 'Full Stack Development',
          designation: 'Senior Software Engineer',
          company: 'Microsoft',
          batch: '2020',
        );
        notifyListeners();
        return null;
      } else {
        return 'Incorrect password. Demo password is alumni123';
      }
    }

    // 2. Allow login for any registered alumni in the portal sample directory
    for (final alumni in kSampleAlumni) {
      final email = alumni.email.toLowerCase();
      final username = email.split('@').first.toLowerCase();
      final name = alumni.name.toLowerCase();

      if (cleanId == email || cleanId == username || cleanId == name) {
        if (cleanPass == 'alumni123') {
          _currentUser = AuthUser(
            name: alumni.name,
            email: alumni.email,
            role: UserRole.alumni,
            domain: alumni.domain,
            designation: alumni.designation,
            company: alumni.company,
            batch: alumni.batch,
          );
          notifyListeners();
          return null;
        } else {
          return 'Incorrect password for ${alumni.name}. Use alumni123';
        }
      }
    }

    return 'Invalid credentials. Use alumni / alumni123 or registered alumni email.';
  }

  // ─── Profile Update ───────────────────────────────────────────────────────

  /// Updates alumni profile details and notifies listeners.
  void updateAlumniProfile({
    String? name,
    String? domain,
    String? designation,
    String? company,
    String? batch,
    String? email,
  }) {
    if (_currentUser != null && _currentUser!.role == UserRole.alumni) {
      _currentUser = AuthUser(
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        role: UserRole.alumni,
        domain: domain ?? _currentUser!.domain,
        designation: designation ?? _currentUser!.designation,
        company: company ?? _currentUser!.company,
        batch: batch ?? _currentUser!.batch,
      );
      notifyListeners();
    }
  }

  // ─── Logout ────────────────────────────────────────────────────────────────

  /// Dedicated Alumni Logout that resets only alumni authentication sessions.
  void logoutAlumni() {
    if (_currentUser?.role == UserRole.alumni) {
      _currentUser = null;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
