import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/src/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/repositories.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  Repositories repositories;

  UserBloc({required this.repositories}) : super(UserInitial()) {
    on<InitialUser>(_initialUser);
    on<GetUserLoggedIn>(_getUserLoggedIn);
    on<EditSingleUser>(_editSingleUser);
    on<EditProfilePicture>(_editProfilePicture);
    on<EditPassword>(_editPassword);
  }

  _initialUser(InitialUser event, Emitter<UserState> emit) {
    emit(UserInitial());
  }

  /// mendapatkan info user (logged id)
  _getUserLoggedIn(GetUserLoggedIn event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final username = await _getUsername();
      final user = await repositories.user.getUser(username);
      if (repositories.user.statusCode == "200") {
        emit(UserGetSuccess(user));
      } else {
        emit(UserGetFailed());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// edit single user (logged in)
  _editSingleUser(EditSingleUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await repositories.user.editUser(
        event.id,
        event.agency,
        event.username,
        event.password,
        event.fullName,
        event.email,
        event.phone,
      );
      if (repositories.user.statusCode == "200") {
        emit(EditSingleUserSuccess());
        add(GetUserLoggedIn());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// edit profile picture single user (logged in)
  _editProfilePicture(EditProfilePicture event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await repositories.user.editProfilePicture(
        event.id,
        event.image,
      );
      if (repositories.user.statusCode == "200") {
        emit(EditSingleUserSuccess());
        add(GetUserLoggedIn());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// edit password single user (logged in)
  _editPassword(EditPassword event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await repositories.user.editPassword(
        event.id,
        event.username,
        event.oldPassword,
        event.newPassword,
      );
      if (repositories.user.error == "") {
        emit(EditPasswordSuccess());
        add(GetUserLoggedIn());
      } else {
        emit(EditPasswordFailed(repositories.user.error));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Get Token or Username
  _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user");
  }
}
