import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DecoratedBox(
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'portfolio_logo',
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(
                    Icons.flutter_dash_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 42,
                  ),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1), duration: 900.ms),
              const SizedBox(height: 14),
              Text(
                'Muhammad Abu Bakar',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 6),
              Text(
                'Flutter Developer Portfolio',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}

