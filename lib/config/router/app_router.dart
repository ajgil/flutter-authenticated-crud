import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';

//* creamos un provider riverpod para gestionar las rutas
//* lo hacemos como un provider normal ya que no vamos a cambiar
final goRouterProvider = Provider((ref) {

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      ///* Primera pantalla
      ///
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
    ],
    redirect: ((context, state) {
      //return '/login';
      return null;
    })
  );
});
