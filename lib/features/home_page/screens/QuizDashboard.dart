import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/quiz/screens/quiz_screen.dart';
import 'package:quiz_app/features/home_page/widgets/services_grid.dart';
import 'package:quiz_app/features/home_page/widgets/custom_bottom_nav.dart';
import 'package:quiz_app/features/home_page/services/home_service.dart';
import 'package:quiz_app/models/home_data.dart';
import 'package:quiz_app/features/profile/services/user_service.dart';
import 'package:quiz_app/features/profile/models/user_data.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Quizdashboard extends StatefulWidget {
  const Quizdashboard({super.key});

  @override
  State<Quizdashboard> createState() => _QuizdashboardState();
}

class _QuizdashboardState extends State<Quizdashboard> {
  int _currentIndex = 0;
  HomeData? _homeData;
  UserData? _userData;
  bool _isLoading = true;
  bool _isUserLoading = true;
  String _errorMessage = '';
  String _currentLocale = 'en';

  // Language options
  final Map<String, String> _languages = {
    'en': 'EN',
    'zh': '中文',
    'kh': 'ខ្មែរ',
  };

  @override
  void initState() {
    super.initState();
    _fetchHomepageData();
    _fetchUserData();
  }

  Future<void> _fetchHomepageData() async {
    // Only load if we don't have data yet
    if (_homeData != null) return;

    try {
      final homeService = HomeService();
      final result = await homeService.getHomepageData();

      if (result['success']) {
        setState(() {
          _homeData = result['data'] as HomeData;
          _isLoading = false;
        });

        // Debug print
        print('Categories loaded: ${_homeData?.categories.length ?? 0}');
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserData() async {
    // Only load if we don't have user data yet
    if (_userData != null) return;

    try {
      final userService = UserService();
      final result = await userService.getUserInfo();

      if (result['success']) {
        setState(() {
          _userData = result['data'] as UserData;
          _isUserLoading = false;
        });

        // Debug print
        print('User loaded: ${_userData?.displayName ?? 'Unknown'}');
      } else {
        setState(() {
          _isUserLoading = false;
        });
        print('Failed to load user data: ${result['message']}');
      }
    } catch (e) {
      setState(() {
        _isUserLoading = false;
      });
      print('Error loading user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A3FC6),
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _errorMessage.isNotEmpty
            ? _buildErrorState()
            : _buildMainContent(),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Skeletonizer(enabled: true, child: _buildSkeletonContent());
  }

  Widget _buildSkeletonContent() {
    // Create fake categories for skeleton
    final skeletonCategories = List.generate(
      8,
      (index) => Category(
        id: index,
        iconUrl: '',
        nameEn: 'Loading Category',
        nameZh: '加载中',
        nameKh: 'កំពុងផ្ទុក',
      ),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section Skeleton
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Profile Picture Skeleton
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(width: 15),
                // Greeting Skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 180,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                // Notification Icon Skeleton
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // Stats Card Skeleton
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildSkeletonStatItem()),
                    SizedBox(width: 15),
                    Expanded(child: _buildSkeletonStatItem()),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 30),

          // Services Grid Skeleton
          ServicesGrid(categories: skeletonCategories, locale: 'en'),

          SizedBox(height: 30),

          // Promotion Banner Skeleton
          _buildSkeletonPromotionBanner(),

          SizedBox(height: 100), // Extra space for bottom nav
        ],
      ),
    );
  }

  Widget _buildSkeletonStatItem() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 40,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonPromotionBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: 80,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 48),
          SizedBox(height: 20),
          Text(
            'Failed to load data',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = '';
              });
              _fetchHomepageData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF6A3FC6),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Profile Picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/images/my_profile.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                // Greeting
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isUserLoading
                            ? "Hello, User!"
                            : "Hello, ${_userData?.displayName ?? 'User'}!",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Ready for today's quiz?",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                // Language Switcher with better UI
                GestureDetector(
                  onTap: () => _showLanguageSelector(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.language, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          _languages[_currentLocale] ?? 'EN',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stats Card
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quiz Performance",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        "Total Quizzes",
                        "24",
                        Icons.quiz,
                        Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildStatItem(
                        "Best Score",
                        "95%",
                        Icons.star,
                        Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 30),

          // Services Grid Widget with API data
          _homeData != null
              ? ServicesGrid(
                  categories: _homeData!.categories,
                  locale: _currentLocale, // Use selected language
                )
              : Container(),

          SizedBox(height: 30),

          // Promotion Banner using API data
          _buildPromotionBanner(),

          SizedBox(height: 100), // Extra space for bottom nav
        ],
      ),
    );
  }

  Widget _buildPromotionBanner() {
    final promotions = _homeData?.promotions ?? [];
    final promotion = promotions.isNotEmpty ? promotions.first : null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Challenge",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Complete today's quiz for bonus points!",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Start Now",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          // Use API promotion image if available, otherwise fallback to asset
          promotion != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    promotion.imgUrlEn,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/champion.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                )
              : Image.asset(
                  'assets/images/champion.jpg',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),

            // Title
            Text(
              'Select Language',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
            ),
            SizedBox(height: 20),

            // Language options
            ..._languages.entries.map((entry) {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _currentLocale == entry.key
                        ? Color(0xFF6A3FC6).withValues(alpha: 0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getLanguageIcon(entry.key),
                    color: _currentLocale == entry.key
                        ? Color(0xFF6A3FC6)
                        : Colors.grey[600],
                  ),
                ),
                title: Text(
                  _getLanguageName(entry.key),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: _currentLocale == entry.key
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: _currentLocale == entry.key
                        ? Color(0xFF6A3FC6)
                        : Color(0xFF2D2D2D),
                    height: entry.key == 'kh'
                        ? 1.5
                        : 1.2, // Better line height for Khmer
                  ),
                ),
                subtitle: Text(
                  entry.value,
                  style: GoogleFonts.roboto(
                    // Use Roboto for better Khmer support
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: entry.key == 'kh' ? 1.4 : 1.2,
                  ),
                ),
                trailing: _currentLocale == entry.key
                    ? Icon(Icons.check_circle, color: Color(0xFF6A3FC6))
                    : null,
                onTap: () {
                  setState(() {
                    _currentLocale = entry.key;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  IconData _getLanguageIcon(String locale) {
    switch (locale) {
      case 'en':
        return Icons.language;
      case 'zh':
        return Icons.translate;
      case 'kh':
        return Icons.place;
      default:
        return Icons.language;
    }
  }

  String _getLanguageName(String locale) {
    switch (locale) {
      case 'en':
        return 'English';
      case 'zh':
        return 'Chinese';
      case 'kh':
        return 'Khmer';
      default:
        return 'English';
    }
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}
