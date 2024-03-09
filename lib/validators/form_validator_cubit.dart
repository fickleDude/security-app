import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit contains business logic and emits new states without events
class FormValidatorCubit extends Cubit<FormValidatorState> {
  FormValidatorCubit() : super(const FormValidatorUpdate());

  void initForm({
    String email = '',
    String name = '',
    String password = '',
    String confirmPassword = '',
    AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction,
    bool obscureText = true
  }) {
    emit(state.copyWith(
      email: email,
      name: name,
      password: password,
      confirmPassword: confirmPassword,
      autoValidateMode: autoValidateMode,
      obscureText: obscureText
    ));
  }

  void updateEmail(String? email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String? password) {
    emit(state.copyWith(password: password));
  }

  void updateConfirmPassword(String? confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  void updateName(String? name) {
    emit(state.copyWith(name: name));
  }

  void updateAutoValidateMode(AutovalidateMode? autoValidateMode) {
    emit(state.copyWith(autoValidateMode: autoValidateMode));
  }

  void toggleObscureText() {
    emit(state.copyWith(obscureText: !state.obscureText));
  }

  void reset() {
    emit(const FormValidatorUpdate());
  }
}

//MANAGE STATE
@immutable
abstract class FormValidatorState {
  final AutovalidateMode autoValidateMode;
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final bool obscureText;

  const FormValidatorState({
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.name = '',
    this.obscureText = true,
  });

  // used to create a new instance of a class with updated properties
  FormValidatorState copyWith({
    AutovalidateMode? autoValidateMode,
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    bool? obscureText,
  });
}

//MANAGE LOGIC
class FormValidatorUpdate extends FormValidatorState {

  const FormValidatorUpdate({
    AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction,
    String email = '',
    String password = '',
    String confirmPassword = '',
    String name = '',
    String address = '',
    String city = '',
    bool obscureText = true,
  }) : super(
    autoValidateMode: autoValidateMode,
    email: email,
    password: password,
    confirmPassword: confirmPassword,
    name: name,
    obscureText: obscureText,
  );

  @override
  FormValidatorUpdate copyWith({
    AutovalidateMode? autoValidateMode,
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    bool? obscureText,
  }) {
    return FormValidatorUpdate(
      autoValidateMode: autoValidateMode ?? this.autoValidateMode,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      obscureText: obscureText ?? this.obscureText,
    );
  }
}