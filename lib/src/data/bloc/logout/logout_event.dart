part of 'logout_bloc.dart';

sealed class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

final class OnLogout extends LogoutEvent {}

final class InitialLogout extends LogoutEvent {}
