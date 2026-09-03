import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static GoRouter createRouter({String initialLocation = AppRoutes.splash}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.splash,
          name: ScreenNames.splash,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.home,
          name: ScreenNames.home,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
      errorBuilder: (BuildContext context, GoRouterState state) {
        return Scaffold(
          body: Center(
            child: Text('Route error: ${state.error}'),
          ),
        );
      },
    );
  }

  static GoRouter router = createRouter();
}

final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter();
});
