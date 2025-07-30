import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A3FC6),
      appBar: AppBar(
        backgroundColor: Color(0xFF6A3FC6),
        automaticallyImplyLeading: false,
        leading: Row(children: []),
      ),
    );
  }
}
