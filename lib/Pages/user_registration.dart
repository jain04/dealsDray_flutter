import 'package:dealsdray/Pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  bool _passwordVisible = false;

  // Method to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If form is valid, you can submit it to your API
      String email = _emailController.text;
      String password = _passwordController.text;
      String referralCode = _referralController.text;

      // Here, you would make an API call to register the user
      // For demonstration, just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful! Email: $email')),
      );
      
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // This centers the whole screen content
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SVG Logo at the top
                SvgPicture.asset(
                  "assets/images/logoipsum-300.svg",  // Path to your SVG file in the assets
                  width: 140, // You can adjust the width and height as needed
                  height: 140,
                ),
                const SizedBox(height: 20), // Spacer between logo and text
                
                // Introductory Texts
                const Text(
                  "Let's Begin!",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8), // Spacer between texts
                const Text(
                  "Please enter your credentials",
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24), // Spacer between text and form

                // Form section
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email input
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA0-9]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Password input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Create a password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Referral Code input (optional)
                      TextFormField(
                        controller: _referralController,
                        decoration: const InputDecoration(
                          labelText: 'Referral Code (optional)',
                          hintText: 'Enter a referral code (optional)',
                          prefixIcon: Icon(Icons.code),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Register'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}