import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task/custom_appbar.dart';
import 'package:task/provider/main_provider.dart';
import 'package:task/screens/otp_verification.dart';

class PhoneNumberScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    void sendOtp(BuildContext context) async {
      final authProvider = Provider.of<MainProvider>(context, listen: false);
      String phoneNumber = phoneController.text.trim();

      if (phoneNumber.isNotEmpty) {
        print("Phone Number Entered: $phoneNumber");

        bool success = await authProvider.sendOtp(phoneNumber);

        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(phoneNumber: phoneNumber),
            ),
          );
        } else {
          print("Failed to send OTP");
        }
      } else {
        print("Phone number is empty!");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.06,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Title
            Center(
              child: Text(
                "Enter your phone\nnumber",
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2E0E16)),
              ),
            ),

            SizedBox(height: 20),

            // Phone Input Field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Image.asset("assets/mobile_c.png",
                      width: width * 0.06, height: 24),
                  SizedBox(width: 5),
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    icon: Row(
                      children: [
                        Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xffD5CFD0),
                          size: 25,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Container(
                          height: 15,
                          width: width * 0.001,
                          color: Color(0xffD5CFD0),
                        )
                      ],
                    ),

                    value: "+91", // Default country code
                    underline: SizedBox(), // Hide the default underline
                    items: [
                      DropdownMenuItem(
                        value: "+91",
                        child: Text(
                          "+91",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff2E0E16)),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "+1",
                        child: Text(
                          "+1",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff2E0E16)),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "+44",
                        child: Text(
                          "+44",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff2E0E16)),
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: "enter number",
                        hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff2E0E16)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Info Text
            Text(
              "Fliq will send you a text with a verification code.",
              style: GoogleFonts.poppins(
                  color: Color(0xff583E45),
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),

            Spacer(),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffFF80A1).withOpacity(0.9),
                      Color(0xffE6446E).withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Consumer<MainProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () => sendOtp(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Next",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    );
                  },
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
