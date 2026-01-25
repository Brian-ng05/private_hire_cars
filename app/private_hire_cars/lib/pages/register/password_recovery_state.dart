import 'package:flutter/material.dart';
import 'package:private_hire_cars/services/auth/auth_services.dart';
import 'verify_otp.dart';

class PasswordRecoveryState extends StatefulWidget {
  const PasswordRecoveryState({super.key});

  @override
  State<PasswordRecoveryState> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecoveryState> {
  // DECLARATION
  final controllerEmail = TextEditingController();
  bool loading = false;

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void next() async {
    final email = controllerEmail.text.trim();

    if (!emailRegex.hasMatch(email)) {
      showMsg("Invalid email format");
      return;
    }

    setState(() => loading = true);

    try {
      await AuthService.requestOtp(email: email, type: "PASSWORD_RESET");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RegisterVerifyOtpPage(email: email)),
      );
    } catch (e) {
      showMsg(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  void showMsg(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  // BUILD 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Enter your email",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: controllerEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: loading ? null : next,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
