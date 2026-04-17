import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// The User Model
class User {
  final String id;
  final String email;
  final String name;
  final bool hasCompletedOnboarding;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.hasCompletedOnboarding = false,
  });

  // Helper to convert JSON string from Storage to Dart Object
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    hasCompletedOnboarding: json['hasCompletedOnboarding'] ?? false,
  );

  // Helper to convert Dart Object to JSON for Storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'hasCompletedOnboarding': hasCompletedOnboarding,
  };
}

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  Future<List<dynamic>> _loadUsers(SharedPreferences prefs) async {
    final rawUsers = prefs.getString('users');
    if (rawUsers == null || rawUsers.isEmpty) {
      return [];
    }

    try {
      final parsed = jsonDecode(rawUsers);
      return parsed is List ? parsed : [];
    } catch (_) {
      return [];
    }
  }

  // Equivalent to your useEffect hook
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _loadUsers(prefs);

    if (users.isEmpty) {
      final demoUser = {
        'id': 'demo-1',
        'name': 'Demo Designer',
        'email': 'demo@designer.ai',
        'password': 'demo123',
        'hasCompletedOnboarding': false,
      };
      users.add(demoUser);
      await prefs.setString('users', jsonEncode(users));
    }

    // Check for existing session
    final String? savedUser = prefs.getString('currentUser');
    if (savedUser != null) {
      _user = User.fromJson(jsonDecode(savedUser));
    }

    _isLoading = false;
    notifyListeners(); // Tells the UI to rebuild
  }

  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final List<dynamic> users = await _loadUsers(prefs);

    final userMap = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => throw Exception('Invalid credentials'),
    );

    _user = User.fromJson(userMap);
    await prefs.setString('currentUser', jsonEncode(_user!.toJson()));
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final List<dynamic> users = await _loadUsers(prefs);

    if (users.any((u) => u['email'] == email)) {
      throw Exception('User already exists');
    }

    final newUserMap = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'password': password,
      'hasCompletedOnboarding': false,
    };

    users.add(newUserMap);
    await prefs.setString('users', jsonEncode(users));

    _user = User.fromJson(newUserMap);
    await prefs.setString('currentUser', jsonEncode(_user!.toJson()));
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    _user = null;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    if (_user == null) return;

    final prefs = await SharedPreferences.getInstance();

    // Update local state
    _user = User(
      id: _user!.id,
      name: _user!.name,
      email: _user!.email,
      hasCompletedOnboarding: true,
    );

    // Persist session
    await prefs.setString('currentUser', jsonEncode(_user!.toJson()));

    // Update in "database" (the users list)
    final List<dynamic> users = jsonDecode(prefs.getString('users') ?? '[]');
    final updatedUsers = users.map((u) {
      if (u['id'] == _user!.id) {
        return {...u, 'hasCompletedOnboarding': true};
      }
      return u;
    }).toList();

    await prefs.setString('users', jsonEncode(updatedUsers));
    notifyListeners();
  }
}
