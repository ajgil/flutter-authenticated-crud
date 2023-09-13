import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';

//* creamos un provider riverpod para gestionar las rutas
//* lo hacemos como un provider normal ya que no vamos a cambiar
final goRouterProvider = Provider((ref) {
  //* leemos la instancia del go router notifier provider
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
      initialLocation: '/splash',
      refreshListenable: goRouterNotifier,
      routes: [
        //* Primera pantalla
        ///
        GoRoute(
          path: '/splash',
          builder: (context, state) => const CheckAuthStatusScreen(),
        ),

        //* Auth Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        //* Product Routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductsScreen(),
        ),
      ],
      redirect: ((context, state) {
        //* a donde va y si está autenticado o no
        final isGoingTo = state.subloc;
        final authStatus = goRouterNotifier.authStatus;

        print('GoRouter authStatus $authStatus, isGoingTo $isGoingTo');

        if (isGoingTo == '/splash' && authStatus == AuthStatus.checking)
          return null;
        if (authStatus == AuthStatus.notAuthenticated) {
          if (isGoingTo == '/login' || isGoingTo == '/register') return null;
          return '/login';
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isGoingTo == '/login' ||
              isGoingTo == '/register' ||
              isGoingTo == '/splash') return '/';
        }

        //* hay que traerse el user para hacer las redirecciones de los roles
        // if (user.isAdmin && authStatus == AuthStatus.authenticated) return '/admin';

        //* de aqui para abajo, todas las rutas van a estar autenticadas
        return null;
      }));
});
