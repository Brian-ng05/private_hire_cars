import 'package:flutter/material.dart';
import 'package:private_hire_cars/pages/recovery_password_page.dart';
import 'package:private_hire_cars/services/auth/auth_services.dart';
import '../register.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  final String type;

  const VerifyOtpPage({super.key, required this.email, required this.type});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final controllers = List.generate(6, (_) => TextEditingController());
  bool loading = false;

  String get otp => controllers.map((e) => e.text).join();

  void verify() async {
    if (otp.length != 6) return;

    setState(() => loading = true);

    try {
      final res = await AuthService.verifyOtp(otp: otp, type: widget.type);

      widget.type == "EMAIL_VERIFY"
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RegisterPasswordPage(
                  email: widget.email,
                  verificationId: res.detailed.verificationId,
                ),
              ),
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PasswordRecoveryPage(
                  email: widget.email,
                  verificationId: res.detailed.verificationId,
                ),
              ),
            );
    } catch (e) {
      showMsg(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  void showMsg(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Widget buildBox(int i) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: controllers[i],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: (v) {
          if (v.isNotEmpty && i < 5) FocusScope.of(context).nextFocus();
        },
        decoration: const InputDecoration(counterText: ""),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Enter verification code",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, buildBox),
          ),

          const SizedBox(height: 30),

          FilledButton(
            onPressed: loading ? null : verify,
            style: FilledButton.styleFrom(backgroundColor: Colors.black),
            child: loading
                ? const CircularProgressIndicator()
                : const Text("Next"),
          ),
        ],
      ),
    );
  }
}
