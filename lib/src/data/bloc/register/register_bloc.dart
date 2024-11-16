import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import '../../repositories/repositories.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  Repositories repositories;

  RegisterBloc({required this.repositories}) : super(RegisterInitialState()) {
    on<InitialRegisterEvent>(initialRegister);
    on<Register>(register);
    on<GetAllUserAdmin>(getAllUserAdmin);
    on<GetAllUserSuperAdmin>(getAllUserSuperAdmin);
    on<DeleteUser>(deleteUser);
    on<DeleteUserSuperAdmin>(deleteUserSuperAdmin);
    on<EditUserAdmin>(editUserAdmin);
    on<ChangeUsername>(changeUsername);
  }

  /// umum: initial register
  initialRegister(InitialRegisterEvent event, Emitter<RegisterState> emit) {
    emit(RegisterInitialState());
  }

  /// admin dan super admin: tambah user
  register(Register event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final userRole = await _getRole();
      await repositories.user.register(
        event.agency,
        event.username,
        event.password,
        event.fullName,
        event.role,
      );

      if (repositories.user.error == "") {
        emit(RegisterSuccess());
        if (userRole == "0") {
          add(GetAllUserSuperAdmin());
        } else if (userRole == "1") {
          add(GetAllUserAdmin());
        }
      } else {
        emit(RegisterFailed(repositories.user.error));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// admin: mendapatkan info semua user berdasarkan instansi
  getAllUserAdmin(GetAllUserAdmin event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final agency = await _getAgency();
      final users = await repositories.user.getAllUserByAgency(agency);
      if (repositories.user.statusCode == "200") {
        emit(GetAllUserSuccess(users));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// super admin: mendapatkan info semua user
  getAllUserSuperAdmin(
      GetAllUserSuperAdmin event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final users = await repositories.user.getAllUserSuperAdmin();
      if (repositories.user.statusCode == "200") {
        emit(GetAllUserSuccess(users));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// admin: delete user
  deleteUser(DeleteUser event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final userRole = await _getRole();
      await repositories.user.deleteUser(event.id);
      if (repositories.user.statusCode == "200") {
        emit(DeleteSuccess());
        if (userRole == "0") {
          add(GetAllUserSuperAdmin());
        } else if (userRole == "1") {
          add(GetAllUserAdmin());
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// super admin: delete user by agency
  deleteUserSuperAdmin(DeleteUserSuperAdmin event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final userRole = await _getRole();
      await repositories.user.deleteUserSuperAdmin(event.agency);
      if (repositories.user.statusCode == "200") {
        emit(DeleteSuccess());
        if (userRole == "0") {
          add(GetAllUserSuperAdmin());
        } else if (userRole == "1") {
          add(GetAllUserAdmin());
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// admin dan super admin: edit user pada fitur admin
  editUserAdmin(EditUserAdmin event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final userRole = await _getRole();
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
        emit(EditSuccess());
        if (userRole == "0") {
          add(GetAllUserSuperAdmin());
        } else if (userRole == "1") {
          add(GetAllUserAdmin());
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// admin dan super admin: edit username pada fitur admin
  changeUsername(ChangeUsername event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final userRole = await _getRole();
      await repositories.user.changeUsername(
        event.id,
        event.username,
      );
      if (repositories.user.error == "") {
        emit(ChangeUsernameSuccess());
        if (userRole == "0") {
          add(GetAllUserSuperAdmin());
        } else if (userRole == "1") {
          add(GetAllUserAdmin());
        }
      } else {
        emit(ChangeUsernameFailed(repositories.user.error));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///umum: Get Agency
  _getAgency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("agency");
  }

  ///umum: Get role
  _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }
}
