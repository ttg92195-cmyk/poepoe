import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PoePoeApp()));
}

class PoePoeApp extends StatelessWidget {
  const PoePoeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.build();
    return MaterialApp.router(
      title: 'PoePoe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
