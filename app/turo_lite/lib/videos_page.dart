import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  final List<Map<String, String>> videos = const [
    {"title": "Disaster Management", "url": "https://youtu.be/BaWnRznp1AU?si=hqw76Fzv2oBEAsoH"},
    {"title": "RPGS Wind Turbine", "url": "https://youtu.be/Hf875eOVrVI?si=Uc9__OmoXkvt0-Uf"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 240.0),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, i) {
            final v = videos[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Image.asset(
                  'assets/play_button.png',
                  width: 28,  // smaller size
                  height: 28,
                ),
                title: Text(
                  v['title']!,
                  style: GoogleFonts.sourceCodePro(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
                onTap: () => _openLink(v['url']!),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // fail silently
    }
  }
}
