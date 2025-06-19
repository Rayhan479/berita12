import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;
  final picker = ImagePicker();

  final nameController = TextEditingController(text: 'Berita12');
  final emailController = TextEditingController(text: 'berita12@gmail.com');
  final passwordController = TextEditingController(text: '********');

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    // Simulasi penyimpanan
    debugPrint("Saved: $name, $email, $password");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated!")),
    );

    // Kirim data kembali ke halaman profile
    Navigator.pop(context, {
      'name': name,
      'email': email,
      'password': password,
      'image': _imageFile,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF1E73BE),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text(
                        'Tambah Foto',
                        style: TextStyle(
                          color: Color(0xFF1E73BE),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(controller: nameController, hint: 'Nama'),
              const SizedBox(height: 12),
              _buildTextField(controller: emailController, hint: 'Email'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: passwordController,
                hint: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E73BE),
                    foregroundColor: Colors.white, // Warna teks jadi putih
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveProfile,
                  child: const Text('Save', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[300],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF1E73BE),
      onPressed: () {},
      child: const Icon(Icons.add, size: 32),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: const Color(0xFF1E73BE),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 48),
          IconButton(
            icon: const Icon(Icons.poll, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
