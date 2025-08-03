import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/features/auth/providers/auth_provider.dart';
import 'package:quiz_app/features/auth/widgets/optDigitBox.dart';

class SendOTP extends StatefulWidget {
  const SendOTP({super.key});

  @override
  State<SendOTP> createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A3FC6),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 150),
            Image.asset('assets/images/policeOTP.png'),
            SizedBox(height: 50),
            Text(
              "OTP Verification",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 36,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Enter the OTP sent to +855 964957785",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: OTPDigitBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      }
                      if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                    autoFocus: index == 0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            FilledButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.grey.shade400;
                  }

                  return Colors.white; // Default color
                }),
                minimumSize: WidgetStateProperty.all(
                  const Size(double.infinity, 50),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Text(
                "Verify",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
