import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/auth/widgets/logout.dart';
import 'package:quiz_app/features/profile/screens/profile.dart';
import 'package:quiz_app/features/leaderboard/screens/leaderboard_page.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/features/profile/providers/user_provider.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          onTap(index);
          _handleNavigation(context, index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF6A3FC6),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Already on home, do nothing
        break;
      case 1:
        // Quiz History - you can implement this later
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Quiz History - Coming Soon!')));
        // Reset to home after showing snackbar
        Future.delayed(Duration(milliseconds: 100), () {
          onTap(0);
        });
        break;
      case 2:
        // Leaderboard - Navigate to new page
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final currentUserId = userProvider.userData?.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LeaderboardScreen(currentUserId: currentUserId),
          ),
        ).then((_) {
          // Reset to home tab when returning from leaderboard
          onTap(0);
        });
        break;
      case 3:
        // Profile - Navigate to new page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profile()),
        ).then((_) {
          // Reset to home tab when returning from profile
          onTap(0);
        });
        break;
      case 4:
        // Settings
        _showSettingsModal(context);
        // Reset to home after modal closes
        Future.delayed(Duration(milliseconds: 100), () {
          onTap(0);
        });
        break;
    }
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Settings',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.info, color: Color(0xFF6A3FC6)),
              title: Text(
                'About',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('About - Coming Soon!')));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF6A3FC6)),
              title: Text(
                'App Settings',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('App Settings - Coming Soon!')),
                );
              },
            ),
            Divider(),
            Logout(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
