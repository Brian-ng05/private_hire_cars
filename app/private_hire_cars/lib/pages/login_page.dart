import 'package:flutter/material.dart';
import 'package:private_hire_cars/pages/otp/request_otp.dart';
import 'package:private_hire_cars/pages/widget_tree.dart';
import 'package:private_hire_cars/services/auth/auth_services.dart';
import 'package:private_hire_cars/services/storage_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerEmail = TextEditingController(text: "test@gmail.com");
  final controllerPw = TextEditingController(text: "Test123@");

  bool isLoading = false;
  bool obscurePw = true;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Private Hire Cars"), centerTitle: true),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              /// EMAIL
              TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 16),

              /// PASSWORD
              TextField(
                controller: controllerPw,
                obscureText: obscurePw,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onLoginPressed(),
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePw ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => obscurePw = !obscurePw),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// LOGIN BUTTON
              FilledButton(
                onPressed: isLoading ? null : onLoginPressed,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Login"),
              ),

              const SizedBox(height: 20),

              /// SIGN UP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RequestOtpPage(type: "EMAIL_VERIFY"),
                        ),
                      );
                    },
                    child: const Text("Sign up"),
                  ),
                ],
              ),

              /// RESET
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const RequestOtpPage(type: "PASSWORD_RESET"),
                    ),
                  );
                },
                child: const Text("Forgot password?"),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ================= LOGIN =================
  Future<void> onLoginPressed() async {
    final email = controllerEmail.text.trim();
    final password = controllerPw.text;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?#&])[A-Za-z\d@$!%*?#&]{8,}$',
    );

    if (email.isEmpty || password.isEmpty) {
      showSnack("Email and password are required");
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      showSnack("Invalid email format");
      return;
    }

    if (!passwordRegex.hasMatch(password)) {
      showSnack("Password must be strong");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await AuthService.login(email, password);
      await StorageService.saveUser(response);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );
    } catch (e) {
      showSnack(e.toString());
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
