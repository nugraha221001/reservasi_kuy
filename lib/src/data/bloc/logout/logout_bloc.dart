import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/repositories.dart';

part 'logout_event.dart';

part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  Repositories repositories;

  LogoutBloc({required this.repositories}) : super(LogoutInitial()) {
    on<InitialLogout>(initialLogout);
    on<OnLogout>(logoutEvent);
  }

  initialLogout(InitialLogout event, Emitter<LogoutState> emit) {
    emit(LogoutInitial());
  }

  logoutEvent(OnLogout event, Emitter<LogoutState> emit) async {
    emit(LogoutLoading());
    try {
      await repositories.authentication.logout();
      if (repositories.authentication.statusCode == "200") {
        emit(LogoutSuccess());
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
