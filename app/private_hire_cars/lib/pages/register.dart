import 'package:flutter/material.dart';
import 'package:private_hire_cars/pages/login_page.dart';
import 'package:private_hire_cars/services/auth/auth_services.dart';

class RegisterPasswordPage extends StatefulWidget {
  final String email;
  final int verificationId;

  const RegisterPasswordPage({
    super.key,
    required this.email,
    required this.verificationId,
  });

  @override
  State<RegisterPasswordPage> createState() => _RegisterPasswordPageState();
}

class _RegisterPasswordPageState extends State<RegisterPasswordPage> {
  final pw = TextEditingController();
  final confirm = TextEditingController();

  bool loading = false;

  final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?#&]).{8,}$',
  );

  void createAccount() async {
    if (!passwordRegex.hasMatch(pw.text)) {
      showMsg("Weak password");
      return;
    }

    if (pw.text != confirm.text) {
      showMsg("Password mismatch");
      return;
    }

    setState(() => loading = true);

    try {
      await AuthService.createAccount(
        verificationId: widget.verificationId,
        email: widget.email,
        password: pw.text,
        passwordConfirm: confirm.text,
      );

      showMsg("Account created successfully");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(title: "Private Hire Cars"),
        ),
        (_) => false,
      );
    } catch (e) {
      showMsg(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  void showMsg(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f9),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Create your password",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: pw,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: confirm,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: loading ? null : createAccount,
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
