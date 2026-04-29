import 'package:go_router/go_router.dart';
import '../../features/calculator/presentation/screens/calculator_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CalculatorScreen(),
    ),
  ],
);
