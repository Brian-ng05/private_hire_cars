import 'package:flutter/material.dart';
import 'package:private_hire_cars/pages/login_page.dart';
import 'package:private_hire_cars/services/auth/auth_services.dart';

class PasswordRecoveryPage extends StatefulWidget {
  final String email;
  final int verificationId;

  const PasswordRecoveryPage({
    super.key,
    required this.email,
    required this.verificationId,
  });

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final pw = TextEditingController();
  final confirm = TextEditingController();

  bool loading = false;

  final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?#&]).{8,}$',
  );

  void resetPassword() async {
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
      await AuthService.resetPassword(
        verificationId: widget.verificationId,
        password: pw.text,
        passwordConfirm: confirm.text,
      );

      if (!mounted) return;

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
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  void showMsg(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f9),
      appBar: AppBar(backgroundColor: Color(0xfff6f7f9)),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: confirm,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.black,
                ),
                onPressed: loading ? null : resetPassword,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
