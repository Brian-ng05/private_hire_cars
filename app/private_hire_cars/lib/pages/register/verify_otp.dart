import 'package:flutter/material.dart';
import 'package:private_hire_cars/services/auth/auth_services.dart';
import 'register.dart';

class RegisterVerifyOtpPage extends StatefulWidget {
  final String email;

  const RegisterVerifyOtpPage({super.key, required this.email});

  @override
  State<RegisterVerifyOtpPage> createState() => _RegisterVerifyOtpPageState();
}

class _RegisterVerifyOtpPageState extends State<RegisterVerifyOtpPage> {
  final controllers = List.generate(6, (_) => TextEditingController());
  bool loading = false;

  String get otp => controllers.map((e) => e.text).join();

  void verify() async {
    if (otp.length != 6) return;

    setState(() => loading = true);

    try {
      final res = await AuthService.verifyOtp(otp: otp, type: "EMAIL_VERIFY");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterPasswordPage(
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
            child: loading
                ? const CircularProgressIndicator()
                : const Text("Next"),
          ),
        ],
      ),
    );
  }
}
