// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  List<Map<String, String>> messages = [];
  static const String _prefsKey = 'chat_history_pairs';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey) ?? [];
    setState(() {
      messages = [];
      for (var s in list) {
        try {
          final m = json.decode(s) as Map<String, dynamic>;
          messages.add({"role": "user", "text": m['user'] ?? ''});
          messages.add({"role": "bot", "text": m['bot'] ?? ''});
        } catch (_) {
          messages.add({"role": "user", "text": s});
        }
      }
    });
  }

  Future<void> _savePair(String user, String bot) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey) ?? [];
    final pair = json.encode({"user": user, "bot": bot});
    list.insert(0, pair); // newest first
    await prefs.setStringList(_prefsKey, list);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({"role": "user", "text": text});
    });
    _controller.clear();
    _scrollToBottom();

    // Simulate bot reply
    Future.delayed(const Duration(milliseconds: 700), () {
      final reply = "This is a canned reply to: \"$text\"";
      setState(() {
        messages.add({"role": "bot", "text": reply});
      });
      _savePair(text, reply);
      _scrollToBottom();
    });
  }

  Future<void> _showHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(_prefsKey) ?? [];

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            if (list.isEmpty) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'No history',
                    style: GoogleFonts.sourceCodePro(),
                  ),
                ),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chat History",
                        style: GoogleFonts.sourceCodePro(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever,
                            color: Colors.redAccent),
                        onPressed: () async {
                          await prefs.remove(_prefsKey);
                          setSheetState(() => list.clear());
                        },
                      )
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final pairJson = list[i];
                      Map<String, dynamic> pair;
                      try {
                        pair = json.decode(pairJson) as Map<String, dynamic>;
                      } catch (e) {
                        pair = {"user": pairJson, "bot": ""};
                      }
                      return Dismissible(
                        key: Key(pairJson + i.toString()),
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child:
                              const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) async {
                          list.removeAt(i);
                          await prefs.setStringList(_prefsKey, list);
                          setSheetState(() {});
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(pair['user'] ?? '',
                                  style: GoogleFonts.sourceCodePro()),
                              subtitle: Text(pair['bot'] ?? '',
                                  style: GoogleFonts.sourceCodePro()),
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 240.0, left: 12, right: 12, bottom: 12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.black12,
                child: IconButton(
                  icon: Image.asset('assets/history.png',
                      width: 20, color: Colors.black),
                  onPressed: _showHistory,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final m = messages[i];
                  final isUser = m['role'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.black87 : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        m['text'] ?? '',
                        style: GoogleFonts.sourceCodePro(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        hintStyle: GoogleFonts.sourceCodePro(),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: _send,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}