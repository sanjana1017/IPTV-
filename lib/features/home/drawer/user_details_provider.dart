import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsProvider extends ChangeNotifier {
  // Private variables for user details
  String _username = '';
  String _name = '';
  String _phone = '';
  String _email = '';
  String _gender = '';
  String _dateOfBirth = '';
  String _profilePicture = '';

  // Getters for accessing private variables
  String get username => _username;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get gender => _gender;
  String get dateOfBirth => _dateOfBirth;
  String get profilePicture => _profilePicture;

  // Fetch user details from SharedPreferences
  Future<void> getUserDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username') ?? '';
      _name = prefs.getString('name') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _email = prefs.getString('email') ?? '';
      _gender = prefs.getString('gender') ?? '';
      _dateOfBirth = prefs.getString('dateOfBirth') ?? '';
      _profilePicture = prefs.getString('profilePicture') ?? '';
    } catch (e) {
      debugPrint('Error fetching user details: $e');
    }
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Update user details and save them to SharedPreferences
  Future<void> updateUserDetails({
    required String username,
    required String name,
    required String phone,
    required String email,
    required String gender,
    required String dateOfBirth,
    String? profilePicture, // Profile picture is optional
  }) async {
    _username = username;
    _name = name;
    _phone = phone;
    _email = email;
    _gender = gender;
    _dateOfBirth = dateOfBirth;
    _profilePicture = profilePicture ?? ''; // Use empty string if null

    notifyListeners(); // Notify listeners of changes
    await _saveToPreferences();
  }

  // Save updated details to SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _username);
      await prefs.setString('name', _name);
      await prefs.setString('phone', _phone);
      await prefs.setString('email', _email);
      await prefs.setString('gender', _gender);
      await prefs.setString('dateOfBirth', _dateOfBirth);
      await prefs.setString('profilePicture', _profilePicture);
    } catch (e) {
      debugPrint('Error saving user details: $e');
    }
  }

  // Clear user data from SharedPreferences (for logout functionality)
  Future<void> clearUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('name');
      await prefs.remove('phone');
      await prefs.remove('email');
      await prefs.remove('gender');
      await prefs.remove('dateOfBirth');
      await prefs.remove('profilePicture');

      // Clear the in-memory user details
      _username = '';
      _name = '';
      _phone = '';
      _email = '';
      _gender = '';
      _dateOfBirth = '';
      _profilePicture = '';

      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }
}
