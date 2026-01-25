import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:private_hire_cars/pages/register/request_otp.dart';
import 'package:private_hire_cars/pages/widget_tree.dart';
import 'package:private_hire_cars/services/auth/auth_services.dart';
import 'package:private_hire_cars/services/storage_service.dart';
import 'package:private_hire_cars/pages/register/password_recovery_state.dart';

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
          child: 
          Column(
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
                  backgroundColor: Colors.green
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
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterEmailPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "Password Recovery",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                  ..onTap = (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PasswordRecoveryState(),
                        ),
                      );
                  }
                ),
              ), 
            ],
          ),
        ),
      ),
    );
  }

  void onLoginPressed() async {
    final email = controllerEmail.text.trim();
    final password = controllerPw.text;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?#&])[A-Za-z\d@$!%*?#&]{8,}$',
    );

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password are required")),
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid email format")));
      return;
    }

    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password must be 8+ chars, include upper, lower, number & special char",
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await AuthService.login(email, password);

      await StorageService.saveUser(response);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
