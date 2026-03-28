import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/cv_repository.dart';
import 'data/profile_repository.dart';
import 'data/skills_repository.dart';
import '../../core/ui/app_states.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(profileProvider);
    final cvAsync = ref.watch(cvUrlProvider);
    final skillsAsync = ref.watch(skillsProvider);
    return profileAsync.when(
      data: (profile) {
        final cvUrl = cvAsync.valueOrNull;
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 230,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(profile.name, overflow: TextOverflow.ellipsis),
                background: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.surface,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'portfolio_logo',
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: theme.colorScheme.primary,
                              child: Icon(
                                Icons.flutter_dash_rounded,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(profile.title, style: theme.textTheme.titleMedium),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.list(
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _MetaChip(icon: Icons.location_on_outlined, text: profile.location),
                      _MetaChip(icon: Icons.email_outlined, text: profile.email),
                      _MetaChip(icon: Icons.phone_outlined, text: profile.phone),
                    ],
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
                  const SizedBox(height: 16),
                  _InfoCard(title: 'Summary', body: profile.summary)
                      .animate()
                      .fadeIn(delay: 180.ms, duration: 350.ms)
                      .slideY(begin: 0.1, end: 0, duration: 350.ms),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (cvUrl != null && cvUrl.trim().isNotEmpty)
                        FilledButton.icon(
                          onPressed: () => _open(cvUrl),
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: const Text('Download CV'),
                        ),
                      FilledButton.tonalIcon(
                        onPressed: () => _open(
                          'https://www.linkedin.com/in/muhammad-abu-bakar-300725203',
                        ),
                        icon: const Icon(Icons.business_center_outlined),
                        label: const Text('LinkedIn'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => _open('https://www.instagram.com/bakar0531/'),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Instagram'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _open('https://wa.me/923052806778'),
                        icon: const Icon(Icons.chat_outlined),
                        label: const Text('WhatsApp'),
                      ),
                    ],
                  ).animate().fadeIn(delay: 250.ms, duration: 350.ms),
                  const SizedBox(height: 14),
                  skillsAsync.when(
                    data: (groups) {
                      if (groups.isEmpty) {
                        return AppEmptyState(
                          title: 'No skills yet',
                          message:
                              'Add documents inside `portfolio_skills` (e.g. `languages`, `state_management`).',
                          actionLabel: 'Refresh',
                          onAction: () => ref.invalidate(skillsProvider),
                          icon: Icons.school_outlined,
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Skills',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          for (final group in groups) ...[
                            _SkillGroupCard(category: group.category, skills: group.skills),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ).animate().fadeIn(delay: 320.ms, duration: 350.ms);
                    },
                    loading: () => const AppLoadingState(message: 'Loading skills...'),
                    error: (e, st) => AppErrorState(
                      title: 'Could not load skills',
                      message: e.toString(),
                      actionLabel: 'Retry',
                      onAction: () => ref.invalidate(skillsProvider),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _InfoCard(title: 'Could not load profile', body: e.toString()),
        ),
      ),
    );
  }

  Future<void> _open(String link) async {
    final uri = Uri.tryParse(link.trim());
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(text));
  }
}

class _SkillGroupCard extends StatelessWidget {
  const _SkillGroupCard({required this.category, required this.skills});

  final String category;
  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final s in skills) _Chip(text: s)],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
    );
  }
}

