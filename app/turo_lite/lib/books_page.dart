// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  final List<Map<String, String>> books = const [
    {"title": "Disaster Management", "asset": "assets/Disaster_Management.pdf"},
    {"title": "RPGS", "asset": "assets/RPGS.pdf"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 240.0),
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, idx) {
            final b = books[idx];
            return Card(
              color: Colors.white,
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.book, color: Colors.black),
                title: Text(
                  b["title"]!,
                  style: GoogleFonts.sourceCodePro(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.black),
                      tooltip: "Download PDF",
                      onPressed: () =>
                          _downloadPdf(context, b["asset"]!, b["title"]!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.open_in_new, color: Colors.black),
                      tooltip: "Open PDF",
                      onPressed: () =>
                          _openPdf(context, b["asset"]!, b["title"]!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ✅ Opens the PDF after copying it to a readable temp file
  Future<void> _openPdf(
      BuildContext context, String assetPath, String title) async {
    try {
      final file = await _copyAssetToTemp(assetPath);
      if (file == null || !await file.exists()) {
        throw Exception("File copy failed");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PDFViewPage(filePath: file.path, title: title),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to open file: $e")),
      );
    }
  }

  /// ✅ Downloads the PDF safely with permission handling
  Future<void> _downloadPdf(
      BuildContext context, String assetPath, String title) async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Storage permission required")),
          );
          return;
        }
      }

      final bytes = await rootBundle.load(assetPath);
      final data = bytes.buffer.asUint8List();

      Directory? targetDir;
      if (Platform.isAndroid) {
        targetDir = await getExternalStorageDirectory();
      } else {
        targetDir = await getApplicationDocumentsDirectory();
      }

      final savePath = '${targetDir!.path}/$title.pdf';
      final file = File(savePath);
      await file.writeAsBytes(data, flush: true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved to $savePath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    }
  }

  /// ✅ Copies an asset to the temporary directory safely
  Future<File?> _copyAssetToTemp(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();

      final fileName = assetPath.split('/').last;
      final file = File('${tempDir.path}/$fileName');

      await file.writeAsBytes(bytes, flush: true);
      return file;
    } catch (e) {
      debugPrint("Error copying asset: $e");
      return null;
    }
  }
}

/// ✅ Displays the PDF in a new page using flutter_pdfview
class PDFViewPage extends StatelessWidget {
  final String filePath;
  final String title;

  const PDFViewPage({super.key, required this.filePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.sourceCodePro(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error loading PDF: $error")),
          );
        },
      ),
    );
  }
}