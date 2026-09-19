import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/data_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Suspicious broker demanding advance payment');
  final _locationController = TextEditingController(text: 'Jalan Merdeka 4');
  final _detailsController = TextEditingController(
    text: 'He asked for an upfront fee for a room and refused to show the contract details.',
  );
  String selectedCategory = 'Scam / exploitation';
  double severity = 8;
  final imagePicker = ImagePicker();
  Uint8List? evidenceBytes;
  String? evidenceName;
  String? evidenceUrl;
  bool busy = false;
  final List<Map<String, dynamic>> reports = [
    {'title': 'Fake rental agreement', 'status': 'Verified', 'type': 'Scam / exploitation'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> pickEvidence() async {
    final source = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Take a photo'), onTap: () => Navigator.pop(context, 'camera')),
            ListTile(leading: const Icon(Icons.upload_file), title: const Text('Choose from files'), onTap: () => Navigator.pop(context, 'file')),
          ],
        ),
      ),
    );
    if (source == 'camera') {
      final image = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) {
        evidenceBytes = await image.readAsBytes();
        evidenceName = image.name;
      }
    } else if (source == 'file') {
      final result = await FilePicker.platform.pickFiles(withData: true);
      if (result != null && result.files.single.bytes != null) {
        evidenceBytes = result.files.single.bytes;
        evidenceName = result.files.single.name;
      }
    }
    if (mounted && evidenceName != null) setState(() {});
  }

  Future<void> submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      if (evidenceBytes != null && evidenceName != null) {
        evidenceUrl = await DataService.instance.uploadBytes(
          bytes: evidenceBytes!,
          fileName: evidenceName!,
          folder: 'report-evidence',
        );
      }
      await DataService.instance.addHistory(
        type: 'report',
        title: _titleController.text,
        details: {
          'category': selectedCategory,
          'location': _locationController.text,
          'details': _detailsController.text,
          'severity': severity.round(),
          'evidenceName': evidenceName,
          'evidenceUrl': evidenceUrl,
        },
      );
      reports.insert(0, {'title': _titleController.text, 'status': 'Submitted', 'type': selectedCategory});
      if (mounted) {
        setState(() => busy = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report saved to your history')));
      }
    } catch (_) {
      if (mounted) {
        setState(() => busy = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not save report. Check Firebase and try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1720),
        foregroundColor: Colors.white,
        title: const Text('Report incident'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Submit a safety concern',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: _fieldDecoration('Category'),
                  dropdownColor: const Color(0xFF1F2B36),
                  items: const [
                    DropdownMenuItem(value: 'Scam / exploitation', child: Text('Scam / exploitation')),
                    DropdownMenuItem(value: 'Safety risk', child: Text('Safety risk')),
                    DropdownMenuItem(value: 'Housing issue', child: Text('Housing issue')),
                    DropdownMenuItem(value: 'Medical concern', child: Text('Medical concern')),
                  ],
                  onChanged: (value) => setState(() => selectedCategory = value ?? selectedCategory),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _fieldDecoration('Title'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _locationController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _fieldDecoration('Location'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _detailsController,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white),
                  decoration: _fieldDecoration('Details'),
                ),
                const SizedBox(height: 18),
                Text(
                  'Severity: ${severity.round()}/10',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Slider(
                  value: severity,
                  max: 10,
                  divisions: 10,
                  activeColor: const Color(0xFF7EC7F7),
                  onChanged: (value) => setState(() => severity = value),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: busy ? null : pickEvidence,
                        icon: const Icon(Icons.attach_file),
                        label: Text(evidenceName == null ? 'Attach evidence' : 'Attached: $evidenceName'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF7EC7F7)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: busy ? null : submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7EC7F7),
                    foregroundColor: const Color(0xFF0F1720),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Submit report',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Recent reports',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...reports.map((report) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2B36),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7EC7F7).withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.assessment_rounded, color: Color(0xFF7EC7F7)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report['title'],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              report['type'],
                              style: const TextStyle(color: Color(0xFF9FB7C7), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8F3C8).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          report['status'],
                          style: const TextStyle(
                            color: Color(0xFFB8F3C8),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFF9FB7C7)),
    filled: true,
    fillColor: const Color(0xFF1F2B36),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF334759)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF7EC7F7)),
    ),
  );
}
