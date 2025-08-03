import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/features/auth/providers/auth_provider.dart';
import 'package:quiz_app/features/welcome/screens/welcome_page.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListTile(
        leading: Icon(Icons.logout_sharp, color: Color(0xFF4B4B6A)),
        title: Text(
          "Logout",
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF282433),
          ),
        ),
        onTap: () {
          context.read<AuthProvider>().logout();
          if (context.mounted) {
            // Use MaterialPageRoute instead of named route
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomePage()),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}