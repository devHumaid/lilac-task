import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task/screens/chat_screen.dart';
import 'package:task/const.dart';
import 'package:task/provider/main_provider.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return "10:00 AM";
    final dateTime = DateTime.parse(timestamp);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Fetch chat list if not already loaded
    final provider = context.read<MainProvider>();
    if (provider.chatMessages.isEmpty && !provider.isLoadingChats) {
      provider.getChatList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Messages",
          style: GoogleFonts.poppins(
            color: primaryTextE16,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // Row of recent contacts (avatars)
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 8.0),
            child: Consumer<MainProvider>(
              builder: (context, provider, child) {
                if (provider.isLoadingChats) {
                  return const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (provider.chatMessages.isEmpty) {
                  return const SizedBox(
                    height: 60,
                    child: Center(child: Text("No recent contacts")),
                  );
                }
                return SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.chatMessages.length > 5
                        ? 5
                        : provider.chatMessages.length,
                    itemBuilder: (context, index) {
                      final chat = provider.chatMessages[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 55,
                              width: 55,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    chat.attributes.profilePhotoUrl.isNotEmpty
                                        ? NetworkImage(
                                            chat.attributes.profilePhotoUrl)
                                        : const AssetImage(
                                                'assets/default_user.png')
                                            as ImageProvider,
                                onBackgroundImageError: (_, __) {},
                              ),
                            ),
                            Text(
                              chat.attributes.name.isNotEmpty
                                  ? chat.attributes.name
                                  : "Unknown",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: primaryTextE16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
     
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    hintText: "Search",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/search-favorite.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Define border for all states
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: greyFD0, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: greyFD0, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: greyFD0, width: 0.5),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: greyFD0, width: 0.5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Chat",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: primaryTextE16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),
          // Chat list
          Expanded(
            child: Consumer<MainProvider>(
              builder: (context, provider, child) {
                if (provider.isLoadingChats) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.chatMessages.isEmpty) {
                  return const Center(
                    child: Text(
                      "No chats available",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.01,
                  ),
                  child: ListView.builder(
                    itemCount: provider.chatMessages.length,
                    itemBuilder: (context, index) {
                      final chat = provider.chatMessages[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: chat
                                  .attributes.profilePhotoUrl.isNotEmpty
                              ? NetworkImage(chat.attributes.profilePhotoUrl)
                              : const AssetImage('assets/default_user.png')
                                  as ImageProvider,
                          onBackgroundImageError: (_, __) {},
                        ),
                        title: Text(
                          chat.attributes.name.isNotEmpty
                              ? chat.attributes.name
                              : "Unknown",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: primaryTextE16,
                          ),
                        ),
                        trailing: Text(
                          _formatTimestamp(
                              chat.attributes.messageReceivedFromPartnerAt),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(contact: chat),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
