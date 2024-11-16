part of 'logout_bloc.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();
}

final class LogoutInitial extends LogoutState {
  @override
  List<Object> get props => [];
}

final class LogoutSuccess extends LogoutState {
  @override
  List<Object> get props => [];
}

final class LogoutLoading extends LogoutState {
  @override
  List<Object> get props => [];
}
