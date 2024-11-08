import 'package:dealsdray/Pages/user_registration.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class OtpVerificationScreen extends StatefulWidget {
  final String userId;
  final String deviceId;
  const OtpVerificationScreen({super.key,required this.userId,required this.deviceId});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  bool _isResendAvailable = false;
  Timer? _resendTimer;
  int _resendSeconds = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  // Method to start the resend OTP timer
  void _startResendTimer() {
    setState(() {
      _isResendAvailable = false;
      _resendSeconds = 30;
    });
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        setState(() {
          _isResendAvailable = true;
        });
        timer.cancel();
      }
    });
  }

  // Method to verify OTP
  Future<void> _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      String otp = _otpControllers.map((controller) => controller.text).join();

      Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserRegistrationScreen(),
              ),
            );


    

      
    }
  }

  // Method to handle resend OTP
  void _resendOTP() {
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent')),
    );

    // Call your OTP resend API here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('OTP Verification'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock, // Lock icon represents OTP security
                        size: 50, // Adjust size as needed
                        color: Colors.blue, // Customize color as desired
                      ),
                      
                      const SizedBox(height: 8),
                      const Text(
                        "Enter the 4-digit OTP",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // OTP Boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return SizedBox(
                            width: 50,
                            child: TextFormField(
                              controller: _otpControllers[index],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                counterText: "",
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 24),

                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _verifyOTP,
                          child: const Text('Verify'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Resend OTP Button with countdown
                      TextButton(
                        onPressed: _isResendAvailable ? _resendOTP : null,
                        child: Text(
                          _isResendAvailable
                              ? 'Resend OTP'
                              : 'Resend OTP in $_resendSeconds seconds',
                          style: TextStyle(
                            color:
                                _isResendAvailable ? Colors.blue : Colors.grey,
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
