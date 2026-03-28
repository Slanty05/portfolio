import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../projects/data/projects_repository.dart';
import '../projects/domain/project_item.dart';

class AdminProjectsEditor extends ConsumerWidget {
  const AdminProjectsEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    final repo = ref.read(projectsRepositoryProvider);

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
                    'Projects',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    final created = await showDialog<ProjectItem>(
                      context: context,
                      builder: (_) => const _ProjectDialog(),
                    );
                    if (created == null) return;
                    await repo.upsertProject(created);
                    ref.invalidate(projectsProvider);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            projectsAsync.when(
              data: (items) {
                return Column(
                  children: [
                    for (final p in items)
                      ListTile(
                        title: Text(p.title),
                        subtitle: Text(p.description),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              onPressed: () async {
                                final updated = await showDialog<ProjectItem>(
                                  context: context,
                                  builder: (_) => _ProjectDialog(initial: p),
                                );
                                if (updated == null) return;
                                await repo.upsertProject(updated);
                                ref.invalidate(projectsProvider);
                              },
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              onPressed: () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete project?'),
                                    content: Text('Delete "${p.title}"'),
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
                                await repo.deleteProject(p.id);
                                ref.invalidate(projectsProvider);
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

class _ProjectDialog extends StatefulWidget {
  const _ProjectDialog({this.initial});

  final ProjectItem? initial;

  @override
  State<_ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<_ProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _id;
  late final TextEditingController _title;
  late final TextEditingController _desc;
  late final TextEditingController _order;
  late final TextEditingController _tags;
  late final TextEditingController _repoUrl;
  late final TextEditingController _liveUrl;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _id = TextEditingController(text: i?.id ?? '');
    _title = TextEditingController(text: i?.title ?? '');
    _desc = TextEditingController(text: i?.description ?? '');
    _order = TextEditingController(text: (i?.order ?? 0).toString());
    _tags = TextEditingController(text: (i?.tags ?? const []).join(', '));
    _repoUrl = TextEditingController(text: i?.repoUrl ?? '');
    _liveUrl = TextEditingController(text: i?.liveUrl ?? '');
  }

  @override
  void dispose() {
    _id.dispose();
    _title.dispose();
    _desc.dispose();
    _order.dispose();
    _tags.dispose();
    _repoUrl.dispose();
    _liveUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initial != null;
    return AlertDialog(
      title: Text(editing ? 'Edit project' : 'Add project'),
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
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _desc,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
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
                  controller: _tags,
                  decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _repoUrl,
                  decoration: const InputDecoration(
                    labelText: 'Repo URL (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _liveUrl,
                  decoration: const InputDecoration(
                    labelText: 'Live URL (optional)',
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
            final tags = _tags.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(growable: false);
            final item = ProjectItem(
              id: _id.text.trim(),
              title: _title.text.trim(),
              description: _desc.text.trim(),
              order: int.tryParse(_order.text.trim()) ?? 0,
              tags: tags,
              repoUrl: _repoUrl.text.trim().isEmpty ? null : _repoUrl.text.trim(),
              liveUrl: _liveUrl.text.trim().isEmpty ? null : _liveUrl.text.trim(),
            );
            Navigator.pop(context, item);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

