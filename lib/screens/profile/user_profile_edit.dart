import 'dart:io';
import 'package:eventure/widgets/inputs/custom_input_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:eventure/providers/user_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController lastNameController;
  late TextEditingController firstNameController;
  late TextEditingController descriptionController;
  late TextEditingController studyCourseController;
  late TextEditingController uniController;
  late TextEditingController socialMediaLinksController;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    lastNameController = TextEditingController(text: user.lastName);
    firstNameController = TextEditingController(text: user.firstName);
    descriptionController = TextEditingController(text: user.description);
    studyCourseController = TextEditingController(text: user.studyCourse);
    uniController = TextEditingController(text: user.uni);
    socialMediaLinksController = TextEditingController(
      text: user.socialMediaLinks?.join(', ') ?? '',
    );
  }

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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  final user = userProvider.users
                      .firstWhere((user) => user.id == userProvider.user.id);
                  userProvider.updateUser(user.copyWith(
                    lastName: lastNameController.text,
                    firstName: firstNameController.text,
                    description: descriptionController.text,
                    studyCourse: studyCourseController.text,
                    uni: uniController.text,
                    socialMediaLinks: socialMediaLinksController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList(),
                  ));
                  Navigator.pop(context);
                },
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
                _buildTextField('Vorname', firstNameController),
                _buildTextField('Nachname', lastNameController),
                _buildTextField('Bio', descriptionController),
                _buildTextField('Studiengang', studyCourseController),
                _buildTextField('Universität', uniController),
                _buildTextField('Links', socialMediaLinksController),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: CustomInputLine(
        label: label,
        initValue: controller.text,
        required: false,
        editable: true,
        onChanged: (value) {
          controller.text = value;
        },
      ),
    );
  }
}
