import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iptv_app/features/home/drawer/user_details_provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dateOfBirthController;
  String _selectedGender = '';

  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    _usernameController = TextEditingController(text: userDetailsProvider.username);
    _nameController = TextEditingController(text: userDetailsProvider.name);
    _emailController = TextEditingController(text: userDetailsProvider.email);
    _phoneController = TextEditingController(text: userDetailsProvider.phone);
    _dateOfBirthController = TextEditingController(text: userDetailsProvider.dateOfBirth);
    _selectedGender = userDetailsProvider.gender;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Dark theme for the date picker
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _dateOfBirthController.text = '${pickedDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white), // Ensuring text is white
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white), // Make sure the icon is white
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                userDetailsProvider.updateUserDetails(
                  username: _usernameController.text,
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  profilePicture: _profileImage?.path ?? userDetailsProvider.profilePicture,
                  dateOfBirth: _dateOfBirthController.text,
                  gender: _selectedGender,
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(File(_profileImage!.path))
                      : userDetailsProvider.profilePicture.isNotEmpty
                      ? NetworkImage(userDetailsProvider.profilePicture) as ImageProvider
                      : null,
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt, size: 30, color: Colors.white70)
                      : null,
                  backgroundColor: Colors.grey[800], // Dark background
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(_usernameController, 'Username'),
              SizedBox(height: 16),
              _buildTextField(_nameController, 'Full Name'),
              SizedBox(height: 16),
              _buildTextField(_emailController, 'Email', email: true),
              SizedBox(height: 16),
              _buildTextField(_phoneController, 'Phone', phone: true),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateOfBirthController,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender.isNotEmpty ? _selectedGender : null,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(),
                ),
                dropdownColor: Colors.grey[900],
                style: TextStyle(color: Colors.white),
                items: <String>['Male', 'Female', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black, // Set the background to dark
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool email = false, bool phone = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (email && !value.contains('@')) {
          return 'Enter a valid email';
        }
        return null;
      },
      keyboardType: email
          ? TextInputType.emailAddress
          : phone
          ? TextInputType.phone
          : TextInputType.text,
      textInputAction: TextInputAction.next,
    );
  }
}
