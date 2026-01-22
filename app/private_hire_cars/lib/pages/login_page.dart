import 'package:flutter/material.dart';
import 'package:private_hire_cars/pages/widget_tree.dart';
import 'package:private_hire_cars/services/auth/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerEmail = TextEditingController(
    text: "test@gmail.com",
  );
  final TextEditingController controllerPw = TextEditingController(
    text: "Test123@",
  );

  bool isLoading = false;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Email:"),
              TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter Your Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Text("Password:"),
              TextField(
                controller: controllerPw,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: isLoading ? null : onLoginPressed,
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text("Login"),
              ),

              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  void onLoginPressed() async {
    final email = controllerEmail.text.trim();
    final password = controllerPw.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password are required")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await AuthService.login(email, password);

      debugPrint("API RESPONSE: $res");

      if (res['status'] == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WidgetTree()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message']?.toString() ?? "Login failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }
}
