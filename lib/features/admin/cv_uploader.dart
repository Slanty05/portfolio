import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/firebase/firebase_providers.dart';
import '../home/data/profile_repository.dart';
import '../home/domain/profile.dart';

class CvUploader extends ConsumerStatefulWidget {
  const CvUploader({super.key});

  @override
  ConsumerState<CvUploader> createState() => _CvUploaderState();
}

class _CvUploaderState extends ConsumerState<CvUploader> {
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Upload CV to Firebase Storage (cv/latest.pdf)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _uploading ? null : _pickAndUpload,
          icon: _uploading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload_file),
          label: const Text('Upload'),
        ),
      ],
    );
  }

  Future<void> _pickAndUpload() async {
    setState(() => _uploading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not read file bytes')),
        );
        return;
      }

      final storage = ref.read(storageProvider);
      final refObj = storage.ref('cv/latest.pdf');

      final metadata = SettableMetadata(
        contentType: 'application/pdf',
        cacheControl: 'public, max-age=300',
      );

      await refObj.putData(Uint8List.fromList(bytes), metadata);
      final url = await refObj.getDownloadURL();

      // Store URL in Firestore for easy access.
      final profile = await ref.read(profileProvider.future);
      await ref.read(profileRepositoryProvider).upsertProfile(
            Profile(
              name: profile.name,
              title: profile.title,
              summary: profile.summary,
              location: profile.location,
              email: profile.email,
              phone: profile.phone,
              linkedinUrl: profile.linkedinUrl,
              githubUrl: profile.githubUrl,
              cvUrl: url,
            ),
          );

      ref.invalidate(profileProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV uploaded and linked')),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? e.code)),
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }
}

