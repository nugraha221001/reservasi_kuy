part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class InitialLogin extends AuthenticationEvent {}

class OnLogin extends AuthenticationEvent {
  final String username;
  final String password;

  const OnLogin(this.username, this.password);
}

