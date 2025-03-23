import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task/custom_appbar.dart';
import 'package:task/screens/messages_screen.dart';
import 'package:task/provider/main_provider.dart';

class OTPScreen extends StatelessWidget {
  final String phoneNumber;
  OTPScreen({super.key, required this.phoneNumber});

  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  void verifyOTP(BuildContext context) async {
    final authProvider = Provider.of<MainProvider>(context, listen: false);
    String otp = otpControllers.map((e) => e.text).join();

    if (otp.length == 6) {
      bool success = await authProvider.verifyOtp(phoneNumber, otp);
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ChatListPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP. Please try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter the full 6-digit OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Enter your verification\ncode",
              textAlign: TextAlign.center,
              style: GoogleFonts.jost(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2E0E16)),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: "+91 ${phoneNumber}. ",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xff2E0E16),
                        fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: "Edit",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),

            Row(
              children: [
                Text(
                  "Didn’t get anything? No worries, let’s try again.",
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Provider.of<MainProvider>(context, listen: false)
                        .sendOtp(phoneNumber);
                  },
                  child: Text(
                    "Resend",
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Spacer(),
            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ).copyWith(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: () => verifyOTP(context),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffFF80A1).withOpacity(0.9),
                        Color(0xffE6446E).withOpacity(0.8)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Verify",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
