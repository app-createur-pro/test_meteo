import 'package:go_router/go_router.dart';
import 'package:test_meteo/features/weather/presentation/pages/weather_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WeatherPage(),
      ),
    ],
  );
}
