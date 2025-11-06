import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wellnest_chatbot/models/ai_service.dart';
import 'package:wellnest_chatbot/models/storage_service.dart';
import 'package:wellnest_chatbot/pages/drawer.dart';
import 'package:wellnest_chatbot/theme/theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Services
  final AiService _aiService = AiService();
  final StorageService _storageService = StorageService();

  // User and Bot definitions for the chat UI
  late ChatUser _user;
  final ChatUser _bot = ChatUser(
    id: '2',
    firstName: 'WELLNEX AI',
    profileImage: 'assets/icon/logo1.jpg',
  );

  // State variables for the chat
  List<ChatMessage> _messages = [];
  List<ChatUser> _typing = [];
  Map<String, dynamic> _userProfile = {};

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Loads the user profile from storage and initializes the user for the chat.
  Future<void> _loadUserProfile() async {
    final profile = await _storageService.getUserProfile();
    setState(() {
      _userProfile = profile;
      _user = ChatUser(id: '1', firstName: profile['name']);
      // Add an initial welcome message from the bot
      _messages.add(
        ChatMessage(
          text:
              "Hello ${_user.firstName}! How can I help you with your wellness and diet today?",
          user: _bot,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  void _sendMessage(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typing.add(_bot);
    });

    try {
      final responseText = await _aiService.getResponse(m.text, _userProfile);

      final responseMessage = ChatMessage(
        text: responseText,
        user: _bot,
        createdAt: DateTime.now(),
        isMarkdown: true,
      );

      setState(() {
        _messages.insert(0, responseMessage);
      });
    } catch (e) {
      final errorMessage = ChatMessage(
        text: "Sorry, something went wrong. Please try again.",
        user: _bot,
        createdAt: DateTime.now(),
      );
      setState(() {
        _messages.insert(0, errorMessage);
      });
    } finally {
      setState(() {
        _typing.remove(_bot);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191A1A),
      drawer: MyDrawer(onDataCleared: () {}),
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'WELLNEX AI',
              style: TextStyle(
                fontFamily: googleFontBold,
                color: blueColor,
                fontSize: 25,
              ),
            ),
            SizedBox(width: 8.w),
            Image.asset('assets/icon/logo.png', height: 35.h, width: 35.w),
          ],
        ),
      ),
      body: _userProfile.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : DashChat(
              currentUser: _user,
              onSend: _sendMessage,
              messages: _messages,
              typingUsers: _typing,
              messageOptions: MessageOptions(
                showTime: true,
                currentUserContainerColor: const Color(0xff303030),
                currentUserTextColor: Colors.white,
                containerColor: Colors.blueGrey.shade900,
                textColor: Colors.white,
                messageTextBuilder:
                    (ChatMessage message, ChatMessage? p, ChatMessage? n) {
                      return SelectableText.rich(
                        TextSpan(children: _parseText(message.text)),
                        style: TextStyle(
                          fontFamily: googleFontSemiBold,
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      );
                    },
              ),
              scrollToBottomOptions: ScrollToBottomOptions(
                scrollToBottomBuilder: (scrollController) {
                  return Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.arrow_downward),
                      onPressed: () {
                        scrollController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    ),
                  );
                },
              ),
              inputOptions: InputOptions(
                inputToolbarPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 12.h,
                ),
                sendButtonBuilder: (onSend) {
                  return IconButton(
                    icon: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Icon(Icons.arrow_upward_rounded, size: 30.sp),
                    ),
                    onPressed: onSend,
                  );
                },
                inputDecoration: InputDecoration(
                  fillColor: const Color(0xff2F3030),
                  filled: true,
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                cursorStyle: const CursorStyle(color: blueColor),
                inputTextStyle: TextStyle(
                  fontFamily: googleFontNormal,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  List<TextSpan> _parseText(String text) {
    final boldPattern = RegExp(r'\*\*(.*?)\*\*');
    final matches = boldPattern.allMatches(text);
    if (matches.isEmpty) {
      return [TextSpan(text: text)];
    }

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }
}
