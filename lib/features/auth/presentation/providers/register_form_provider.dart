import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

// como crear el provider

// 3 - StateNotifierProvider -> el consumidor desde fuera
// autoDispose -> limpia el formulario una vez llamado
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  return RegisterFormNotifier();
});

// 2 - Como implementamos un notifier (statenotifier)
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  // en el constructor siempre se llama la construcción del estado inicial
  RegisterFormNotifier() : super(RegisterFormState());

  // metodos
  onNameChange(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
        name: newName,
        isValid: Formz.validate([newName, state.email, state.password]));
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([newEmail, state.name, state.password]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.name, state.email]));
  }

  onFormSubmit() {
    //todo -> algo
    _touchEveryField();
    if (!state.isValid) return;

    print(state);
  }

  _touchEveryField() {
    // en su estado inicial son pure y hay que tocar cada campo
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        name: name,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

// 1 - State del provider
class RegisterFormState {
  // como queremos que luzca el
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Email email;
  final Password password;
  //final RepeatPassword repeatPassword;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.name = const Name.pure(),
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  // crear el copyWith
  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    Email? email,
    Password? password,
  }) =>
      RegisterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          name: name ?? this.name,
          email: email ?? this.email,
          password: password ?? this.password);

  @override
  String toString() {
    return '''
    LoginFormState:
      isPosting $isPosting,
      isFormPosted $isFormPosted,
      isValid $isValid,
      name $name,
      email $email,
      password $password
''';
  }
}
