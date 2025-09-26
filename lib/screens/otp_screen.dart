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

class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  int _resendTimer = 30;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0.0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animations
    _animationController.forward();

    // Add listeners to focus nodes
    for (int i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        setState(() {});
      });
    }

    // Start resend timer
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        if (mounted) {
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
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Please enter complete 6-digit OTP'),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  void _resendOTP() {
    if (_resendTimer == 0) {
      setState(() {
        _resendTimer = 30;
      });
      _startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('OTP resent successfully!'),
            ],
          ),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryGreen,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Verify OTP',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Section with Icon and Info
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        // OTP Icon with Animation
                        Container(
                          height: isSmallScreen ? 80 : 100,
                          width: isSmallScreen ? 80 : 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryGreen,
                                AppColors.primaryGreen.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGreen.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.security_rounded,
                            color: Colors.white,
                            size: isSmallScreen ? 40 : 50,
                          ),
                        ),

                        SizedBox(height: 24),

                        // Title and Description
                        Text(
                          'Verification Code',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 24 : 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(height: 12),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.greyText,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: 'We have sent a verification code to\n',
                              ),
                              TextSpan(
                                text: '+91 ${widget.phoneNumber}',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 30 : 40),

                  // OTP Input Fields Section
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.lightGreen.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Enter 6-digit code',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),

                        SizedBox(height: 20),

                        // OTP Input Fields with Enhanced Design
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            6,
                            (index) => _buildOTPDigitField(index),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 30 : 40),

                  // Resend OTP Section
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Didn\'t receive code?',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.greyText,
                              ),
                            ),
                            if (_resendTimer > 0)
                              Text(
                                'Resend in ${_resendTimer}s',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyText.withOpacity(0.7),
                                ),
                              ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: _resendTimer == 0 ? _resendOTP : null,
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: _resendTimer == 0
                                ? AppColors.primaryGreen
                                : AppColors.greyText,
                            size: 18,
                          ),
                          label: Text(
                            'Resend',
                            style: TextStyle(
                              color: _resendTimer == 0
                                  ? AppColors.primaryGreen
                                  : AppColors.greyText,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 40 : 60),

                  // Enhanced Verify Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryGreen,
                          AppColors.primaryGreen.withOpacity(0.9),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 3,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _isLoading ? null : _verifyOTP,
                        child: Container(
                          alignment: Alignment.center,
                          child: _isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Text(
                                      'Verifying...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.verified_user_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Verify & Proceed',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPDigitField(int index) {
    bool isFocused = _focusNodes[index].hasFocus;
    bool hasValue = _otpControllers[index].text.isNotEmpty;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: isFocused
            ? AppColors.primaryGreen.withOpacity(0.1)
            : hasValue
            ? AppColors.lightGreen.withOpacity(0.1)
            : Colors.white,
        border: Border.all(
          color: isFocused
              ? AppColors.primaryGreen
              : hasValue
              ? AppColors.primaryGreen.withOpacity(0.5)
              : AppColors.lightGreen.withOpacity(0.3),
          width: isFocused ? 2.5 : 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isFocused || hasValue
            ? [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: hasValue ? AppColors.primaryGreen : Colors.black87,
        ),
        decoration: InputDecoration(border: InputBorder.none, counterText: ''),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }
}
