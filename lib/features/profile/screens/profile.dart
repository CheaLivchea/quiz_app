import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/features/home_page/screens/home_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool enableSke = true;
  TextEditingController usernameController = TextEditingController(
    text: "Chea Livchea",
  );
  TextEditingController emailController = TextEditingController(
    text: "chealivchea@gmail.com",
  );
  TextEditingController passwordController = TextEditingController();
  bool isEditingUsername = false;
  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    changeState();
  }

  void changeState() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        enableSke = !enableSke;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A3FC6),
      appBar: AppBar(
        backgroundColor: Color(0xFF6A3FC6),
        title: Text(
          "Your Profile",
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Icon(Icons.close_sharp, size: 26),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Skeletonizer(
          enabled: enableSke,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12, 30, 12, 20),
            decoration: BoxDecoration(
              color: Color(0xFFEFE7FD),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: SizedBox(
                    height: 120,
                    child: Image.asset("assets/images/my_profile.jpg"),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  usernameController.text,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A3FC6),
                  ),
                ),
                SizedBox(height: 0),
                Text(
                  "Software Engineer",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 5),
                        Text(
                          "Username",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: !isEditingUsername
                            ? Color(0x5EEFBCBC)
                            : Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black45, width: 1),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.person, color: Color(0xFF6A3FC6)),
                        title: Container(
                          height: 24,
                          alignment: Alignment.centerLeft,
                          child: isEditingUsername
                              ? TextField(
                                  controller: usernameController,
                                  textInputAction: TextInputAction
                                      .done, // changes keyboard button to 'Done'
                                  onSubmitted: (value) {
                                    // works when Done is pressed
                                    setState(() {
                                      isEditingUsername = false;
                                      isVisible = true;
                                    });
                                    FocusScope.of(
                                      context,
                                    ).unfocus(); // close the keyboard
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  usernameController.text,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: Color(0xFF6A3FC6)),
                          onPressed: () {
                            setState(() {
                              isVisible = true;
                              isEditingUsername = !isEditingUsername;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 5),
                        Text(
                          "Email",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: !isEditingEmail
                            ? Color(0x5EEFBCBC)
                            : Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black45, width: 1),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.email, color: Color(0xFF6A3FC6)),
                        title: Container(
                          height: 24,
                          alignment: Alignment.centerLeft,
                          child: isEditingEmail
                              ? SizedBox(
                                  height: 24,
                                  child: TextField(
                                    controller: emailController,
                                    textInputAction: TextInputAction
                                        .done, // changes keyboard button to 'Done'
                                    onSubmitted: (value) {
                                      // works when Done is pressed
                                      setState(() {
                                        isEditingEmail = false;
                                        isVisible = true;
                                      });
                                      FocusScope.of(
                                        context,
                                      ).unfocus(); // close the keyboard
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : Text(
                                  emailController.text,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = true;
                              isEditingEmail = !isEditingEmail;
                            });
                          },
                          icon: Icon(Icons.edit, color: Color(0xFF6A3FC6)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 5),
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: !isEditingPassword
                            ? Color(0x5EEFBCBC)
                            : Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.lock, color: Color(0xFF6A3FC6)),
                        title: Container(
                          height: 24,
                          alignment: Alignment.centerLeft,
                          child: isEditingPassword
                              ? SizedBox(
                                  height: 24,
                                  child: TextField(
                                    controller: passwordController,
                                    textInputAction: TextInputAction
                                        .done, // changes keyboard button to 'Done'
                                    onSubmitted: (value) {
                                      // works when Done is pressed
                                      setState(() {
                                        isEditingPassword = false;
                                        isVisible = true;
                                      });
                                      FocusScope.of(
                                        context,
                                      ).unfocus(); // close the keyboard
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: false,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    obscureText: true,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : Text(
                                  "**********",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = true;
                              isEditingPassword = !isEditingPassword;
                            });
                          },
                          icon: Icon(Icons.edit, color: Color(0xFF6A3FC6)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
                Visibility(
                  visible: isVisible,

                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Color(0xFF6A3FC6),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isVisible = false;
                        isEditingUsername = false;
                        isEditingEmail = false;
                        isEditingPassword = false;
                      });
                    },
                    child: Text(
                      "Save",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
