import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  File? _image;

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;

  Future<void> _pickImage() async {
    _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (_pickedFile != null && mounted) {
      setState(() {
        _image = File(_pickedFile!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFB7CBDD),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : NetworkImage(
                            FirebaseAuth.instance.currentUser?.photoURL ??
                                'https://i.pravatar.cc/300',
                          ) as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _pickImage,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Edit picture'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Nachname', lastNameController),
            _buildTextField('Vorname', firstNameController),
            _buildTextField('Bio', bioController),
            _buildTextField('Studiengang', courseController),
            _buildTextField('Universität', universityController),
            _buildTextField('Links', linkController),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
