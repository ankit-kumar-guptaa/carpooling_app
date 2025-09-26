import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_button.dart';
import '../utils/colors.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        child: Column(
          children: [
            // Top Section with Background and Logo
            Container(
              height: isSmallScreen ? screenHeight * 0.42 : screenHeight * 0.45,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen,
                    AppColors.primaryGreen.withOpacity(0.9),
                    AppColors.lightGreen.withOpacity(0.7),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/city_background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColors.primaryGreen.withOpacity(0.75),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.transparent,
                      Colors.white.withOpacity(0.08),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo - Left Top Position with Shadow Only (No Background Color)
                        Container(
                          height: isSmallScreen
                              ? 90
                              : 100, // Further increased size
                          width: isSmallScreen
                              ? 90
                              : 100, // Further increased size
                          decoration: BoxDecoration(
                            // No background color - completely transparent
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              // Enhanced shadow effects
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 20,
                                spreadRadius: 5,
                                offset: Offset(0, 8),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              ),
                              BoxShadow(
                                color: AppColors.primaryGreen.withOpacity(0.2),
                                blurRadius: 25,
                                spreadRadius: 8,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'lib/assets/images/logo.png',
                            fit: BoxFit
                                .contain, // Logo will maintain its aspect ratio
                          ),
                        ),

                        Spacer(),

                        // Main Title Section - Center aligned
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Carpooling',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 36 : 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 8,
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Made Easy',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 36 : 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 8,
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Content Section
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tagline Section
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Connect, Commute,\nContribute',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 26 : 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Experience the future of carpooling – efficient, eco-friendly, and empowering',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.greyText,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 18 : 22),

                      // Features Section
                      _buildFeatureSection(),

                      SizedBox(height: isSmallScreen ? 22 : 26),

                      // Phone Input Section
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryGreen.withOpacity(0.08),
                              AppColors.lightGreen.withOpacity(0.04),
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            // Country Code Container
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.primaryGreen.withOpacity(
                                    0.3,
                                  ),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryGreen.withOpacity(
                                      0.1,
                                    ),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                '+91',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ),

                            SizedBox(width: 8),

                            // Phone Input Field
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: AppColors.primaryGreen.withOpacity(
                                      0.3,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryGreen.withOpacity(
                                        0.1,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'Enter your number',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 18,
                                    ),
                                    hintStyle: TextStyle(
                                      color: AppColors.greyText,
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 18),

                      // Terms and Privacy
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.greyText,
                              height: 1.3,
                            ),
                            children: [
                              TextSpan(text: 'By continuing I agree to '),
                              TextSpan(
                                text: 'Terms of use',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' & '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 24),

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
                            onTap: _isLoading ? null : _handleOTPVerification,
                            child: Container(
                              alignment: Alignment.center,
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          'Sending OTP...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.verified_user_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Verify with OTP',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.8,
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
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: AppColors.primaryGreen,
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Zero Commission • Verified Community • Smart Matching',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleOTPVerification() {
    if (_phoneController.text.length == 10) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPScreen(phoneNumber: _phoneController.text),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Please enter a valid 10-digit phone number'),
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

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
