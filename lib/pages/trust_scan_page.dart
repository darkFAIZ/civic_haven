import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/data_service.dart';

class TrustScanPage extends StatefulWidget {
  const TrustScanPage({super.key});

  @override
  State<TrustScanPage> createState() => _TrustScanPageState();
}

class _TrustScanPageState extends State<TrustScanPage> {
  final imagePicker = ImagePicker();
  bool busy = false;
  String? selectedFile;
  String? resultMessage;

  Future<void> scanWithCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (image == null) return;
    await saveDocument(await image.readAsBytes(), image.name, 'camera scan');
  }

  Future<void> uploadDocument() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null || result.files.single.bytes == null) return;
    final file = result.files.single;
    await saveDocument(file.bytes!, file.name, 'document upload');
  }

  Future<void> saveDocument(Uint8List bytes, String name, String source) async {
    setState(() {
      busy = true;
      selectedFile = name;
      resultMessage = null;
    });
    try {
      final url = await DataService.instance.uploadBytes(
        bytes: bytes,
        fileName: name,
        folder: 'trust-scans',
      );
      await DataService.instance.addHistory(
        type: 'document_scan',
        title: 'Document scanned',
        details: {'fileName': name, 'source': source, 'downloadUrl': url},
      );
      setState(() => resultMessage = 'Document uploaded and saved to your history.');
    } catch (_) {
      setState(() => resultMessage = 'Upload failed. Check Firebase Storage and try again.');
    } finally {
      setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1720),
        foregroundColor: Colors.white,
        title: const Text('Trust scan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const Text('Verify identity and documents', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: const Color(0xFF1F2B36), borderRadius: BorderRadius.circular(22)),
              child: Column(
                children: [
                  const Icon(Icons.upload_file_rounded, size: 52, color: Color(0xFF7EC7F7)),
                  const SizedBox(height: 12),
                  const Text('Scan with your phone camera or upload a document from your files.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF9FB7C7), fontSize: 15)),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: busy ? null : scanWithCamera,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Scan via camera'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7EC7F7), foregroundColor: const Color(0xFF0F1720), padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: busy ? null : uploadDocument,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload document'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Color(0xFF7EC7F7)), padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                  if (busy) ...const [SizedBox(height: 16), CircularProgressIndicator()],
                  if (selectedFile != null) ...[
                    const SizedBox(height: 16),
                    Text(selectedFile!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                  if (resultMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(resultMessage!, style: const TextStyle(color: Color(0xFFB8F3C8))),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('Verification checks', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const _CheckRow(label: 'ID authenticity', value: 'Pending scan'),
            const _CheckRow(label: 'Document tampering', value: 'Pending scan'),
            const _CheckRow(label: 'QR token match', value: 'Pending scan'),
          ],
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1F2B36), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: Color(0xFFB8F3C8), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
