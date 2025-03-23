import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/main_provider.dart';
import 'package:task/screens/number_verification.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.02,
            ),
            child: Column(
              children: [
                 SizedBox(height: 50),
                 Column(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 50,
                          width: 50,
                        ),
                           SizedBox(height: 10),
                        Text(
                          "Connect. Meet. Love.\nWith Fliq Dating",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28),
                        ),
                      ],
                    ),
               Spacer(),
                Column(
                  children: [
                    // Logo
                   
                   

                    Column(
                      spacing: 14,
                      children: [
                        _buildSignInButton(
                          icon: 'assets/Google.png',
                          text: "Sign in with Google",
                          color: Colors.white,
                          textColor: Colors.black,
                          onPressed: () {},
                        ),

                        _buildSignInButton(
                          icon: 'assets/facebook.png',
                          text: "Sign in with Facebook",
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            final mainProvider = Provider.of<MainProvider>(
                                context,
                                listen: false);
                            mainProvider.getToken();
                          },
                        ),

                        _buildSignInButton(
                          icon: 'assets/Phone_icon.png',
                          text: "Sign in with phone number",
                          color: Colors.pink,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhoneNumberScreen()));
                          },
                        ),

                        // Terms and Privacy Policy
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text.rich(
                            TextSpan(
                              text: "By signing up, you agree to our ",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                              children: [
                                TextSpan(
                                  text: "Terms",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                      fontSize: 13),
                                ),
                                TextSpan(
                                  text: ". See how we use your data in our ",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      decorationColor: Colors.white,
                                      color: Colors.white,
                                      fontSize: 13),
                                ),
                                TextSpan(
                                  text: "Privacy Policy.",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                      color: Colors.white,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // button
  Widget _buildSignInButton({
    required String icon,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: Image.asset(icon, height: 20),
        label: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}
