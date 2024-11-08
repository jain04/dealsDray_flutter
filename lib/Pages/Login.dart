import 'dart:async';
import 'dart:io';
import 'package:dealsdray/Pages/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String? deviceId;

  // Fetch the device ID
  Future<void> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
      print("Device ID: $deviceId");
      setState(() {}); // Trigger rebuild to update deviceId
    } catch (e) {
      print("Failed to get device ID: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getDeviceId();
  }

  // Function to send OTP
  Future<void> _sendOTP() async {
    final phoneNumber = _phoneController.text.trim();

    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'mobileNumber': phoneNumber,
        'deviceId': deviceId,
      });

      try {
        final response = await http
            .post(url, headers: headers, body: body)
            .timeout(Duration(seconds: 10));

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData['status'] == 1) {
            final userId = responseData['data']['userId'];
            final deviceId = responseData['data']['deviceId'];
            print('Success: ${responseData['data']['message']}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                  userId: userId,
                  deviceId: deviceId,
                ),
              ),
            );
          } else {
            print('Error: ${responseData['data']['message']}');
          }
        } else {
          print('Failed to send OTP. Please try again.');
        }
      } on SocketException {
        print('Network error. Please check your connection.');
      } on TimeoutException {
        print('Request timed out. Please try again.');
      } catch (e) {
        print('An error occurred: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/logoipsum-300.svg", 
                  width: 140,
                  height: 140,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Glad to see you!",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please provide your phone number.",
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24), 
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter your phone number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _sendOTP,
                          child: const Text('Send Code'),
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
