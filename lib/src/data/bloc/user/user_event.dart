part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class InitialUser extends UserEvent {}

class GetUserLoggedIn extends UserEvent {}

class EditSingleUser extends UserEvent {
  final String id;
  final String agency;
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phone;

  const EditSingleUser(
    this.id,
    this.agency,
    this.username,
    this.password,
    this.fullName,
    this.email,
    this.phone,
  );
}

class EditProfilePicture extends UserEvent {
  final String id;
  final String image;

  const EditProfilePicture(
    this.id,
    this.image,
  );
}

class EditPassword extends UserEvent {
  final String id;
  final String username;
  final String oldPassword;
  final String newPassword;

  const EditPassword(
    this.id,
    this.username,
    this.oldPassword,
    this.newPassword,
  );
}
