import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quiz_app/features/profile/services/user_service.dart';
import 'package:quiz_app/features/profile/models/user_data.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  UserData? _userData;
  bool _loading = true;
  String? _error;
  bool _editing = false;
  bool _hasChanges = false;
  final _formKey = GlobalKey<FormState>();
  String? _editFirstName;
  String? _editLastName;
  String? _editPassword;
  String? _editPasswordConfirm;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
    _animationController.forward();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await UserService().getUserInfo();
    if (mounted) {
      setState(() {
        if (result['success'] == true && result['data'] is UserData) {
          _userData = result['data'] as UserData;
          _error = null;
        } else {
          _error = result['message'] ?? 'Failed to load profile info';
        }
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return "Not available";
    try {
      final dt = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return "${dt.day} ${months[dt.month - 1]}, ${dt.year}";
    } catch (e) {
      return "Not available";
    }
  }

  Widget _profileRow(
    String label,
    String value,
    IconData icon, {
    bool isEditable = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _editing && isEditable
            ? Color(0xFFF0F8FF) // Light blue tint for editable fields
            : Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _editing && isEditable
              ? Color(0xFF6A3FC6).withOpacity(0.3) // Purple border for editable
              : Colors.grey.withOpacity(0.1),
          width: _editing && isEditable ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF6A3FC6),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6A3FC6).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (_editing && isEditable) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF6A3FC6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "EDITABLE",
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4),
                if (_editing && isEditable) ...[
                  if (label == "First Name")
                    TextFormField(
                      initialValue:
                          _editFirstName ?? _userData?.firstName ?? "",
                      decoration: InputDecoration(
                        hintText: "Enter your first name",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6A3FC6)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6A3FC6),
                            width: 2,
                          ),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                        letterSpacing: 0.3,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'First name required'
                          : null,
                      onChanged: (v) {
                        _editFirstName = v;
                        _checkForChanges();
                      },
                    )
                  else if (label == "Last Name")
                    TextFormField(
                      initialValue: _editLastName ?? _userData?.lastName ?? "",
                      decoration: InputDecoration(
                        hintText: "Enter your last name",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6A3FC6)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6A3FC6),
                            width: 2,
                          ),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                        letterSpacing: 0.3,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Last name required'
                          : null,
                      onChanged: (v) {
                        _editLastName = v;
                        _checkForChanges();
                      },
                    )
                  else if (label == "Password")
                    TextFormField(
                      decoration: InputDecoration(
                        hintText:
                            "Enter new password (leave blank to keep current)",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6A3FC6)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6A3FC6),
                            width: 2,
                          ),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      obscureText: true,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                        letterSpacing: 0.3,
                      ),
                      onChanged: (v) {
                        _editPassword = v;
                        _checkForChanges();
                      },
                    ),
                ] else
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordConfirmCard() {
    if (!_editing || _editPassword == null || _editPassword!.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFF6A3FC6).withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF6A3FC6),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6A3FC6).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(12),
                child: Icon(Icons.lock_reset, color: Colors.white, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Confirm New Password",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[500],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "REQUIRED",
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Re-enter your new password",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6A3FC6)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6A3FC6),
                            width: 2,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      obscureText: true,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                        letterSpacing: 0.3,
                      ),
                      validator: (v) {
                        if ((_editPassword ?? '').isNotEmpty &&
                            v != _editPassword) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onChanged: (v) => _editPasswordConfirm = v,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_editPassword != null &&
              _editPasswordConfirm != null &&
              _editPassword != _editPasswordConfirm) ...[
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 16),
                SizedBox(width: 8),
                Text(
                  "Passwords do not match",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _checkForChanges() {
    final changed =
        (_editFirstName ?? _userData?.firstName ?? "") !=
            (_userData?.firstName ?? "") ||
        (_editLastName ?? _userData?.lastName ?? "") !=
            (_userData?.lastName ?? "") ||
        (_editPassword != null && _editPassword!.isNotEmpty);
    setState(() {
      _hasChanges = changed;
    });
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A3FC6),
      body: SafeArea(
        child: _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        _error!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchUserInfo,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            : Skeletonizer(
                enabled: _loading,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // Header Section
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 40,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF6A3FC6),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF6A3FC6).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        _editing
                                            ? "Edit Profile"
                                            : "My Profile",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: _editing
                                            ? () {
                                                setState(() {
                                                  _editing = false;
                                                  _hasChanges = false;
                                                  _editFirstName = null;
                                                  _editLastName = null;
                                                  _editPassword = null;
                                                  _editPasswordConfirm = null;
                                                });
                                              }
                                            : () {
                                                setState(() {
                                                  _editing = true;
                                                  _editFirstName =
                                                      _userData?.firstName;
                                                  _editLastName =
                                                      _userData?.lastName;
                                                  _editPassword = null;
                                                  _editPasswordConfirm = null;
                                                  _hasChanges = false;
                                                });
                                              },
                                        icon: Icon(
                                          _editing ? Icons.close : Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 20,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: AssetImage(
                                        "assets/images/my_profile.jpg",
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "${_userData?.firstName ?? ""} ${_userData?.lastName ?? ""}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      (_userData?.username == null ||
                                              (_userData?.username
                                                      ?.trim()
                                                      .isEmpty ??
                                                  true))
                                          ? "-"
                                          : _userData!.username!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            // Stats Card
                            _userData == null
                                ? SizedBox.shrink()
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF6A3FC6),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFF6A3FC6,
                                          ).withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildStatItem(
                                          "Profile ID",
                                          "${_userData?.id ?? "-"}",
                                          Icons.badge,
                                        ),
                                        Container(
                                          width: 1,
                                          height: 40,
                                          color: Colors.white30,
                                        ),
                                        _buildStatItem(
                                          "Member Since",
                                          _userData != null
                                              ? "${_userData!.createdAt.month}/${_userData!.createdAt.year}"
                                              : "-",
                                          Icons.calendar_month,
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(height: 24),

                            // Profile Details Section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Profile Details",
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        _profileRow(
                                          "Username",
                                          (_userData?.username == null ||
                                                  (_userData?.username
                                                          ?.trim()
                                                          .isEmpty ??
                                                      true))
                                              ? "-"
                                              : _userData!.username!,
                                          Icons.alternate_email,
                                        ),
                                        _profileRow(
                                          "First Name",
                                          _userData?.firstName ?? "N/A",
                                          Icons.person,
                                          isEditable: true,
                                        ),
                                        _profileRow(
                                          "Last Name",
                                          _userData?.lastName ?? "N/A",
                                          Icons.person_outline,
                                          isEditable: true,
                                        ),
                                        _profileRow(
                                          "Phone Number",
                                          _userData != null
                                              ? "+${_userData!.countryCode} ${_userData!.phone}"
                                              : "N/A",
                                          Icons.phone_android,
                                        ),
                                        _profileRow(
                                          "Country Code",
                                          _userData?.countryCode ?? "N/A",
                                          Icons.flag_outlined,
                                        ),
                                        _profileRow(
                                          "Account Status",
                                          _userData?.status ?? "Active",
                                          Icons.verified_user_outlined,
                                        ),
                                        _profileRow(
                                          "Last Seen",
                                          _userData?.lastSeenAt == null
                                              ? "Currently active"
                                              : _formatDate(
                                                  _userData!.lastSeenAt,
                                                ),
                                          Icons.schedule,
                                        ),
                                        _profileRow(
                                          "Account Created",
                                          _userData != null
                                              ? _formatDate(
                                                  _userData!.createdAt
                                                      .toIso8601String(),
                                                )
                                              : "-",
                                          Icons.calendar_today_outlined,
                                        ),
                                        _profileRow(
                                          "Last Updated",
                                          _userData != null
                                              ? _formatDate(
                                                  _userData!.updatedAt
                                                      .toIso8601String(),
                                                )
                                              : "-",
                                          Icons.update_outlined,
                                        ),
                                        _profileRow(
                                          "Password",
                                          "••••••••",
                                          Icons.lock_outline,
                                          isEditable: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16),

                            // Password Confirmation Card (separate card)
                            _buildPasswordConfirmCard(),

                            SizedBox(height: 32),

                            // Save Button (only show in edit mode)
                            if (_editing)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: (!_hasChanges || _saving)
                                        ? null
                                        : () async {
                                            if (!_formKey.currentState!
                                                .validate())
                                              return;
                                            setState(() => _saving = true);

                                            bool infoChanged =
                                                (_editFirstName ??
                                                        _userData?.firstName ??
                                                        "") !=
                                                    (_userData?.firstName ??
                                                        "") ||
                                                (_editLastName ??
                                                        _userData?.lastName ??
                                                        "") !=
                                                    (_userData?.lastName ?? "");
                                            bool passChanged =
                                                (_editPassword != null &&
                                                _editPassword!.isNotEmpty);
                                            bool ok = true;
                                            String? errorMsg;

                                            if (infoChanged) {
                                              final res = await UserService()
                                                  .updateUserInfo(
                                                    firstName:
                                                        _editFirstName ??
                                                        _userData?.firstName ??
                                                        "",
                                                    lastName:
                                                        _editLastName ??
                                                        _userData?.lastName ??
                                                        "",
                                                  );
                                              if (res['success'] != true) {
                                                ok = false;
                                                errorMsg =
                                                    res['message'] ??
                                                    'Failed to update info';
                                              }
                                            }

                                            if (ok && passChanged) {
                                              final res = await UserService()
                                                  .changePassword(
                                                    currentPassword: "",
                                                    newPassword: _editPassword!,
                                                  );
                                              if (res['success'] != true) {
                                                ok = false;
                                                errorMsg =
                                                    res['message'] ??
                                                    'Failed to change password';
                                              }
                                            }

                                            if (ok) {
                                              await _fetchUserInfo();
                                              setState(() {
                                                _editing = false;
                                                _hasChanges = false;
                                                _editPassword = null;
                                                _editPasswordConfirm = null;
                                              });
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Profile updated successfully!',
                                                  ),
                                                ),
                                              );
                                            } else {
                                              setState(() => _saving = false);
                                              if (errorMsg != null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(errorMsg),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                    child: _saving
                                        ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFF6A3FC6),
                                            ),
                                          )
                                        : Text(
                                            'Save Changes',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF6A3FC6),
                                            ),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Color(0xFF6A3FC6),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: Color(0xFF6A3FC6),
                                          width: 2,
                                        ),
                                      ),
                                      elevation: 8,
                                      shadowColor: Colors.black.withOpacity(
                                        0.1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
