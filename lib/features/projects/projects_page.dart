import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/responsive/breakpoints.dart';
import '../../core/ui/app_states.dart';
import 'data/projects_repository.dart';
import 'data/models/project_model.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final projectsAsync = ref.watch(projectModelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        centerTitle: false,
      ),
      body: projectsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return AppEmptyState(
              title: 'No projects yet',
              message:
                  'Add documents inside `portfolio_projects` (e.g. `humsafar`, `jab_chaho`).',
              actionLabel: 'Refresh',
              onAction: () => ref.invalidate(projectModelsProvider),
              icon: Icons.work_outline,
            );
          }

          final width = MediaQuery.sizeOf(context).width;
          final columns = Breakpoints.projectGridCrossAxisCount(width);
          final tileExtent = Breakpoints.projectGridMainAxisExtent(width);

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Featured Projects',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate().fadeIn(duration: 250.ms),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: tileExtent,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ProjectShowcaseCard(model: items[index])
                          .animate()
                          .fadeIn(delay: (80 * index).ms, duration: 300.ms)
                          .slideY(begin: 0.12, end: 0, duration: 300.ms);
                    },
                    childCount: items.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const AppLoadingState(message: 'Loading projects...'),
        error: (e, st) => AppErrorState(
          title: 'Could not load projects',
          message: e.toString(),
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(projectModelsProvider),
        ),
      ),
    );
  }
}

class ProjectShowcaseCard extends StatelessWidget {
  const ProjectShowcaseCard({super.key, required this.model});

  final ProjectModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = [
      if (model.category.trim().isNotEmpty) model.category.trim(),
      if (model.client.trim().isNotEmpty) 'Client: ${model.client.trim()}',
    ].join(' · ');
    final description = model.description.isEmpty ? '' : model.description.first;

    return Card(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _LogoCircle(logoUrl: model.logo, fallbackText: model.client),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (description.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  description.trim(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
              if (model.techIds.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'Tech Stack',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in model.techIds.take(10)) _TechChip(label: t),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (model.stackUrl.googlePlayStoreUrl.trim().isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => _open(model.stackUrl.googlePlayStoreUrl),
                      icon: const Icon(Icons.shop_outlined),
                      label: const Text('Play Store'),
                    ),
                  if (model.stackUrl.appleStoreUrl.trim().isNotEmpty)
                    FilledButton.icon(
                      onPressed: () => _open(model.stackUrl.appleStoreUrl),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('App Store'),
                    ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _LogoCircle extends StatelessWidget {
  const _LogoCircle({required this.logoUrl, required this.fallbackText});

  final String logoUrl;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = (fallbackText.trim().isEmpty ? 'P' : fallbackText.trim()).toUpperCase();
    final letter = text.characters.first;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.2),
            theme.colorScheme.tertiary.withValues(alpha: 0.14),
          ],
        ),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  const _TechChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

