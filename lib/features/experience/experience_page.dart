import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/ui/app_states.dart';
import '../home/data/cv_repository.dart';
import 'data/experience_repository.dart';
import 'data/models/experience_model.dart';

class ExperiencePage extends ConsumerWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rolesAsync = ref.watch(experienceModelsProvider);
    final cvAsync = ref.watch(cvUrlProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 140,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Experience'),
            background: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.secondaryContainer,
                    theme.colorScheme.surface,
                  ],
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
                spacing: 8,
                runSpacing: 8,
                children: [
                  if ((cvAsync.valueOrNull ?? '').isNotEmpty)
                    FilledButton.icon(
                      onPressed: () => _open(cvAsync.valueOrNull!),
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Download CV'),
                    ),
                  OutlinedButton.icon(
                    onPressed: () => _open('https://wa.me/923052806778'),
                    icon: const Icon(Icons.chat),
                    label: const Text('WhatsApp Contact'),
                  ),
                ],
              ).animate().fadeIn(duration: 240.ms),
              const SizedBox(height: 12),
              rolesAsync.when(
                data: (roles) {
                  if (roles.isEmpty) {
                    return AppEmptyState(
                      title: 'No experience yet',
                      message:
                          'Add documents inside `portfolio_experience` (e.g. `experts_consulting`, `mtpixels`).',
                      actionLabel: 'Refresh',
                      onAction: () => ref.invalidate(experienceModelsProvider),
                      icon: Icons.timeline_outlined,
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < roles.length; i++) ...[
                        ExperienceShowcaseCard(model: roles[i])
                            .animate()
                            .fadeIn(delay: (80 * i).ms, duration: 300.ms)
                            .slideY(begin: 0.12, end: 0, duration: 300.ms),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                },
                loading: () => const AppLoadingState(message: 'Loading experience...'),
                error: (e, st) => AppErrorState(
                  title: 'Could not load experience',
                  message: e.toString(),
                  actionLabel: 'Retry',
                  onAction: () => ref.invalidate(experienceModelsProvider),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class ExperienceShowcaseCard extends StatelessWidget {
  const ExperienceShowcaseCard({super.key, required this.model});

  final ExperienceModel model;

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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CompanyBadge(
                    logoUrl: model.companyLogo,
                    fallbackText: model.companyName,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.companyName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${model.role} · ${model.period}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (model.highlights.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (final b in model.highlights.take(6))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(b)),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyBadge extends StatelessWidget {
  const _CompanyBadge({required this.logoUrl, required this.fallbackText});

  final String logoUrl;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = (fallbackText.trim().isEmpty ? 'C' : fallbackText.trim()).toUpperCase();
    final letter = text.characters.first;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.18),
            theme.colorScheme.secondary.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
      ),
    );
  }
}

