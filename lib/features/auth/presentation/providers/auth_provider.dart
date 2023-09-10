import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/infrastructure.dart';

// paso 2 crear el provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // estos metodos terminan delegando al repositorio por tanto creamos
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

// paso 1 crear los métodos y el state
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository})
      : super(AuthState()); //estado inicial

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // ralentizamos el loading para poder ver

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
      
    } on WrongCredentials {
      logout('Credenciales incorrectas');
    } catch (e) {
      logout('Error no controlado');
    }
    
    //state = state.copyWith(user: user, authStatus: AuthStatus.authenticated);
  } // estos metodos terminan delegando al repositorio

  void registerUser(String email, String password, String fullName) async {}

  void checkAuthStatus(String token) async {}

  // metodo privado que centraliza a los anteriores
  void _setLoggedUser(User user) {
    // todo -> necesito guardar token en el dispositivo en local
    state = state.copyWith(user: user, 
    errorMessage: '',
    authStatus: AuthStatus.authenticated);
  }

  Future<void> logout([String? errorMessage]) async {
    // todo -> limpiar token
    state = state.copyWith(user: null, 
    errorMessage: errorMessage,
    authStatus: AuthStatus.notAuthenticated);
  }
}

// enum para ver los estados del usuario
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  //coypwith
  AuthState copyWith(
          {AuthStatus? authStatus, User? user, String? errorMessage}) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
