import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';
import 'registration_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to focus nodes
    for (int i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (int i = 0; i < 6; i++) {
      _otpControllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  void _verifyOTP() {
    // Combine all OTP digits
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length == 6) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Check if user exists (dummy check - in real app would be API call)
        bool isExistingUser = widget.phoneNumber.endsWith(
          '1',
        ); // Dummy logic for demo

        if (isExistingUser) {
          // Navigate to home screen for existing users
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        } else {
          // Navigate to registration screen for new users
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RegistrationScreen(phoneNumber: widget.phoneNumber),
            ),
            (route) => false,
          );
        }
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Verify OTP',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phone number display
              Text(
                'OTP sent to +91 ${widget.phoneNumber}',
                style: TextStyle(fontSize: 16, color: AppColors.greyText),
              ),
              SizedBox(height: 32),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => _buildOTPDigitField(index),
                ),
              ),
              SizedBox(height: 32),

              // Resend OTP
              Center(
                child: TextButton(
                  onPressed: () {
                    // Resend OTP logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('OTP resent successfully!')),
                    );
                  },
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Spacer(),

              // Verify Button
              CustomButton(
                text: 'Verify & Proceed',
                isLoading: _isLoading,
                onPressed: _verifyOTP,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPDigitField(int index) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? AppColors.primaryGreen
              : AppColors.lightGreen.withOpacity(0.5),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
        color: _focusNodes[index].hasFocus
            ? AppColors.lightGreen.withOpacity(0.1)
            : Colors.white,
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(border: InputBorder.none, counterText: ''),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
        },
      ),
    );
  }
}
