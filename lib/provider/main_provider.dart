import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/models/chat_model.dart';
import 'package:task/models/get_model.dart'; // For Datum

class MainProvider with ChangeNotifier {
  final String baseUrl = "https://test.myfliqapp.com/api/v1";

  bool isLoading = false;
  bool isVerifying = false;
  String? lastOtp;
  String? accessToken;
  bool isLoadingChats = false;
  List<Datum> chatMessages = []; // For chat list (users)
  List<ChatMessage> conversationMessages = []; // For chat conversation

  Future<bool> sendOtp(String phone) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        "$baseUrl/auth/registration-otp-codes/actions/phone/send-otp");
    String sanitizedPhone = phone.startsWith("+91") ? phone : "+91$phone";

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": {
            "type": "registration_otp_codes",
            "attributes": {"phone": sanitizedPhone}
          }
        }),
      );

      // print("Send OTP Response Code: ${response.statusCode}");
      // print("Send OTP Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        lastOtp = responseData["data"].toString();
        // print("OTP Sent Successfully: $lastOtp");
        return true;
      } else {
        // print("Failed to send OTP: ${response.body}");
        return false;
      }
    } catch (e) {
      // print("Error sending OTP: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("access_token", token);
    accessToken = token;
    print("Access token saved successfully: $token");
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    print("Retrieved Access Token: $token");
    return token;
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    isVerifying = true;
    notifyListeners();

    final url = Uri.parse(
        "$baseUrl/auth/registration-otp-codes/actions/phone/verify-otp");
    String sanitizedPhone = phone.startsWith("+91") ? phone : "+91$phone";

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": {
            "type": "registration_otp_codes",
            "attributes": {
              "phone": sanitizedPhone,
              "otp": int.parse(otp),
              "device_meta": {
                "type": "mobile",
                "name": "Flutter Device",
                "os": "Android",
                "browser": "Flutter",
                "browser_version": "1.0",
                "user_agent": "YourApp/1.0",
                "screen_resolution": "1080x1920",
                "language": "en-US"
              }
            }
          }
        }),
      );

      print("Verify OTP Response Code: ${response.statusCode}");
      log("Verify OTP Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String? token = responseData["data"]?["attributes"]?["auth_status"]
            ?["access_token"];

        if (token != null && token.isNotEmpty) {
          await saveToken(token);
          print("Access token: $token");
          await getChatList(); // Call here to ensure data is loaded before navigating
          return true;
        } else {
          print("Error: Access token is null or empty.");
          return false;
        }
      } else {
        final errorData = jsonDecode(response.body);
        print("Failed to verify OTP: ${errorData["error"] ?? response.body}");
        return false;
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    } finally {
      isVerifying = false;
      notifyListeners();
    }
  }

  Future<void> getChatList() async {
    String? token = await getToken();
    if (token == null || token.isEmpty) {
      print("Error: Token is not available.");
      return;
    }

    isLoadingChats = true;
    notifyListeners();

    final url = Uri.parse("$baseUrl/chat/chat-messages/queries/contact-users");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Get Chat List Response Code: ${response.statusCode}");
      log("Get Chat List Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse["data"] ?? [];
        chatMessages = data.map((item) => Datum.fromJson(item)).toList();
        print("Chat list loaded: ${chatMessages.length} items");
      } else {
        print(
            "Failed to load chats: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching chat list: $e");
    } finally {
      isLoadingChats = false;
      notifyListeners();
    }
  }

  Future<void> getChatBetweenUsers(String senderId, String receiverId) async {
    String? token = await getToken();
    if (token == null || token.isEmpty) {
      print("Error: Token is not available.");
      return;
    }

    isLoadingChats = true;
    notifyListeners();

    final url = Uri.parse(
        "$baseUrl/chat/chat-messages/queries/chat-between-users/$senderId/$receiverId");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Get Chat Between Users Response Code: ${response.statusCode}");
      log("Get Chat Between Users Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse["data"] ?? [];
        conversationMessages =
            data.map((item) => ChatMessage.fromJson(item)).toList();
        print(
            "Chat between users loaded: ${conversationMessages.length} items");
      } else {
        print(
            "Failed to load chat between users: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching chat between users: $e");
    } finally {
      isLoadingChats = false;
      notifyListeners();
    }
  }
}
