import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/data/profile_repository.dart';
import '../home/domain/profile.dart';
import 'cv_uploader.dart';

class AdminProfileEditor extends ConsumerStatefulWidget {
  const AdminProfileEditor({super.key});

  @override
  ConsumerState<AdminProfileEditor> createState() => _AdminProfileEditorState();
}

class _AdminProfileEditorState extends ConsumerState<AdminProfileEditor> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _title = TextEditingController();
  final _summary = TextEditingController();
  final _location = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _linkedin = TextEditingController();
  final _github = TextEditingController();
  final _cvUrl = TextEditingController();

  bool _seeded = false;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _title.dispose();
    _summary.dispose();
    _location.dispose();
    _email.dispose();
    _phone.dispose();
    _linkedin.dispose();
    _github.dispose();
    _cvUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    ref.listen(profileProvider, (_, next) {
      final p = next.valueOrNull;
      if (p != null && !_seeded) {
        _seeded = true;
        _name.text = p.name;
        _title.text = p.title;
        _summary.text = p.summary;
        _location.text = p.location;
        _email.text = p.email;
        _phone.text = p.phone;
        _linkedin.text = p.linkedinUrl ?? '';
        _github.text = p.githubUrl ?? '';
        _cvUrl.text = p.cvUrl ?? '';
        setState(() {});
      }
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            profileAsync.when(
              data: (_) => _form(context),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => Text(e.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _field(_name, 'Name', required: true),
          const SizedBox(height: 12),
          _field(_title, 'Title', required: true),
          const SizedBox(height: 12),
          _field(_location, 'Location', required: true),
          const SizedBox(height: 12),
          _field(_email, 'Email', required: true),
          const SizedBox(height: 12),
          _field(_phone, 'Phone', required: true),
          const SizedBox(height: 12),
          _field(_linkedin, 'LinkedIn URL'),
          const SizedBox(height: 12),
          _field(_github, 'GitHub URL'),
          const SizedBox(height: 12),
          _field(_cvUrl, 'CV URL (optional override)'),
          const SizedBox(height: 12),
          TextFormField(
            controller: _summary,
            minLines: 3,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Summary',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          const CvUploader(),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {bool required = false}) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null : null,
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final profile = Profile(
        name: _name.text.trim(),
        title: _title.text.trim(),
        summary: _summary.text.trim(),
        location: _location.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        linkedinUrl: _linkedin.text.trim().isEmpty ? null : _linkedin.text.trim(),
        githubUrl: _github.text.trim().isEmpty ? null : _github.text.trim(),
        cvUrl: _cvUrl.text.trim().isEmpty ? null : _cvUrl.text.trim(),
      );
      await ref.read(profileRepositoryProvider).upsertProfile(profile);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

