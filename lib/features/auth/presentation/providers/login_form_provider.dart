import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';
// como crear el provider


//! 3 - StateNotifierProvider -> el consumidor desde fuera
// autoDispose -> limpia el formulario una vez llamado
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {

      final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(
    loginUserCallback: loginUserCallback
  );
});

//! 2 - Como implementamos un notifier (statenotifier)

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;
  // en el constructor siempre se llama la construcción del estado inicial
  LoginFormNotifier({required this.loginUserCallback}) : super(LoginFormState());

  // metodos
  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSubmit() {
    
    _touchEveryField();
    if (!state.isValid) return;

    //* bloquear el boton de login usando isPosting
    state = state.copyWith( isPosting: true);

    loginUserCallback(state.email.value, state.password.value);
    
    state = state.copyWith( isPosting: false);
  }

  _touchEveryField() {
    // en su estado inicial son pure y hay que tocar cada campo
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

//! 1 - State del provider
class LoginFormState {
  // como queremos que luzca el
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  // crear el copyWith
  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password);

  @override
  String toString() {
    return '''
    LoginFormState:
      isPosting $isPosting,
      isFormPosted $isFormPosted,
      isValid $isValid,
      email $email,
      password $password
''';
  }
}

