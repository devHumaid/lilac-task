import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task/const.dart';
import 'package:task/models/get_model.dart'; // For Datum
import 'package:task/provider/main_provider.dart';

class ChatScreen extends StatelessWidget {
  final Datum contact;
  final TextEditingController _messageController = TextEditingController();
  final String authUserId = "20"; // Replace with dynamic auth user ID

  ChatScreen({super.key, required this.contact});

  String _formatTimestamp(String sentAt) {
    final dateTime = DateTime.parse(sentAt);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }


  @override
  Widget build(BuildContext context) {
    // Fetch chat messages if not already loaded
    final provider = context.read<MainProvider>();
    if (provider.conversationMessages.isEmpty && !provider.isLoadingChats) {
      provider.getChatBetweenUsers(authUserId, contact.id);
    }

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: contact.attributes.profilePhotoUrl.isNotEmpty
                  ? NetworkImage(contact.attributes.profilePhotoUrl)
                  : const AssetImage("assets/user1.jpg") as ImageProvider,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.attributes.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  contact.attributes.isOnline ? "Online" : "Offline",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: contact.attributes.isOnline
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Consumer<MainProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: provider.isLoadingChats
                    ? const Center(child: CircularProgressIndicator())
                    : provider.conversationMessages.isEmpty
                        ? Center(
                            child: Text(
                              "No messages yet",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05),
                            child: ListView.builder(
                              reverse:
                                  true, // Start from bottom (latest message)
                              itemCount: provider.conversationMessages.length,
                              itemBuilder: (context, index) {
                                final message =
                                    provider.conversationMessages[index];
                                final isSentByMe =
                                    message.attributes.senderId == authUserId;

                                return Column(
                                  children: [
                                    if (index ==
                                        provider.conversationMessages.length -
                                            1)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        child: Text(
                                          "Today",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    Align(
                                      alignment: isSentByMe
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: isSentByMe
                                                  ? Color(0xffE6446E)
                                                  : Color(0xffE6446E),
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(12),
                                                  topRight:
                                                      const Radius.circular(12),
                                                  bottomLeft: isSentByMe
                                                      ? Radius.zero
                                                      : const Radius.circular(
                                                          12),
                                                  bottomRight: isSentByMe
                                                      ? const Radius.circular(
                                                          12)
                                                      : Radius.zero),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: isSentByMe
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                if (message
                                                        .attributes.message !=
                                                    null)
                                                  Text(
                                                    message.attributes.message!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: isSentByMe
                                                          ? Colors.white
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                if (message
                                                        .attributes.mediaUrl !=
                                                    null)
                                                  Image.network(
                                                    message
                                                        .attributes.mediaUrl!,
                                                    width: 150,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                const SizedBox(height: 4),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            _formatTimestamp(
                                                message.attributes.sentAt),
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: isSentByMe
                                                  ? Colors.white70
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(),
                    border:
                        Border(top: BorderSide(color: greyFD0, width: 0.5))),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black54,
                            textStyle: TextStyle()),
                        filled: true,
                        fillColor: Colors.grey[100],
                        suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              "assets/send.png",
                              width: 24,
                              height: 24,
                            )),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}


