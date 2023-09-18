import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infraestructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infraestructure/services/key_value_storage_service_impl.dart';

//! paso 2 crear el provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // estos metodos terminan delegando al repositorio por tanto creamos
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl(); // crear instancia

  // inyectamos todo el servicio al Notifier
  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

//! paso 1 crear los métodos y el state
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService; 

  AuthNotifier(
      {required this.authRepository, required this.keyValueStorageService})
      : super(AuthState()){ checkAuthStatus();} //estado inicial

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(
        milliseconds: 500)); // ralentizamos el loading para poder ver

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }

    //state = state.copyWith(user: user, authStatus: AuthStatus.authenticated);
  } // estos metodos terminan delegando al repositorio

  void registerUser(String email, String password, String fullName) async {}

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');

    if (token ==null) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
      
    }
  }

  // metodo privado que centraliza a los anteriores
  void _setLoggedUser(User user) async {
    // todo -> necesito guardar token en el dispositivo en local
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
        user: user, errorMessage: '', authStatus: AuthStatus.authenticated);
  }

  Future<void> logout([String? errorMessage]) async {
    // todo -> limpiar token
    await keyValueStorageService.removeKey('token');
    state = state.copyWith(
        user: null,
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
