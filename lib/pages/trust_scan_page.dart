import 'package:flutter/material.dart';

class TrustScanPage extends StatelessWidget {
  const TrustScanPage({super.key});

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
            const Text(
              'Verify identity and documents',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2B36),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  const Icon(Icons.upload_file_rounded, size: 52, color: Color(0xFF7EC7F7)),
                  const SizedBox(height: 12),
                  const Text(
                    'Upload a document or scan a QR code to check if it is genuine.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF9FB7C7),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Camera scan selected')),
                            );
                          },
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Scan via camera'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7EC7F7),
                            foregroundColor: const Color(0xFF0F1720),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Document upload selected')),
                      );
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload document'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF7EC7F7)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Verification checks',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const _CheckRow(label: 'ID authenticity', value: 'Verified'),
            const _CheckRow(label: 'Document tampering', value: 'Clear'),
            const _CheckRow(label: 'QR token match', value: 'Valid'),
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
      decoration: BoxDecoration(
        color: const Color(0xFF1F2B36),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFB8F3C8).withOpacity(0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFB8F3C8),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
