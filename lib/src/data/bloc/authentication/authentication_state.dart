part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class LoginInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class LoginFailed extends AuthenticationState {
  final String error;

  const LoginFailed(this.error);

  @override
  List<Object> get props => [error];
}

class IsAuthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class IsAdmin extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class IsUser extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class IsSuperAdmin extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class UnAuthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}
