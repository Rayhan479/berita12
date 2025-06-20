import 'package:flutter/material.dart';
import 'login_page.dart'; // Pastikan file ini ada
import 'package:berita12/services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();
  final _apiservice = ApiService();
  final FocusNode _namaFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _konfirmasiFocus = FocusNode();
  //bool _isLoading= false;

  void register() async {
    if (_namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Harus di isi semua")));
      return;
    }
    /*setState(() {
      _isLoading = true;
    });*/
    try {
      await _apiservice.register(
        name: _namaController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      /*setState(() {
        _isLoading = false;
      });*/
      if (!mounted) return;
      _showSuccessDialog(); // <-- TAMBAHKAN INI DI SINI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Registrasi Berhasil!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registrasi Gagal : $e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _namaFocus.addListener(() => setState(() {}));
    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
    _konfirmasiFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();

    _namaFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _konfirmasiFocus.dispose();

    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Registrasi Berhasil!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Akun Kamu Sudah dibuat,\nsilahkan login untuk mulai membaca berita',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2471B7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text('Masuk', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      register(); // <--- ini yang harus dipanggil
    }
  }

  @override
  Widget build(BuildContext context) {
    // const blueColor = Color(0xFF1976D2);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Decorative circle
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.05 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    const Center(
                      child: Text(
                        'Daftar Akun\nBaru',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Nama Lengkap
                    const _FieldLabel(label: 'Nama Lengkap'),
                    _buildTextField(
                      controller: _namaController,
                      focusNode: _namaFocus,
                      icon: Icons.person,
                      hint: 'Masukkan Nama Lengkap',
                      validatorMsg: 'Nama harus diisi',
                    ),

                    const SizedBox(height: 18),

                    // Email
                    const _FieldLabel(label: 'Email'),
                    _buildTextField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      icon: Icons.email,
                      hint: 'Masukkan Email',
                      validatorMsg: 'Email harus diisi',
                    ),

                    const SizedBox(height: 18),

                    // Password
                    const _FieldLabel(label: 'Password'),
                    _buildTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      icon: Icons.lock,
                      hint: 'Masukkan Password',
                      validatorMsg: 'Password harus diisi',
                      obscure: true,
                    ),

                    const SizedBox(height: 18),

                    // Konfirmasi Password
                    const _FieldLabel(label: 'Konfirmasi Password'),
                    _buildTextField(
                      controller: _konfirmasiPasswordController,
                      focusNode: _konfirmasiFocus,
                      icon: Icons.lock_outline,
                      hint: 'Masukkan Konfirmasi Password',
                      validatorMsg: 'Konfirmasi Password harus diisi',
                      obscure: true,
                      confirmPassword: _passwordController.text,
                    ),

                    const SizedBox(height: 30),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sudah Punya Akun?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Masuk',
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required String hint,
    required String validatorMsg,
    bool obscure = false,
    String? confirmPassword,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: focusNode.hasFocus ? '' : hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMsg;
        }
        if (confirmPassword != null && value != confirmPassword) {
          return 'Password tidak cocok';
        }
        return null;
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('*', style: TextStyle(color: Colors.red, fontSize: 20)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
