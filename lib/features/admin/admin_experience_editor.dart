import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../experience/data/experience_repository.dart';
import '../experience/domain/experience_item.dart';

class AdminExperienceEditor extends ConsumerWidget {
  const AdminExperienceEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expAsync = ref.watch(experienceProvider);
    final repo = ref.read(experienceRepositoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Experience',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    final created = await showDialog<ExperienceItem>(
                      context: context,
                      builder: (_) => const _ExperienceDialog(),
                    );
                    if (created == null) return;
                    await repo.upsertExperience(created);
                    ref.invalidate(experienceProvider);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            expAsync.when(
              data: (items) {
                return Column(
                  children: [
                    for (final e in items)
                      ListTile(
                        title: Text('${e.company} — ${e.role}'),
                        subtitle: Text(e.period),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              onPressed: () async {
                                final updated = await showDialog<ExperienceItem>(
                                  context: context,
                                  builder: (_) => _ExperienceDialog(initial: e),
                                );
                                if (updated == null) return;
                                await repo.upsertExperience(updated);
                                ref.invalidate(experienceProvider);
                              },
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              onPressed: () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete experience?'),
                                    content: Text('Delete "${e.company}" entry'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (ok != true) return;
                                await repo.deleteExperience(e.id);
                                ref.invalidate(experienceProvider);
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text(e.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceDialog extends StatefulWidget {
  const _ExperienceDialog({this.initial});

  final ExperienceItem? initial;

  @override
  State<_ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends State<_ExperienceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _id;
  late final TextEditingController _company;
  late final TextEditingController _role;
  late final TextEditingController _period;
  late final TextEditingController _order;
  late final TextEditingController _bullets;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _id = TextEditingController(text: i?.id ?? '');
    _company = TextEditingController(text: i?.company ?? '');
    _role = TextEditingController(text: i?.role ?? '');
    _period = TextEditingController(text: i?.period ?? '');
    _order = TextEditingController(text: (i?.order ?? 0).toString());
    _bullets = TextEditingController(text: (i?.bullets ?? const []).join('\n'));
  }

  @override
  void dispose() {
    _id.dispose();
    _company.dispose();
    _role.dispose();
    _period.dispose();
    _order.dispose();
    _bullets.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initial != null;
    return AlertDialog(
      title: Text(editing ? 'Edit experience' : 'Add experience'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _id,
                  enabled: !editing,
                  decoration: const InputDecoration(
                    labelText: 'ID (doc id)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _company,
                  decoration: const InputDecoration(
                    labelText: 'Company',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _role,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _period,
                  decoration: const InputDecoration(
                    labelText: 'Period',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _order,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Order',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bullets,
                  minLines: 3,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Bullets (one per line)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            final bullets = _bullets.text
                .split('\n')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(growable: false);
            final item = ExperienceItem(
              id: _id.text.trim(),
              company: _company.text.trim(),
              role: _role.text.trim(),
              period: _period.text.trim(),
              order: int.tryParse(_order.text.trim()) ?? 0,
              bullets: bullets,
            );
            Navigator.pop(context, item);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

