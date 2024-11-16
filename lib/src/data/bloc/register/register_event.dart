part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

final class InitialRegisterEvent extends RegisterEvent {}

class Register extends RegisterEvent {
  final String agency;
  final String username;
  final String password;
  final String fullName;
  final String role;

  const Register(
    this.agency,
    this.username,
    this.password,
    this.fullName,
    this.role,
  );
}

class GetAllUserAdmin extends RegisterEvent {}

class GetAllUserSuperAdmin extends RegisterEvent {}

class EditUserAdmin extends RegisterEvent {
  final String id;
  final String agency;
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phone;

  const EditUserAdmin(
    this.id,
    this.agency,
    this.username,
    this.password,
    this.fullName,
    this.email,
    this.phone,
  );
}

class ChangeUsername extends RegisterEvent {
  final String id;
  final String username;

  const ChangeUsername(
    this.id,
    this.username,
  );
}

class DeleteUser extends RegisterEvent {
  final String id;

  const DeleteUser(this.id);
}

class DeleteUserSuperAdmin extends RegisterEvent {
  final String agency;

  const DeleteUserSuperAdmin(this.agency);
}
