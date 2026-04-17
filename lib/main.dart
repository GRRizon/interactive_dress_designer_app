import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'providers/auth_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    // Flutter's equivalent to <AuthProvider>
    // We use MultiProvider to make it easy to add more state later
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const FashionAIApp(),
    ),
  );
}

class FashionAIApp extends StatelessWidget {
  const FashionAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Flutter's equivalent to <RouterProvider>
    return MaterialApp.router(
      title: 'AI Fashion Designer',
      debugShowCheckedModeBanner: false,
      
      // We apply the UI Theme here so all buttons/cards 
      // automatically look like your Shadcn UI components
      theme: AppTheme.lightTheme, 
      darkTheme: AppTheme.darkTheme,
      
      // Configuration for go_router (The Flutter equivalent of react-router)
      routerConfig: AppRouter.router,
    );
  }
}